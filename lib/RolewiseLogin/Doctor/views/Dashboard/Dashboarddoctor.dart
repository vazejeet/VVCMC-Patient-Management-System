import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opd_app/RolewiseLogin/Hayatform/hayatPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/color.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardControllers extends GetxController {
  var diagnosesCount = 0.obs;
  var patientsCount = 0.obs;
  var usersCount = 0.obs;
  var pendingDiagnosisCount = 0.obs;

  // Function to fetch data for all counts
  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> fetchCounts() async {
    final hospitalData =
        await getHospitalAndDoctorNameFromPreferences(); // Retrieve both values

    final hospitalId = hospitalData['hospitalId'];
    final doctorName = hospitalData['DoctorName'];

    if (hospitalId == null || doctorName == null) {
      print('No hospital ID or doctor name found');
      return;
    }

    try {
      // Get Diagnoses Count
      diagnosesCount.value =
          await getDiagnosesCountByDoctor(hospitalId, doctorName);

      patientsCount.value = await getPatientsCount(hospitalId, doctorName);
      // Get Pending Diagnoses Count
      pendingDiagnosisCount.value =
          await getHospitalsCount(hospitalId, doctorName);
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  Future<int> getPatientsCount(String hospitalId, String doctorName) async {
    final url =
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/')
            .replace(queryParameters: {'hospitalId': hospitalId});

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final patients = data['patients'] as List;

        String todayDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now()); // Today's date in YYYY-MM-DD format

        int todayPatientsCount = 0;

        for (var patient in patients) {
          if (patient['DoctorName'] == doctorName &&
              patient['Symptoms'] != null) {
            for (var symptom in patient['Symptoms']) {
              if (symptom['DiagnosisData'] != null &&
                  symptom['DiagnosisData']['DateTime'] != null) {
                // Extract Date from DateTime
                String diagnosisDate =
                    symptom['DiagnosisData']['DateTime'].substring(0, 10);

                // Compare with today's date
                if (diagnosisDate == todayDate) {
                  todayPatientsCount++;
                  break; // Once we count one symptom for a patient, we move to next patient
                }
              }
            }
          }
        }

        return todayPatientsCount;
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error fetching today's patients count: $e");
      return 0;
    }
  }

  Future<int> getHospitalsCount(String hospitalId, String doctorName) async {
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final url =
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients')
            .replace(queryParameters: {'hospitalId': hospitalId});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final patients = data['patients'] as List;

        Set<String> patientsWithNullMedicine =
            {}; // To track unique patients with null or empty Medicine

        for (var patient in patients) {
          if (patient['DoctorName'] == doctorName &&
              patient['Symptoms'] != null) {
            // Sort the symptoms by DateTime to ensure we are checking the latest
            List symptoms = patient['Symptoms'];
            symptoms.sort((a, b) {
              DateTime dateA = DateTime.parse(a['DiagnosisData']['DateTime']);
              DateTime dateB = DateTime.parse(b['DiagnosisData']['DateTime']);
              return dateB.compareTo(
                  dateA); // Sort in descending order (most recent first)
            });

            // Check only the latest symptom for today
            var latestSymptom = symptoms.first;
            String diagnosisDate =
                latestSymptom['DiagnosisData']['DateTime'].substring(0, 10);

            // Only consider the symptom if it's from today
            if (diagnosisDate == todayDate) {
              // Check if Medicine is null or empty
              if (latestSymptom['DiagnosisData']['Medicine'] == null ||
                  latestSymptom['DiagnosisData']['Medicine'].isEmpty) {
                patientsWithNullMedicine.add(patient[
                    '_id']); // Add patient ID to the set if Medicine is null or empty
              }
            }
          }
        }

        return patientsWithNullMedicine
            .length; // Return the number of unique patients with null or empty Medicine today
      } else {
        print("Failed to fetch patients. Status Code: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error fetching patients with null Medicine today: $e");
      return 0;
    }
  }

  Future<int> getDiagnosesCountByDoctor(
      String hospitalId, String doctorName) async {
    final url = Uri.parse(
            'https://vvcmhospitals.codifyinstitute.org/api/patients/patients/diagnoses')
        .replace(queryParameters: {'hospitalId': hospitalId});

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      final patients = data['patients'] as List;

      // Filter and count diagnoses for today based on doctor's name
      final todayDiagnoses = patients.fold(0, (acc, patient) {
        if (patient['CreatedBy'] == hospitalId) {
          final symptoms = patient['Symptoms'] as List?;
          if (symptoms != null) {
            // Filter symptoms based on doctorName and today's date
            final todaySymptoms = symptoms.where((symptom) {
              final symptomDateTime = DateTime.parse(symptom['DateTime']);
              final isDoctorMatch = symptom['DoctorName'] == doctorName;
              final isTodayMatch = isToday(
                  symptomDateTime); // Check if the symptom is from today
              return isDoctorMatch && isTodayMatch;
            }).toList();

            // Add the count of matching symptoms
            return acc + todaySymptoms.length;
          }
        }
        return acc;
      });

      return todayDiagnoses;
    } catch (e) {
      print("Error fetching diagnoses count by doctor: $e");
      return 0;
    }
  }

  Future<Map<String, String?>> getHospitalAndDoctorNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve hospitalId and doctorName from SharedPreferences
    String? hospitalId = prefs.getString('HospitalId');
    String? doctorName = prefs.getString('UserName');

    // Return both values as a Map
    return {'hospitalId': hospitalId, 'DoctorName': doctorName};
  }
}

