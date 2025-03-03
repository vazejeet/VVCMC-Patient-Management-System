import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Dashboard/DoctorDiagnosis.dart';
import 'doctordiagnosisdeatil.dart';

class PatientListPage extends StatelessWidget {
  final DoctorDiagnosis controller = Get.put(DoctorDiagnosis());

  Future<void> selectCustomDateRange(BuildContext context) async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (pickedDateRange != null) {
      controller.customStartDate = pickedDateRange.start;
      controller.customEndDate = pickedDateRange.end;
      controller.selectedFilter.value = 'Custom'; // Update the filter to custom
      controller.applyFilter('Custom'); // Apply the filter
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: Obx(() {
            String filter = controller.selectedFilter.value;
            return Text(
              'Diagnosed Patients (${filter.isEmpty ? "All" : filter})',
              style: const TextStyle(color: Appcolor.pure),
            );
          }),
          backgroundColor: Appcolor.Primary,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list, color: Appcolor.pure),
              onSelected: (filter) async {
                if (filter == 'Custom') {
                  await selectCustomDateRange(
                      context); // Show date range picker
                } else {
                  controller.applyFilter(filter); // Apply the selected filter
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'Today',
                    child: Row(
                      children: [
                        Icon(Icons.today, color: Appcolor.Primary),
                        SizedBox(width: 10),
                        Text('Today'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Yesterday',
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Appcolor.Primary),
                        SizedBox(width: 10),
                        Text('Yesterday'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'This Week',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_view_week, color: Appcolor.Primary),
                        SizedBox(width: 10),
                        Text('This Week'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'This Month',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Appcolor.Primary),
                        SizedBox(width: 10),
                        Text('This Month'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'This Year',
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Appcolor.Primary),
                        SizedBox(width: 10),
                        Text('This Year'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Custom',
                    child: Row(
                      children: [
                        Icon(Icons.date_range, color: Appcolor.Primary),
                        SizedBox(width: 10),
                        Text('Custom Date Range'),
                      ],
                    ),
                  ),
                ];
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Appcolor.pure),
              onPressed: () async {
                await controller.refreshPatients();
              },
            ),
          ],
        ),
        body: Container(
          color: Appcolor.pure,
          child: FutureBuilder<void>(
            future: controller
                .fetchPatients(), // Call the fetch method here to get the data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show loading spinner while fetching
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Error: ${snapshot.error}')); // Show error message if fetching fails
              } else {
                // If data is successfully fetched, display the rest of the UI
                return Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        onChanged: (query) {
                          controller.updateSearchQuery(query);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          hintStyle: const TextStyle(color: Appcolor.Primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Appcolor.Primary),
                          ),
                          filled: true,
                          fillColor: Appcolor.pure.withOpacity(0.8),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Appcolor.Primary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (controller.filteredPatients.isEmpty) {
                          return const Center(
                            child: Text(
                              'No patients found',
                              style: TextStyle(color: Appcolor.Primary),
                            ),
                          );
                        }

                        // Sort the patient list based on the latest symptom date in descending order
                        List sortedPatients =
                            controller.filteredPatients.toList();
                        sortedPatients.sort((a, b) {
                          DateTime latestDateA = DateTime.parse(
                            (a['Symptoms'] as List)
                                .map((symptom) =>
                                    DateTime.parse(symptom['DateTime']))
                                .reduce((a, b) => a.isAfter(b) ? a : b)
                                .toString(),
                          );

                          DateTime latestDateB = DateTime.parse(
                            (b['Symptoms'] as List)
                                .map((symptom) =>
                                    DateTime.parse(symptom['DateTime']))
                                .reduce((a, b) => a.isAfter(b) ? a : b)
                                .toString(),
                          );

                          return latestDateB
                              .compareTo(latestDateA); // Descending order
                        });

                        return RefreshIndicator(
                          onRefresh: controller.refreshPatients,
                          child: ListView.builder(
                            itemCount: sortedPatients.length,
                            itemBuilder: (context, index) {
                              final patient = sortedPatients[index];

                              // Sort symptoms by date in descending order (latest first)
                              List symptoms = patient['Symptoms'];
                              symptoms.sort((a, b) =>
                                  DateTime.parse(b['DateTime']).compareTo(
                                      DateTime.parse(a['DateTime'])));

                              // Get the latest symptom
                              var latestSymptom = symptoms.first;
                              var date =
                                  DateTime.parse(latestSymptom['DateTime']);
                              var formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);

                              return Card(
                                margin: const EdgeInsets.all(16),
                                elevation: 4,
                                color: Appcolor.Primary.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Appcolor.pure,
                                  ),
                                  title: Text(
                                    patient['PatientName'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Appcolor.pure,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Mobile No: ${patient['MobileNo']}\nDate: $formattedDate',
                                    style: const TextStyle(
                                      color: Appcolor.pure,
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() =>
                                        PatientDetailPage(patient: patient));
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }
            },
          ),
        ),

        // body: Container(
        //   color: Appcolor.pure,
        //   child: Column(
        //     children: [
        //       // Search Bar
        //       Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //         child: TextField(
        //           onChanged: (query) {
        //             controller.updateSearchQuery(query);
        //           },
        //           decoration: InputDecoration(
        //             hintText: 'Search by name...',
        //             hintStyle: const TextStyle(color: Appcolor.Primary),
        //             border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(8.0),
        //               borderSide: const BorderSide(color: Appcolor.Primary),
        //             ),
        //             filled: true,
        //             fillColor: Appcolor.pure.withOpacity(0.8),
        //             prefixIcon: const Icon(
        //               Icons.search,
        //               color: Appcolor.Primary,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Obx(() {
        //           if (controller.isLoading.value) {
        //             return const Center(child: CircularProgressIndicator());
        //           }

        //           if (controller.filteredPatients.isEmpty) {
        //             return const Center(
        //               child: Text(
        //                 'No patients found',
        //                 style: TextStyle(color: Appcolor.Primary),
        //               ),
        //             );
        //           }

        //           List sortedPatients = controller.filteredPatients.toList();
        //           sortedPatients.sort((a, b) {
        //             DateTime latestDateA = DateTime.parse(
        //               (a['Symptoms'] as List)
        //                   .map((symptom) => DateTime.parse(symptom['DateTime']))
        //                   .reduce((a, b) => a.isAfter(b) ? a : b)
        //                   .toString(),
        //             );

        //             DateTime latestDateB = DateTime.parse(
        //               (b['Symptoms'] as List)
        //                   .map((symptom) => DateTime.parse(symptom['DateTime']))
        //                   .reduce((a, b) => a.isAfter(b) ? a : b)
        //                   .toString(),
        //             );

        //             return latestDateB.compareTo(latestDateA);
        //           });

        //           return RefreshIndicator(
        //             onRefresh: controller.refreshPatients,
        //             child: ListView.builder(
        //               itemCount: sortedPatients.length,
        //               itemBuilder: (context, index) {
        //                 final patient = sortedPatients[index];

        //                 List symptoms = patient['Symptoms'];
        //                 symptoms.sort((a, b) => DateTime.parse(b['DateTime'])
        //                     .compareTo(DateTime.parse(a['DateTime'])));

        //                 var latestSymptom = symptoms.first;
        //                 var date = DateTime.parse(latestSymptom['DateTime']);
        //                 var formattedDate =
        //                     DateFormat('yyyy-MM-dd').format(date);

        //                 return Card(
        //                   margin: const EdgeInsets.all(16),
        //                   elevation: 4,
        //                   color: Appcolor.Primary.withOpacity(0.8),
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(15.0),
        //                   ),
        //                   child: ListTile(
        //                     trailing: const Icon(
        //                       Icons.arrow_forward_ios,
        //                       color: Appcolor.pure,
        //                     ),
        //                     title: Text(
        //                       patient['PatientName'],
        //                       style: const TextStyle(
        //                         fontSize: 20,
        //                         fontWeight: FontWeight.bold,
        //                         color: Appcolor.pure,
        //                       ),
        //                     ),
        //                     subtitle: Text(
        //                       'Mobile No: ${patient['MobileNo']}\nDate: $formattedDate',
        //                       style: const TextStyle(
        //                         color: Appcolor.pure,
        //                       ),
        //                     ),
        //                     onTap: () {
        //                       Get.to(() => PatientDetailPage(patient: patient));
        //                     },
        //                   ),
        //                 );
        //               },
        //             ),
        //           );
        //         }),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
