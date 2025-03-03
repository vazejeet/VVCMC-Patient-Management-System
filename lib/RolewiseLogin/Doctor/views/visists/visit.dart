import 'package:opd_app/RolewiseLogin/Doctor/controllers/DoctorPatientController.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/visists/detailvisit.dart';
import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class visit extends StatelessWidget {
  final PatientController doctorPatientController =
      Get.put(PatientController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'Today'.obs;
  final Rx<DateTimeRange?> customDateRange = Rx(null);

  void applyDateFilter(String filter) {
    switch (filter) {
      case 'Today':
        doctorPatientController.filterPatientsByDate('Today');
        break;
      case 'Yesterday':
        doctorPatientController.filterPatientsByDate('Yesterday');
        break;
      case 'This Week':
        doctorPatientController.filterPatientsByDate('This Week');
        break;
      case 'This Month':
        doctorPatientController.filterPatientsByDate('This Month');
        break;
      case 'This Year':
        doctorPatientController.filterPatientsByDate('This Year');
        break;
      case 'Custom':
        if (customDateRange.value != null) {
          doctorPatientController.filterPatientsByDate(
              'Custom', customDateRange.value);
        }
        break;
      default:
        doctorPatientController.filterPatientsByDate('Today');
    }
  }

  Future<void> selectCustomDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: customDateRange.value,
    );
    if (picked != null) {
      customDateRange.value = picked;
      selectedFilter.value = 'Custom';
      applyDateFilter('Custom');
    }
  }

  String formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            "Patients",
            style: TextStyle(
              fontSize: 22,
              color: Appcolor.pure,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Appcolor.Primary,
          actions: [
            Obx(() => DropdownButton<String>(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  dropdownColor: Appcolor.Primary,
                  value: selectedFilter.value,
                  items: [
                    'Today',
                    'Yesterday',
                    'This Week',
                    'This Month',
                    'This Year',
                    'Custom'
                  ].map((filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(
                        filter,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedFilter.value = value;
                      if (value == 'Custom') {
                        selectCustomDateRange(context);
                      } else {
                        applyDateFilter(value);
                      }
                    }
                  },
                )),
            // IconButton(
            //   icon: const Icon(Icons.refresh, color: Appcolor.pure),
            //   onPressed: () async {
            //     await doctorPatientController.refreshPatients();
            //   },
            // ),
          ],
        ),
        body: Container(
          color: Appcolor.pure,
          child: FutureBuilder<void>(
            future: doctorPatientController.fetchPatients(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: (query) {
                          searchQuery.value = query.toLowerCase();
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
                      child: FutureBuilder<SharedPreferences>(
                        future: SharedPreferences.getInstance(),
                        builder: (context, prefSnapshot) {
                          if (prefSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (prefSnapshot.hasData) {
                            String? hospitalId =
                                prefSnapshot.data?.getString('HospitalId');
                            String? hospitalName =
                                prefSnapshot.data?.getString('UserName');

                            if (hospitalId != null &&
                                hospitalId.isNotEmpty &&
                                hospitalName != null &&
                                hospitalName.isNotEmpty) {
                              return Obx(() {
                                if (doctorPatientController.isLoading.value) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  var filteredPatients = doctorPatientController
                                      .filteredPatientsList
                                      .where((patient) =>
                                          patient.symptoms != null &&
                                          patient.symptoms.isNotEmpty &&
                                          patient.patientName
                                              .toLowerCase()
                                              .contains(searchQuery.value))
                                      .toList()
                                    ..sort((a, b) =>
                                        b.createdAt.compareTo(a.createdAt));

                                  if (filteredPatients.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'No patients found.',
                                        style: TextStyle(
                                            color: Appcolor.Primary,
                                            fontSize: 18),
                                      ),
                                    );
                                  }

                                  return RefreshIndicator(
                                    onRefresh: () async {
                                      await doctorPatientController
                                          .fetchPatients();
                                    },
                                    child: ListView.builder(
                                      itemCount: filteredPatients.length,
                                      itemBuilder: (context, index) {
                                        var patient = filteredPatients[index];
                                        DateTime createdAtDate =
                                            DateTime.tryParse(
                                                    patient.createdAt) ??
                                                DateTime.now();
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd')
                                                .format(createdAtDate);

                                        String diagnosisDate = patient
                                                    .symptoms.isNotEmpty &&
                                                patient
                                                        .symptoms
                                                        .first
                                                        .diagnosisData
                                                        ?.dateTime !=
                                                    null
                                            ? DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(patient
                                                    .symptoms
                                                    .first
                                                    .diagnosisData!
                                                    .dateTime!))
                                            : "No Diagnosis Date";

                                        return Card(
                                          color: Appcolor.Primary,
                                          shadowColor:
                                              Appcolor.Secondary.withOpacity(
                                                  0.4),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 8.0,
                                            ),
                                            title: Text(
                                              patient.patientName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Appcolor.pure,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "Age: ${patient.age},\nRegistration Date: $diagnosisDate",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Appcolor.pure,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Appcolor.pure,
                                            ),
                                            onTap: () {
                                              Get.to(() => visitsdetails(
                                                  patient: patient));
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              });
                            } else {
                              return const Center(
                                  child: Text(
                                      "Hospital ID or Hospital Name is missing"));
                            }
                          } else {
                            return const Center(
                                child: Text("Error fetching preferences"));
                          }
                        },
                      ),
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
        //  color: Appcolor.pure,
        //   child: Column(
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.symmetric(
        //             horizontal: 16.0, vertical: 8.0),
        //         child: TextField(
        //           controller: searchController,
        //           onChanged: (query) {
        //             searchQuery.value = query.toLowerCase();
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
        //           if (doctorPatientController.isLoading.value) {
        //             return const Center(child: CircularProgressIndicator());
        //           } else {
        //             var filteredPatients = doctorPatientController
        //                 .filteredPatientsList
        //                 .where((patient) =>
        //                     patient.symptoms != null &&
        //                     patient.symptoms.isNotEmpty &&
        //                     patient.patientName
        //                         .toLowerCase()
        //                         .contains(searchQuery.value))
        //                 .toList()
        //               ..sort((a, b) =>
        //                   b.createdAt.compareTo(a.createdAt));

        //             if (filteredPatients.isEmpty) {
        //               return const Center(
        //                 child: Text(
        //                   'No patients found.',
        //                   style: TextStyle(color: Appcolor.Primary, fontSize: 18),
        //                 ),
        //               );
        //             }

        //             return RefreshIndicator(
        //               onRefresh: () async {
        //                 await doctorPatientController.fetchPatients();
        //               },
        //               child: ListView.builder(
        //                 itemCount: filteredPatients.length,
        //                 itemBuilder: (context, index) {
        //                   var patient = filteredPatients[index];
        //                   DateTime createdAtDate =
        //                       DateTime.tryParse(patient.createdAt) ??
        //                           DateTime.now();
        //                   String formattedDate =
        //                       DateFormat('yyyy-MM-dd').format(createdAtDate);
        //                        String diagnosisDate = patient.symptoms.isNotEmpty &&
        //                                 patient.symptoms.first.diagnosisData?.dateTime != null
        //                             ? DateFormat('yyyy-MM-dd').format(
        //                                 DateTime.parse(patient.symptoms.first.diagnosisData!.dateTime!))
        //                             : "No Diagnosis Date";
        //                   return Card(
        //                     color: Appcolor.Primary,
        //                     shadowColor: Appcolor.Secondary.withOpacity(0.4),
        //                     margin: const EdgeInsets.symmetric(
        //                         horizontal: 10, vertical: 6),
        //                     elevation: 6,
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(12.0),
        //                     ),
        //                     child: ListTile(
        //                       contentPadding: const EdgeInsets.symmetric(
        //                         horizontal: 16.0,
        //                         vertical: 8.0,
        //                       ),
        //                       title: Text(
        //                         patient.patientName,
        //                         style: const TextStyle(
        //                           fontSize: 18,
        //                           fontWeight: FontWeight.bold,
        //                           color: Appcolor.pure,
        //                         ),
        //                       ),
        //                        subtitle: Text(
        //                               "Age: ${patient.age},\nRegistration Date: $diagnosisDate",
        //                               style: const TextStyle(
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.w400,
        //                                 color: Appcolor.pure,
        //                               ),
        //                             ),
        //                       trailing: const Icon(
        //                         Icons.arrow_forward_ios,
        //                         color: Appcolor.pure,
        //                       ),
        //                       onTap: () {
        //                         Get.to(() => visitsdetails(patient: patient));
        //                       },
        //                     ),
        //                   );
        //                 },
        //               ),
        //             );
        //           }
        //         }),
        //       ),
        //     ],
        //   ),
        // ),