import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/color.dart';

class DashboardControlleer extends GetxController {
  var diagnosesCount = 0.obs;
  var patientsCount = 0.obs;
  var usersCount = 0.obs;
  var pendingDiagnosisCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }



  Future<void> fetchCounts() async {
    final hospitalId = await getHospitalIdFromPreferences();

    if (hospitalId == null) {
      print('No hospital ID found');
      return;
    }

    try {
      // Get Diagnoses Count
      diagnosesCount.value = await getDiagnosesCount(hospitalId);

      // Get Patients Count
      patientsCount.value = await getPatientsCount(hospitalId);

      // Get Users Count
      usersCount.value = await getUsersCount(hospitalId);

      // Get Pending Diagnoses Count
      pendingDiagnosisCount.value = await getHospitalsCount(hospitalId);
    } catch (e) {
      print('Error fetching counts: $e');
    }
  }

  Future<String?> getHospitalIdFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('HospitalId');
  }

  Future<int> getDiagnosesCount(String hospitalId) async {
    final url = Uri.parse(
            'https://vvcmhospitals.codifyinstitute.org/api/patients/patients/diagnoses')
        .replace(queryParameters: {'hospitalId': hospitalId});

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      final patients = data['patients'] as List;

      final count = patients.fold(0, (acc, patient) {
        if (patient['CreatedBy'] == hospitalId) {
          final symptoms = patient['Symptoms'] as List?;
          if (symptoms != null) {
            return acc + (symptoms.length - 1);
          }
        }
        return acc;
      });

      return count;
    } catch (e) {
      print("Error fetching diagnoses count: $e");
      return 0;
    }
  }

  // Function to fetch Patients Count based on hospitalId
  Future<int> getPatientsCount(String hospitalId) async {
    final url =
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/')
            .replace(queryParameters: {'hospitalId': hospitalId});
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      final patients = data['patients'] as List;
      // Count the patients based on hospitalId
      final filteredPatients = patients
          .where((patient) => patient['CreatedBy'] == hospitalId)
          .toList();
      return filteredPatients.length;
    } catch (e) {
      print("Error fetching patients count: $e");
      return 0;
    }
  }

  // Function to fetch Users Count based on hospitalId
  Future<int> getUsersCount(String hospitalId) async {
    final url =
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/users/users')
            .replace(queryParameters: {'hospitalId': hospitalId});
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      final users = data['users'] as List;
      // Count users that belong to the hospital
      return users.where((user) => user['Hospital'] == hospitalId).length;
    } catch (e) {
      print("Error fetching users count: $e");
      return 0;
    }
  }

  Future<int> getHospitalsCount(String hospitalId) async {
    final url = Uri.parse(
            'https://vvcmhospitals.codifyinstitute.org/api/patients/patients/diagnoses')
        .replace(queryParameters: {'hospitalId': hospitalId});

    try {
      final response = await http.get(url);

      // Fetch the total patients count (if needed later)
      final totalPatientsCount = await getPatientsCount(hospitalId);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final patients = data['patients'] as List;

        // Filter patients based on hospitalId
        final filteredPatients = patients.where((patient) {
          return patient['CreatedBy'] == hospitalId;
        }).toList();

        // Count the number of symptoms (where Symptoms array has exactly one item)
        final totalSymptoms = filteredPatients.fold(0, (acc, patient) {
          final symptoms =
              patient['Symptoms'] != null && patient['Symptoms'].length == 1
                  ? 1
                  : 0;
          return acc + symptoms;
        });

        // Calculate pending diagnosis count based on total patients count and total symptoms
        final pendingDiagnosisCount = totalPatientsCount - totalSymptoms > 0
            ? totalPatientsCount - totalSymptoms
            : 0;

        print('Pending Diagnoses Count: $pendingDiagnosisCount');
        return totalSymptoms;
      } else {
        print("Failed to load data. Status code: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error fetching pending diagnoses count: $e");
      return 0;
    }
  }
}

class DashboarPage extends StatelessWidget {
  final DashboardControlleer controller = Get.put(DashboardControlleer());

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: Text(
            'Dashboard',
            style: TextStyle(color: Appcolor.pure, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Appcolor.Primary,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Appcolor.pure),
              onPressed: () {
                controller.fetchCounts(); // Refresh data on button press
              },
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Appcolor.Primary.withOpacity(0.8),
                Appcolor.Secondary.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
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
                          title: 'Diagnosis Count',
                          count: controller.diagnosesCount),
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
                              value: controller.diagnosesCount.value.toDouble(),
                              color: Appcolor.Primary,
                              title: 'Diagnosis ',
                              radius: 50, // Size of the donut sections
                              titleStyle: TextStyle(
                                  color: Appcolor.pure,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
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
          padding: EdgeInsets.all(16),
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
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.pure),
              ),
              SizedBox(height: 10),
              Text(
                '${count.value}',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.pure),
              ),
            ],
          ),
        ));
  }
}