class DashboardPage extends StatelessWidget {
  final DashboardControllers controller = Get.put(DashboardControllers());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'Dashboard',
            style: TextStyle(color: Appcolor.pure, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Appcolor.Primary,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Appcolor.pure),
              onPressed: () {
                controller.fetchCounts();
              },
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          color: Appcolor.pure,
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<void>(
            future: controller.fetchCounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return RefreshIndicator(
                onRefresh: controller.fetchCounts,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          CountCard(
                            title: 'Patients Count',
                            count: controller.patientsCount,
                          ),
                          CountCard(
                            title: 'Diagnosis Count',
                            count: controller.diagnosesCount,
                          ),
                          CountCard(
                            title: 'Pending Diagnosis',
                            count: controller.pendingDiagnosisCount,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: Obx(() {
                          return PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 50,
                              sections: [
                                PieChartSectionData(
                                  value: controller.diagnosesCount.value
                                      .toDouble(),
                                  color: Appcolor.Primary,
                                  title: 'Diagnosis ',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    color: Appcolor.pure,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                PieChartSectionData(
                                  value:
                                      controller.patientsCount.value.toDouble(),
                                  color: Appcolor.Secondary,
                                  title: 'Patients',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    color: Appcolor.pure,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: controller.pendingDiagnosisCount.value
                                      .toDouble(),
                                  color:
                                      const Color.fromARGB(255, 35, 185, 170),
                                  title: 'Pending',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    color: Appcolor.pure,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //     child: const Icon(
        //       Icons.add,
        //       color: Appcolor.pure,
        //     ),
        //     backgroundColor: Appcolor.Primary,
        //     onPressed: () {
        //       // Get.to(PatientTabPage());
        //       Get.to(HayatFormPage());
        //     }),
      ),
    );
  }
}

class CountCard extends StatelessWidget {
  final String title;
  final RxInt count;

  const CountCard({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: MediaQuery.of(context).size.width < 600
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Appcolor.Primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Appcolor.Secondary.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.pure),
              ),
              const SizedBox(height: 10),
              Text(
                '${count.value}',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.pure),
              ),
            ],
          ),
        ));
  }
}


// class DashboardControllers extends GetxController {
//   var diagnosesCount = 0.obs;
//   var patientsCount = 0.obs;
//   var usersCount = 0.obs;
//   var pendingDiagnosisCount = 0.obs;

//   // Function to fetch data for all counts
//   @override
//   void onInit() {
//     super.onInit();
//     fetchCounts();
//   }

//   bool isToday(DateTime date) {
//   final now = DateTime.now();
//   return date.year == now.year &&
//       date.month == now.month &&
//       date.day == now.day;
// }


//   // Fetch counts using the hospitalId and doctorName retrieved from SharedPreferences
//   Future<void> fetchCounts() async {
//     final hospitalData = await getHospitalAndDoctorNameFromPreferences(); // Retrieve both values

//     final hospitalId = hospitalData['hospitalId'];
//     final doctorName = hospitalData['DoctorName'];

//     if (hospitalId == null || doctorName == null) {
//       print('No hospital ID or doctor name found');
//       return;
//     }

//     try {
//       // Get Diagnoses Count
//       diagnosesCount.value = await getDiagnosesCountByDoctor(hospitalId, doctorName);


//       patientsCount.value = await getPatientsCount(hospitalId , doctorName);
//       // Get Pending Diagnoses Count
//       pendingDiagnosisCount.value = await getHospitalsCount(hospitalId, doctorName);
//     } catch (e) {
//       print('Error fetching counts: $e');
//     }
//   }

//   Future<int> getPatientsCount(String hospitalId, String doctorName) async {
//   final url = Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/')
//       .replace(queryParameters: {'hospitalId': hospitalId});
//   try {
//     final response = await http.get(url);
//     final data = jsonDecode(response.body);
//     final patients = data['patients'] as List;

