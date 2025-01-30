import 'dart:async';

import 'package:opd_app/RolewiseLogin/DataEntry/controllers/patients/patientscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosisData {
  final String? test;
  final String? doctorName;
  final String? diagnosis;
  final List<String>? medicine;
  final String? dateTime;
  final String? image; // Nullable image for diagnosis

  DiagnosisData({
    this.test,
    this.doctorName,
    this.diagnosis,
    this.medicine,
    this.dateTime,
    this.image, // Nullable image
  });

  factory DiagnosisData.fromJson(Map<String, dynamic> json) {
    return DiagnosisData(
      test: json['Test'],
      doctorName: json['DoctorName'],
      diagnosis: json['Diagnosis'],
      medicine:
          json['Medicine'] != null ? List<String>.from(json['Medicine']) : [],
      dateTime: json['DateTime'],
      image: json['image'], // Nullable image field for diagnosis
    );
  }
}

class PatientController extends GetxController {
  var isLoading = true.obs;
  var patientsList = <Patient>[].obs; // All patients fetched
  var filteredPatientsList = <Patient>[].obs; // Patients filtered by criteria

  @override
  void onInit() {
    fetchPatients();
    super.onInit();
  }

  Future<void> fetchPatients() async {
    final prefs = await SharedPreferences.getInstance();
    String? hospitalId = prefs.getString('HospitalId'); // Target hospitalId
    String? loggedInDoctorName =
        prefs.getString('UserName'); // Target DoctorName

    try {
      var url = Uri.parse(
          "https://vvcmhospitals.codifyinstitute.org/api/patients/newget");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> patientsData = jsonData['patients'];

        // Filter patients by both hospitalId and DoctorName
        patientsList.value = patientsData
            .map((patient) => Patient.fromJson(patient))
            .where((patient) =>
                patient.createdBy == hospitalId &&
                patient.doctorName == loggedInDoctorName)
            .toList();

        // Initially set the filtered list to all patients that meet the criteria
        filteredPatientsList.value = patientsList;

        print(
            "Patients for hospital: $hospitalId and doctor: $loggedInDoctorName");
      } else {
        print("Failed to load patients");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterPatientsByDate(String filter, [DateTimeRange? customRange]) {
    final DateTime now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);
    final DateTime startOfYear = DateTime(now.year, 1, 1);

    // Filter logic
    filteredPatientsList.value = patientsList.where((patient) {
      DateTime? diagnosisDate = patient.symptoms.isNotEmpty &&
              patient.symptoms.first.diagnosisData?.dateTime != null
          ? DateTime.parse(patient.symptoms.first.diagnosisData!.dateTime!)
          : null;

      if (diagnosisDate == null) return false;

      switch (filter) {
        case 'Today':
          return isSameDay(diagnosisDate, now);
        case 'Yesterday':
          return isSameDay(diagnosisDate, now.subtract(Duration(days: 1)));
        case 'This Week':
          return diagnosisDate.isAfter(startOfWeek);
        case 'This Month':
          return diagnosisDate.isAfter(startOfMonth);
        case 'This Year':
          return diagnosisDate.isAfter(startOfYear);
        case 'Custom':
          if (customRange != null) {
            return diagnosisDate.isAfter(customRange.start) &&
                diagnosisDate.isBefore(customRange.end);
          }
          return false;
        default:
          return false;
      }
    }).toList();
  }

  // void filterPatientsByDate(String filterOption, [DateTimeRange? customRange]) {
  //   DateTime now = DateTime.now();
  //   DateTime startDate;
  //   DateTime endDate = now;

  //   switch (filterOption) {
  //     case 'Today':
  //       startDate = DateTime(now.year, now.month, now.day);
  //       break;
  //     case 'Yesterday':
  //       startDate = DateTime(now.year, now.month, now.day - 1);
  //       endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
  //       break;
  //     case 'This Week':
  //       startDate = now.subtract(Duration(days: now.weekday - 1));
  //       break;
  //     case 'This Month':
  //       startDate = DateTime(now.year, now.month, 1);
  //       break;
  //     case 'This Year':
  //       startDate = DateTime(now.year, 1, 1);
  //       break;
  //     case 'Custom':
  //       if (customRange != null) {
  //         startDate = customRange.start;
  //         endDate = customRange.end;
  //       } else {
  //         return; // No custom date range selected
  //       }
  //       break;
  //     default:
  //       startDate = DateTime(now.year, now.month, now.day);
  //   }

  //   // Apply the date filter to the patients list
  //   filteredPatientsList.value = patientsList.where((patient) {
  //     DateTime createdAt = DateTime.parse(patient.createdAt);
  //     return createdAt.isAfter(startDate) &&
  //         createdAt.isBefore(endDate.add(Duration(days: 1)));
  //   }).toList();
  // }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }

  String formatDate(String dateTimeString) {
    try {
      DateTime dateTime =
          DateTime.parse(dateTimeString); // Parse the date string
      return DateFormat('yyyy-MM-dd').format(dateTime); // Format the DateTime
    } catch (e) {
      print(
          "Error parsing date: $e"); // Log any errors that might occur during parsing
      return 'Invalid date'; // Return a fallback value in case of errors
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
