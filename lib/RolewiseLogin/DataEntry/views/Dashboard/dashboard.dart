import 'dart:async';
import 'package:opd_app/RolewiseLogin/DataEntry/views/TabBar/PatientAddTwo.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/color.dart';

class DashboardController extends GetxController {
  var diagnosesCount = 0.obs;
  var patientsCount = 0.obs;
  var pendingDiagnosisCount = 0.obs;

  // Fetch counts when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }

  // Function to fetch all counts
  Future<void> fetchCounts() async {
    final hospitalData = await getHospitalAndDataEntryNameFromPreferences();

    final hospitalId = hospitalData['hospitalId'];
    final dataentryname = hospitalData['DataEntryName'];

    if (hospitalId == null || dataentryname == null) {
      print('No hospital ID or DataEntryName found');
      return;
    }

    try {
      patientsCount.value =
          await getUniqueTodayDiagnosisCount(hospitalId, dataentryname);
      pendingDiagnosisCount.value =
          await countPatientsWithNullMedicineToday(hospitalId, dataentryname);
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  // Function to retrieve hospitalId and dataentryname from SharedPreferences
  Future<Map<String, String?>>
      getHospitalAndDataEntryNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hospitalId = prefs.getString('HospitalId');
    String? dataentryname = prefs.getString('UserName');

    return {
      'hospitalId': hospitalId,
      'DataEntryName': dataentryname,
    };
  }

// Get today's date in the format "yyyy-MM-dd"
  String getTodayDate() {
    final today = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(today);
  }

  Future<int> getUniqueTodayDiagnosisCount(
      String hospitalId, String dataEntryName) async {
    final url =
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/')
            .replace(queryParameters: {'hospitalId': hospitalId});

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final patients = data['patients'] as List;

        String todayDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now()); // Aajchya date cha format
        Set<String> uniquePatients =
            {}; // Unique patient IDs store karnya sathi

        for (var patient in patients) {
          if (patient['DataEntryName'] == dataEntryName &&
              patient['Symptoms'] != null) {
            for (var symptom in patient['Symptoms']) {
              if (symptom['DiagnosisData'] != null &&
                  symptom['DiagnosisData']['DateTime'] != null) {
                // Extract Date from DateTime
                String diagnosisDate =
                    symptom['DiagnosisData']['DateTime'].substring(0, 10);

                if (diagnosisDate == todayDate) {
                  uniquePatients
                      .add(patient['_id']); // Patient ID store karaycha
                  break; // Ekda count jhala ki loop madhun break
                }
              }
            }
          }
        }

        return uniquePatients.length; // Unique patient count return karel
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error fetching today's unique diagnosis count: $e");
      return 0;
    }
  }

  Future<int> countPatientsWithNullMedicineToday(
      String hospitalId, String dataEntryName) async {
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
            {}; // To track unique patients with null Medicine field

        for (var patient in patients) {
          if (patient['DataEntryName'] == dataEntryName &&
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
}

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

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
                controller.fetchCounts(); // Refresh data on button press
              },
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          color: Appcolor.pure,
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: controller.fetchCounts,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Count Cards (displaying the four counts)
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      CountCard(
                          title: 'Patients Count',
                          count: controller.patientsCount),
                      CountCard(
                          title: 'Pending Diagnosis',
                          count: controller.pendingDiagnosisCount),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Donut Chart for Counts
                  SizedBox(
                    height: 250,
                    child: Obx(() {
                      return PieChart(
                        PieChartData(
                          sectionsSpace: 0, // No space between the sections
                          centerSpaceRadius:
                              50, // This creates the 'hole' in the center
                          sections: [
                            PieChartSectionData(
                              value: controller.patientsCount.value.toDouble(),
                              color: Appcolor.Secondary,
                              title: 'Patients',
                              radius: 50,
                              titleStyle: TextStyle(
                                  color: Appcolor.pure,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            PieChartSectionData(
                              value: controller.pendingDiagnosisCount.value
                                  .toDouble(),
                              color: Color.fromARGB(255, 35, 185, 170),
                              title: 'Pending',
                              radius: 50,
                              titleStyle: TextStyle(
                                  color: Appcolor.pure,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Appcolor.pure,
            ),
            backgroundColor: Appcolor.Primary,
            onPressed: () {
              // Get.to(PatientTabPage());
              Get.to(PatientAddTwo());
            }),
        // backgroundColor: Appcolor.Primary,
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