//     final todayPatients = patients.where((patient) {
//       // Assuming the 'CreatedAt' field exists and is a valid date string
//       final createdAt = DateTime.parse(patient['CreatedAt']);
//       return patient['CreatedBy'] == hospitalId &&
//              patient['DoctorName'] == doctorName &&
//              isToday(createdAt);
//     }).toList();

//     return todayPatients.length;
//   } catch (e) {
//     print("Error fetching patients count: $e");
//     return 0;
//   }
// }



// Future<int> getHospitalsCount(String hospitalId, String doctorName) async {
//   final url = Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/')
//       .replace(queryParameters: {'hospitalId': hospitalId});
//   try {
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final patients = data['patients'] as List;

//       final todayPatients = patients.where((patient) {
//         final createdAt = DateTime.parse(patient['CreatedAt']);
//         return patient['CreatedBy'] == hospitalId &&
//                patient['DoctorName'] == doctorName &&
//                isToday(createdAt);
//       }).toList();

//       final totalSymptoms = todayPatients.fold(0, (acc, patient) {
//         final symptoms = patient['Symptoms'] as List?;
//         if (symptoms != null && symptoms.length == 1) {
//           return acc + 1;
//         }
//         return acc;
//       });

//       return totalSymptoms;
//     } else {
//       print("Failed to fetch patients. Status Code: ${response.statusCode}");
//       return 0;
//     }
//   } catch (e) {
//     print("Error fetching hospital count: $e");
//     return 0;
//   }
// }


// Future<int> getDiagnosesCountByDoctor(String hospitalId, String doctorName) async {
//   final url = Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/patients/diagnoses')
//       .replace(queryParameters: {'hospitalId': hospitalId});
  
//   try {
//     final response = await http.get(url);
//     final data = jsonDecode(response.body);
//     final patients = data['patients'] as List;

//     // Filter and count diagnoses for today based on doctor's name
//     final todayDiagnoses = patients.fold(0, (acc, patient) {
//       if (patient['CreatedBy'] == hospitalId) {
//         final symptoms = patient['Symptoms'] as List?;
//         if (symptoms != null) {
//           // Filter symptoms based on doctorName and today's date
//           final todaySymptoms = symptoms.where((symptom) {
//             final symptomDateTime = DateTime.parse(symptom['DateTime']);
//             final isDoctorMatch = symptom['DoctorName'] == doctorName;
//             final isTodayMatch = isToday(symptomDateTime);  // Check if the symptom is from today
//             return isDoctorMatch && isTodayMatch;
//           }).toList();

//           // Add the count of matching symptoms
//           return acc + todaySymptoms.length;
//         }
//       }
//       return acc;
//     });

//     return todayDiagnoses;
//   } catch (e) {
//     print("Error fetching diagnoses count by doctor: $e");
//     return 0;
//   }
// }


//   // Function to retrieve hospitalId and doctorName from SharedPreferences
//   Future<Map<String, String?>> getHospitalAndDoctorNameFromPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
    
//     // Retrieve hospitalId and doctorName from SharedPreferences
//     String? hospitalId = prefs.getString('HospitalId');
//     String? doctorName = prefs.getString('UserName');
    
//     // Return both values as a Map
//     return {
//       'hospitalId': hospitalId,
//       'DoctorName': doctorName
//     };
//   }

// }


// class DashboardPage extends StatelessWidget {
//   final DashboardControllers controller = Get.put(DashboardControllers());

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 600;

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: Image.asset("assets/logo.png"),
//           title: const Text(
//             'Dashboard',
//             style: TextStyle(color: Appcolor.pure, fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Appcolor.Primary,
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh, color: Appcolor.pure),
//               onPressed: () {
//                 controller.fetchCounts();
//               },
//             ),
//           ],
//         ),
//         body: Container(
//           height: double.infinity,
//           color: Appcolor.pure,
//           padding: const EdgeInsets.all(16.0),
//           child: FutureBuilder<void>(
//             future: controller
//                 .fetchCounts(), // Assuming this is an async method that fetches the counts
//             builder: (context, snapshot) {
//               // Check the loading state
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               // Check if there was an error
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }

