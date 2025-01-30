import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorDiagnosis extends GetxController {
  var patients = <dynamic>[].obs;
  var filteredPatients = <dynamic>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;
  var selectedFilter = ''.obs;
  DateTime? customStartDate;
  DateTime? customEndDate;
  

  @override
  void onInit() {
    fetchPatients();
    super.onInit();
  
  }
  
  Future<void> fetchPatients() async {
      final prefs = await SharedPreferences.getInstance();
    String? hospitalId = prefs.getString('HospitalId');
    String? doctorName = prefs.getString('UserName'); // Retrieve doctor name

  // isLoading.value = true;
  errorMessage.value = '';
  try {
  
    if (hospitalId == null || doctorName == null) {
      errorMessage.value = 'Hospital ID or Doctor Name not found. Please log in again.';
      return;
    }

    final response = await http.get(Uri.parse(
        'https://vvcmhospitals.codifyinstitute.org/api/patients/patients/diagnoses'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['patients'];

      // Filter patients based on hospitalId and doctorName
      var filteredData = jsonData.where((patient) {
        return 
         patient['CreatedBy'] == hospitalId &&
            patient['Symptoms'] != null &&
            patient['Symptoms'].length > 0 &&
            patient['Symptoms'].any((symptom) {
              return symptom['DoctorName']?.toLowerCase() == doctorName.toLowerCase();
            });
      }).toList();
      

      patients.value = filteredData;
      filteredPatients.value = filteredData; // Set initially filtered data
    } else {
      errorMessage.value = 'Failed to load patients';
    }
  } catch (e) {
    errorMessage.value = 'Failed to load patients. Please try again.';
    print(e);
  } finally {
    isLoading.value = false;
  }
}

  // Apply filter based on the selected filter type
  void applyFilter(String filter) {
    final now = DateTime.now();
    List<dynamic> filtered = [];

    switch (filter) {
      case 'Today':
        final today = DateTime(now.year, now.month, now.day);
        filtered = patients.where((patient) {
          final patientDate =
              DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(today) &&
              patientDate.isBefore(today.add(Duration(days: 1)));
        }).toList();
        break;

      case 'Yesterday':
        final yesterday =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
        final today = DateTime(now.year, now.month, now.day);
        filtered = patients.where((patient) {
          final patientDate =
              DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(yesterday) && patientDate.isBefore(today);
        }).toList();
        break;

      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        filtered = patients.where((patient) {
          final patientDate =
              DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(startOfWeek) && patientDate.isBefore(now);
        }).toList();
        break;

      case 'This Month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        filtered = patients.where((patient) {
          final patientDate =
              DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(startOfMonth) && patientDate.isBefore(now);
        }).toList();
        break;

      case 'This Year':
        final startOfYear = DateTime(now.year, 1, 1);
        filtered = patients.where((patient) {
          final patientDate =
              DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(startOfYear) && patientDate.isBefore(now);
        }).toList();
        break;

      case 'Custom':
        if (customStartDate != null && customEndDate != null) {
          filtered = patients.where((patient) {
            final patientDate =
                DateTime.parse(patient['Symptoms'][0]['DateTime']);
            return patientDate.isAfter(customStartDate!) &&
                patientDate.isBefore(customEndDate!);
          }).toList();
        }
        break;

      default:
        filtered = patients; // Show all patients if no filter is applied
    }

    filteredPatients.value = filtered;
    selectedFilter.value = filter;
  }

  // Helper function to get the latest symptom from the patient's symptoms list
  dynamic _getLatestSymptom(Map<String, dynamic> patient) {
    if (patient['Symptoms'] != null && patient['Symptoms'].isNotEmpty) {
      // Sort symptoms by date and return the latest one
      var sortedSymptoms = List.from(patient['Symptoms']);
      sortedSymptoms.sort((a, b) => DateTime.parse(b['DateTime'])
          .compareTo(DateTime.parse(a['DateTime'])));
      return sortedSymptoms.first;
    }
    return null;
  }

  // Function to select custom date range for filtering
  Future<void> selectCustomDateRange(BuildContext context) async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );

    if (pickedDateRange != null) {
      customStartDate = pickedDateRange.start;
      customEndDate = pickedDateRange.end;
      selectedFilter.value = 'Custom'; // Update the filter to custom
      applyFilter('Custom');
    }
  }

  // Refresh the patients list from the server
  Future<void> refreshPatients() async {
    await fetchPatients();
  }

  // Update search query and filter patients based on name
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPatients.value = patients;
    } else {
      filteredPatients.value = patients.where((patient) {
        return patient['PatientName']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
  }

  // Function to get the hospital name from a patient's data
  String getHospitalName(dynamic patient) {
    return patient['HospitalName'] ?? 'Unknown Hospital';
  }
}
