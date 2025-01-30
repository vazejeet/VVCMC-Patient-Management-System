import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Patient {
  final String id;
  final String patientName;
  final int mobileNo;
  final String emailId;
  final String age;
  final String gender;
  final String weight;
  final String caste;
  final String ApplicationID;
  final String idCard;
  final String residence;
  final String createdBy;
  final String createdAt;
  final List<Symptom> symptoms;
  final String hospitalName; 
  final String doctorName;
  final String dataentryName;
  

  Patient({
    required this.id,
   
    required this.patientName,
    required this.mobileNo,
    required this.emailId,
    required this.age,
    required this.gender,
    required this.weight,
    required this.caste,
    required this.ApplicationID,
    required this.idCard,
    required this.residence,
    required this.symptoms,
    required this.createdBy,
    required this.createdAt,
    required this.dataentryName,
    required this.hospitalName, // Added hospital name to constructor
    required this.doctorName,
   
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    var symptomsList = json['Symptoms'] as List;
    List<Symptom> symptoms =
        symptomsList.map((i) => Symptom.fromJson(i)).toList();

    // Ensure HospitalName is not null; if missing, assign 'Unknown Hospital'
    String hospitalName = json['HospitalName'] ?? 'Unknown Hospital';
    String doctorName = json['DoctorName'] ?? 'Unknown Hospital';

    return Patient(
      id: json['_id'],
      patientName: json['PatientName'],
      mobileNo: json['MobileNo'],
      emailId: json['Emailid'] ?? '', // Handle null email
      age: json['AGE'] ?? '', // Handle null age
      gender: json['Gender'] ?? '', // Handle null gender
      weight: json['Weight'] ?? '', // Handle null weight
      caste: json['Caste'] ?? '', // Handle null caste
      idCard: json['Idcard'] ?? '', 
      residence: json['Residence'] ?? '', 
      symptoms: symptoms,
      createdBy: json['CreatedBy'] ?? '', 
      createdAt: json['CreatedAt'] ?? '', 
      dataentryName: json['DataEntryName'] ?? '', 
      hospitalName: hospitalName,
      doctorName: doctorName, 
      ApplicationID: json['ApplicationID'],
    );
  }
}


class Symptom {
  final String title;
  final String dateTime;
  final DiagnosisData? diagnosisData;
  final String? image; // Nullable image

  Symptom({
    required this.title,
    required this.dateTime,
    this.diagnosisData,
    this.image, // Nullable image
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      title: json['Title'],
      dateTime: json['DateTime'] ?? '', // Default to empty string if null
      diagnosisData: json['DiagnosisData'] != null
          ? DiagnosisData.fromJson(json['DiagnosisData'])
          : null,
      image: json['image'], // Nullable image field (can be null)
    );
  }
}

class DiagnosisData {
  final String? test;
  final String? doctorName;
  final String? diagnosis;
  final List<String>? medicine;
  final String? dateTime;
  final String? image; 

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
  var patientsList = <Patient>[].obs;
  var filteredPatientsList = <Patient>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String? hospitalId = prefs.getString('HospitalId');
      String? hospitalName = prefs.getString('Hospital');
      String? dataentryName = prefs.getString('UserName');

      if (hospitalName != null && dataentryName != null) {
        var url = Uri.parse("https://vvcmhospitals.codifyinstitute.org/api/patients/");
        var response = await http.get(url);

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          List<dynamic> patientsData = jsonData['patients'];

          // Filter patients based on hospitalId and dataentryName
          patientsList.value = patientsData
              .map((patient) => Patient.fromJson(patient))
              .where((patient) =>
                  // patient.createdBy == hospitalId &&
                  patient.dataentryName == dataentryName)
              .toList();

          // Sort and set filtered list
          _sortPatientsByLatest();
          filteredPatientsList.value = List.from(patientsList);

          print("Patients for hospital: $hospitalName");
        } else {
          print("Failed to load patients");
        }
      } else {
        print("Hospital ID or Hospital Name is missing");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void _sortPatientsByLatest() {
    patientsList.sort((a, b) {
      DateTime? dateA = _getLatestDiagnosisDate(a);
      DateTime? dateB = _getLatestDiagnosisDate(b);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA); // Sort by latest date (descending)
    });
  }

  void filterPatientsByDate(String filter, [DateTimeRange? customRange]) {
    final DateTime now = DateTime.now();
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);
    final DateTime startOfYear = DateTime(now.year, 1, 1);

    filteredPatientsList.value = patientsList.where((patient) {
      DateTime? latestDiagnosisDate = _getLatestDiagnosisDate(patient);

      if (latestDiagnosisDate == null) return false;

      switch (filter) {
        case 'Today':
          return isSameDay(latestDiagnosisDate, now);
        case 'Yesterday':
          return isSameDay(latestDiagnosisDate, now.subtract(Duration(days: 1)));
        case 'This Week':
          return latestDiagnosisDate.isAfter(startOfWeek);
        case 'This Month':
          return latestDiagnosisDate.isAfter(startOfMonth);
        case 'This Year':
          return latestDiagnosisDate.isAfter(startOfYear);
        case 'Custom':
          if (customRange != null) {
            return latestDiagnosisDate.isAfter(customRange.start) &&
                latestDiagnosisDate.isBefore(customRange.end);
          }
          return false;
        default:
          return false;
      }
    }).toList();

    // Sort filtered patients by latest date
    filteredPatientsList.sort((a, b) {
      DateTime? dateA = _getLatestDiagnosisDate(a);
      DateTime? dateB = _getLatestDiagnosisDate(b);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA);
    });
  }

  DateTime? _getLatestDiagnosisDate(Patient patient) {
    if (patient.symptoms.isEmpty) return null;

    List<DateTime> diagnosisDates = patient.symptoms
        .where((symptom) => symptom.diagnosisData?.dateTime != null)
        .map((symptom) => DateTime.parse(symptom.diagnosisData!.dateTime!))
        .toList();

    if (diagnosisDates.isEmpty) return null;

    return diagnosisDates.reduce((a, b) => a.isAfter(b) ? a : b);
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

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Future<void> refreshPatients() async {
    await fetchPatients();
  }
}
