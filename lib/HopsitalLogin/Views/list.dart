import 'package:opd_app/RolewiseLogin/DataEntry/views/patients/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/color.dart';
import '../../RolewiseLogin/Doctor/controllers/DoctorPatientController.dart';

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
          title: Text(
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
                  icon: Icon(Icons.filter_list, color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Appcolor.Primary.withOpacity(0.8),
                Appcolor.Secondary.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FutureBuilder<void>(
            future: patientController
                .fetchPatients(), // Fetch patients when the widget loads
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                // Check if hospitalId and hospitalName are valid
                final prefs = SharedPreferences.getInstance();
                return FutureBuilder<SharedPreferences>(
                  future: prefs,
                  builder: (context, prefSnapshot) {
                    if (prefSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (prefSnapshot.hasData) {
                      String? hospitalId =
                          prefSnapshot.data?.getString('HospitalId');
                      String? hospitalName =
                          prefSnapshot.data?.getString('UserName');

                      // Check if both hospitalId and hospitalName are valid
                      if (hospitalId != null &&
                          hospitalId.isNotEmpty &&
                          hospitalName != null &&
                          hospitalName.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await patientController.fetchPatients();
                          },
                          child: Obx(() {
                            var filteredPatientsList =
                                patientController.filteredPatientsList;

                            return ListView.builder(
                              itemCount: filteredPatientsList.length,
                              itemBuilder: (context, index) {
                                var patient = filteredPatientsList[index];
                                return Card(
                                  color: Color.fromARGB(255, 5, 79, 71)
                                      .withOpacity(0.5),
                                  shadowColor:
                                      Color.fromARGB(255, 101, 196, 104)
                                          .withOpacity(0.4),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    title: Text(
                                      patient.patientName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolor.pure,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Age: ${patient.age},\nVisited on: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(patient.createdAt))}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Appcolor.pure,
                                      ),
                                    ),
                                    trailing: Icon(
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
                        return Center(
                            child: Text(
                                "Hospital ID or Hospital Name is missing"));
                      }
                    } else {
                      return Center(child: Text("Error fetching preferences"));
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
