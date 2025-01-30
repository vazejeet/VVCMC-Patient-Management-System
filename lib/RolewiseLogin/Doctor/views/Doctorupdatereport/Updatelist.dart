import 'package:opd_app/RolewiseLogin/Doctor/views/Doctorupdatereport/UpdatePatientPage.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/Doctorupdatereport/updatecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opd_app/utils/color.dart';
import 'package:intl/intl.dart';

class UpdateList extends StatelessWidget {
  final UpdateListController controller = Get.put(UpdateListController());

  // Show a dialog to select a custom date range
  Future<void> selectCustomDateRange(BuildContext context) async {
    DateTimeRange? pickedDateRange = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: 100, // Width of the date range picker dialog
              height: 150, // Height of the date range picker dialog
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select Date Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.Primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTimeRange? range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                      );
                      if (range != null) {
                        Navigator.of(context).pop(range);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolor.Primary,
                    ),
                    child: const Text('Pick Date Range'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (pickedDateRange != null) {
      controller.customStartDate = pickedDateRange.start;
      controller.customEndDate = pickedDateRange.end;
      controller.selectedFilter.value = 'Custom'; // Update the filter to custom
      controller.applyFilter('Custom');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'Diagnosed Patients',
            style: TextStyle(color: Appcolor.pure),
          ),
          backgroundColor: Appcolor.Primary,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.refresh, color: Appcolor.pure),
          //     onPressed: () async {
          //       await controller.refreshPatients();
          //     },
          //   ),
          // ],
        ),
        body: Container(
          color: Appcolor.pure,
          child: FutureBuilder<void>(
            future: controller
                .fetchPatients(), // Replace with the method to fetch patient data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading spinner while fetching data
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Show error message if there is an error
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Proceed with the UI if the data is successfully fetched
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

                        // Filter patients whose latest symptom is today
                        List filteredTodayPatients =
                            controller.filteredPatients.where((patient) {
                          List symptoms = patient['Symptoms'];
                          if (symptoms.isEmpty) return false;

                          // Sort symptoms by date in descending order
                          symptoms.sort((a, b) => DateTime.parse(b['DateTime'])
                              .compareTo(DateTime.parse(a['DateTime'])));

                          // Get the latest symptom date
                          DateTime latestSymptomDate =
                              DateTime.parse(symptoms.first['DateTime']);
                          DateTime today = DateTime.now();
                          return latestSymptomDate.year == today.year &&
                              latestSymptomDate.month == today.month &&
                              latestSymptomDate.day == today.day;
                        }).toList();

                        if (filteredTodayPatients.isEmpty) {
                          return const Center(
                            child: Text(
                              'No patients found for today',
                              style: TextStyle(color: Appcolor.Primary),
                            ),
                          );
                        }

                        // Sort the filtered patients based on the latest symptom date in descending order
                        filteredTodayPatients.sort((a, b) {
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
                            itemCount: filteredTodayPatients.length,
                            itemBuilder: (context, index) {
                              final patient = filteredTodayPatients[index];

                              // Sort symptoms by date in descending order
                              List symptoms = patient['Symptoms'];
                              symptoms.sort((a, b) =>
                                  DateTime.parse(b['DateTime']).compareTo(
                                      DateTime.parse(a['DateTime'])));

                              // Get the latest symptom
                              var latestSymptom = symptoms.first;
                              var date =
                                  DateTime.parse(latestSymptom['DateTime']);
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
                                    patient['PatientName'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Appcolor.pure,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Mobile No: ${patient['MobileNo'] ?? 'Unknown'}',
                                    style: const TextStyle(
                                      color: Appcolor.pure,
                                    ),
                                  ),
                                  onTap: () {
                                    // Navigate to the Update page for the patient
                                    Get.to(() =>
                                        UpdatePatientPage(patient: patient));
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
      ),
    );
  }
}


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

        //           // Filter patients whose latest symptom is today
        //           List filteredTodayPatients =
        //               controller.filteredPatients.where((patient) {
        //             List symptoms = patient['Symptoms'];
        //             if (symptoms.isEmpty) return false;

        //             // Sort symptoms by date in descending order
        //             symptoms.sort((a, b) => DateTime.parse(b['DateTime'])
        //                 .compareTo(DateTime.parse(a['DateTime'])));

        //             // Get the latest symptom date
        //             DateTime latestSymptomDate =
        //                 DateTime.parse(symptoms.first['DateTime']);
        //             DateTime today = DateTime.now();
        //             return latestSymptomDate.year == today.year &&
        //                 latestSymptomDate.month == today.month &&
        //                 latestSymptomDate.day == today.day;
        //           }).toList();

        //           if (filteredTodayPatients.isEmpty) {
        //             return const Center(
        //               child: Text(
        //                 'No patients found for today',
        //                 style: TextStyle(color: Appcolor.Primary),
        //               ),
        //             );
        //           }

        //           // Sort the filtered patients based on the latest symptom date in descending order
        //           filteredTodayPatients.sort((a, b) {
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

        //             return latestDateB
        //                 .compareTo(latestDateA); // Descending order
        //           });

        //           return RefreshIndicator(
        //             onRefresh: controller.refreshPatients,
        //             child: ListView.builder(
        //               itemCount: filteredTodayPatients.length,
        //               itemBuilder: (context, index) {
        //                 final patient = filteredTodayPatients[index];

        //                 // Sort symptoms by date in descending order
        //                 List symptoms = patient['Symptoms'];
        //                 symptoms.sort((a, b) => DateTime.parse(b['DateTime'])
        //                     .compareTo(DateTime.parse(a['DateTime'])));

        //                 // Get the latest symptom
        //                 var latestSymptom = symptoms.first;
        //                 var date = DateTime.parse(latestSymptom['DateTime']);
        //                 DateFormat('yyyy-MM-dd').format(date);

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
        //                       patient['PatientName'] ?? 'Unknown',
        //                       style: const TextStyle(
        //                         fontSize: 20,
        //                         fontWeight: FontWeight.bold,
        //                         color: Appcolor.pure,
        //                       ),
        //                     ),
        //                     subtitle: Text(
        //                       'Mobile No: ${patient['MobileNo'] ?? 'Unknown'}',
        //                       style: const TextStyle(
        //                         color: Appcolor.pure,
        //                       ),
        //                     ),
        //                     onTap: () {
        //                       // Navigate to the Update page for the patient
        //                       Get.to(() => UpdatePatientPage(patient: patient));
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