//               // If the data is loaded
//               return RefreshIndicator(
//                 onRefresh: controller.fetchCounts,
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Wrap(
//                         spacing: 16,
//                         runSpacing: 16,
//                         alignment: WrapAlignment.spaceEvenly,
//                         children: [
//                           CountCard(
//                             title: 'Patients Count',
//                             count: controller.patientsCount,
//                           ),
//                           CountCard(
//                             title: 'Diagnosis Count',
//                             count: controller.diagnosesCount,
//                           ),
//                           CountCard(
//                             title: 'Pending Diagnosis',
//                             count: controller.pendingDiagnosisCount,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         height: 250,
//                         child: Obx(() {
//                           return PieChart(
//                             PieChartData(
//                               sectionsSpace: 0, // No space between the sections
//                               centerSpaceRadius:
//                                   50, // This creates the 'hole' in the center
//                               sections: [
//                                 PieChartSectionData(
//                                   value: controller.diagnosesCount.value
//                                       .toDouble(),
//                                   color: Appcolor.Primary,
//                                   title: 'Diagnosis ',
//                                   radius: 50, // Size of the donut sections
//                                   titleStyle: const TextStyle(
//                                     color: Appcolor.pure,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 PieChartSectionData(
//                                   value:
//                                       controller.patientsCount.value.toDouble(),
//                                   color: Appcolor.Secondary,
//                                   title: 'Patients',
//                                   radius: 50,
//                                   titleStyle: const TextStyle(
//                                     color: Appcolor.pure,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 PieChartSectionData(
//                                   value: controller.pendingDiagnosisCount.value
//                                       .toDouble(),
//                                   color:
//                                       const Color.fromARGB(255, 35, 185, 170),
//                                   title: 'Pending',
//                                   radius: 50,
//                                   titleStyle: const TextStyle(
//                                     color: Appcolor.pure,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CountCard extends StatelessWidget {
//   final String title;
//   final RxInt count;

//   const CountCard({
//     Key? key,
//     required this.title,
//     required this.count,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//           width: MediaQuery.of(context).size.width < 600
//               ? double.infinity
//               : MediaQuery.of(context).size.width * 0.4,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Appcolor.Primary,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Appcolor.Secondary.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 8,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Appcolor.pure),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 '${count.value}',
//                 style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Appcolor.pure),
//               ),
//             ],
//           ),
//         ));
//   }
// }





//         // body: Container(
//         //   height: double.infinity,
//         //  color: Appcolor.pure,
//         //   padding: const EdgeInsets.all(16.0),
//         //   child: RefreshIndicator(
//         //     onRefresh: controller.fetchCounts,
//         //     child: SingleChildScrollView(
//         //       physics: AlwaysScrollableScrollPhysics(),
//         //       child: Column(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           Wrap(
//         //             spacing: 16,
//         //             runSpacing: 16,
//         //             alignment: WrapAlignment.spaceEvenly,
//         //             children: [
//         //               CountCard(
//         //                   title: 'Patients Count',
//         //                   count: controller.patientsCount),
//         //               CountCard(
//         //                   title: 'Diagnosis Count',
//         //                   count: controller.diagnosesCount),
//         //               CountCard(
//         //                   title: 'Pending Diagnosis',
//         //                   count: controller.pendingDiagnosisCount),
//         //             ],
//         //           ),
//         //           SizedBox(height: 20),
//         //           SizedBox(
//         //             height: 250,
//         //             child: Obx(() {
//         //               return PieChart(
//         //                 PieChartData(
//         //                   sectionsSpace: 0, // No space between the sections
//         //                   centerSpaceRadius:
//         //                       50, // This creates the 'hole' in the center
//         //                   sections: [
//         //                     PieChartSectionData(
//         //                       value: controller.diagnosesCount.value.toDouble(),
//         //                       color: Appcolor.Primary,
//         //                       title: 'Diagnosis ',
//         //                       radius: 50, // Size of the donut sections
//         //                       titleStyle: TextStyle(
//         //                           color: Appcolor.pure,
//         //                           fontWeight: FontWeight.bold,
//         //                           fontSize: 16),
//         //                     ),
//         //                     PieChartSectionData(
//         //                       value: controller.patientsCount.value.toDouble(),
//         //                       color: Appcolor.Secondary,
//         //                       title: 'Patients',
//         //                       radius: 50,
//         //                       titleStyle: TextStyle(
//         //                           color: Appcolor.pure,
//         //                           fontWeight: FontWeight.bold,
//         //                           fontSize: 16),
//         //                     ),
//         //                     PieChartSectionData(
//         //                       value: controller.pendingDiagnosisCount.value
//         //                           .toDouble(),
//         //                       color: Color.fromARGB(255, 35, 185, 170),
//         //                       title: 'Pending',
//         //                       radius: 50,
//         //                       titleStyle: TextStyle(
//         //                           color: Appcolor.pure,
//         //                           fontWeight: FontWeight.bold,
//         //                           fontSize: 16),
//         //                     ),
//         //                   ],
//         //                 ),
//         //               );
//         //             }),
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),


