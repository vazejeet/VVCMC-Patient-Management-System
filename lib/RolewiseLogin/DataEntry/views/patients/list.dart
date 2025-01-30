import 'package:opd_app/RolewiseLogin/DataEntry/controllers/patients/patientscontroller.dart';
import 'package:opd_app/RolewiseLogin/DataEntry/views/patients/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/color.dart';

class PatientScreen extends StatelessWidget {
  final PatientController patientController = Get.put(PatientController());
  final TextEditingController searchController = TextEditingController();

  final RxString selectedFilter = 'Today'.obs; // Default filter
  final Rx<DateTimeRange?> customDateRange =
      Rx(null); // For custom date range selection

  void applyDateFilter(String filter) {
    switch (filter) {
      case 'Today':
        patientController.filterPatientsByDate('Today');
        break;
      case 'Yesterday':
        patientController.filterPatientsByDate('Yesterday');
        break;
      case 'This Week':
        patientController.filterPatientsByDate('This Week');
        break;
      case 'This Month':
        patientController.filterPatientsByDate('This Month');
        break;
      case 'This Year':
        patientController.filterPatientsByDate('This Year');
        break;
      case 'Custom':
        if (customDateRange.value != null) {
          patientController.filterPatientsByDate(
              'Custom', customDateRange.value);
        }
        break;
      default:
        patientController.filterPatientsByDate('Today');
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
          ],
          elevation: 2,
        ),
        body: Container(
          color: Appcolor.pure,
          child: FutureBuilder<void>(
            future: patientController.fetchPatients(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                final prefs = SharedPreferences.getInstance();
                return FutureBuilder<SharedPreferences>(
                  future: prefs,
                  builder: (context, prefSnapshot) {
                    if (prefSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (prefSnapshot.hasData) {
                      String? hospitalId =
                          prefSnapshot.data?.getString('HospitalId');
                      String? hospitalName =
                          prefSnapshot.data?.getString('UserName');

                      if (hospitalId != null &&
                          hospitalId.isNotEmpty &&
                          hospitalName != null &&
                          hospitalName.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await patientController.fetchPatients();
                          },
                          child: Obx(() {
                            var filteredPatientsList = patientController
                                .filteredPatientsList
                                .where((patient) {
                              // Exclude patients with null diagnosis date
                              return patient.symptoms.isNotEmpty &&
                                  patient.symptoms.first.diagnosisData
                                          ?.dateTime !=
                                      null;
                            }).toList();

                            if (filteredPatientsList.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No patients with valid diagnosis dates found.",
                                  style: TextStyle(
                                      fontSize: 18, color: Appcolor.Primary),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: filteredPatientsList.length,
                              itemBuilder: (context, index) {
                                var patient = filteredPatientsList[index];

                                String diagnosisDate = 'No Date Available';
                                if (patient.symptoms.isNotEmpty) {
                                  // Extract all valid dates and find the most recent one
                                  List<DateTime> diagnosisDates = patient
                                      .symptoms
                                      .where((symptom) =>
                                          symptom.diagnosisData?.dateTime !=
                                          null)
                                      .map((symptom) => DateTime.parse(
                                          symptom.diagnosisData!.dateTime!))
                                      .toList();

                                  if (diagnosisDates.isNotEmpty) {
                                    DateTime lastDate = diagnosisDates
                                        .reduce((a, b) => a.isAfter(b) ? a : b);
                                    diagnosisDate = DateFormat('yyyy-MM-dd')
                                        .format(lastDate);
                                  }
                                }

                                return Card(
                                  color: Appcolor.Primary,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                      Get.to(() => PatientDetailsScreen(
                                          patient: patient));
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        );
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
