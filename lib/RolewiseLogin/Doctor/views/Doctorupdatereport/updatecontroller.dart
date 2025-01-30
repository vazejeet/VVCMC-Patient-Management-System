

import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateListController extends GetxController {
  var symptoms = <String>[].obs;
  var tests = <String>[].obs;
  var diagnosis = <String>[].obs;
  var medicine = <String>[].obs;

  var selectedSymptoms = <String>[].obs;
  var selectedTests = <String>[].obs;
  var selectedDiagnosis = <String>[].obs;
  var selectedMedicine = <String>[].obs;

  var patients = <dynamic>[].obs;
  var filteredPatients = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var selectedFilter = ''.obs;
  DateTime? customStartDate;
  DateTime? customEndDate;

  @override
  void onInit() {
    fetchPatients();
    fetchDropdownData();
    super.onInit();
  }

  void fetchDropdownData() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/dropdowns'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'][0];

        symptoms.value = _parseDropdown(data['symptoms']);
        tests.value = _parseDropdown(data['test']);
        diagnosis.value = _parseDropdown(data['diagnosis']);
        medicine.value = _parseDropdown(data['medicine']);
      } else {
        errorMessage.value = "Failed to fetch dropdown data.";
      }
    } catch (e) {
      errorMessage.value = "Error occurred: $e";
    } finally {
      isLoading(false);
    }
  }

  List<String> _parseDropdown(dynamic data) {
    return data != null ? List<String>.from(data.where((e) => e != null)) : [];
  }

  Future<void> fetchPatients() async {
    final prefs = await SharedPreferences.getInstance();
    String? hospitalId = prefs.getString('HospitalId');
    String? doctorName = prefs.getString('UserName'); // Retrieve DoctorName

    try {
      if (hospitalId == null || doctorName == null || doctorName.toLowerCase() == 'unknown') {
        errorMessage.value = 'Invalid Hospital ID or Doctor Name. Please log in again.';
        patients.clear();
        return;
      }

      final response = await http.get(
        Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/patients/diagnoses'),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body)['patients'];

        // Filter patients based on HospitalId
        var filteredData = jsonData.where((patient) {
          return patient['CreatedBy'] == hospitalId;
        }).toList();

        // Further filter patients based on DoctorName
        filteredData = filteredData.where((patient) {
          return patient['Symptoms'] != null &&
              patient['Symptoms'].any((symptom) {
                final docName = symptom['DoctorName']?.toLowerCase();
                return docName == doctorName.toLowerCase() && docName != 'unknown';
              });
        }).toList();

        patients.value = filteredData;
        applyFilter(selectedFilter.value);
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

  void applyFilter(String filter) {
    final now = DateTime.now();
    List<dynamic> filtered = [];

    switch (filter) {
      case 'Today':
        final today = DateTime(now.year, now.month, now.day);
        filtered = patients.where((patient) {
          final patientDate = DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(today) && patientDate.isBefore(today.add(Duration(days: 1)));
        }).toList();
        break;
      case 'Yesterday':
        final yesterday = DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
        final today = DateTime(now.year, now.month, now.day);
        filtered = patients.where((patient) {
          final patientDate = DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(yesterday) && patientDate.isBefore(today);
        }).toList();
        break;
      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        filtered = patients.where((patient) {
          final patientDate = DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(startOfWeek) && patientDate.isBefore(now);
        }).toList();
        break;
      case 'This Month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        filtered = patients.where((patient) {
          final patientDate = DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(startOfMonth) && patientDate.isBefore(now);
        }).toList();
        break;
      case 'This Year':
        final startOfYear = DateTime(now.year, 1, 1);
        filtered = patients.where((patient) {
          final patientDate = DateTime.parse(patient['Symptoms'][0]['DateTime']);
          return patientDate.isAfter(startOfYear) && patientDate.isBefore(now);
        }).toList();
        break;
      case 'Custom':
        if (customStartDate != null && customEndDate != null) {
          filtered = patients.where((patient) {
            final patientDate = DateTime.parse(patient['Symptoms'][0]['DateTime']);
            return patientDate.isAfter(customStartDate!) && patientDate.isBefore(customEndDate!);
          }).toList();
        }
        break;
      default:
        filtered = patients; // Show all patients if no filter is applied
    }

    filteredPatients.value = filtered;
    selectedFilter.value = filter;
  }

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

  
  Future<bool> updatePatientDetails(String aadhaar, Map<String, dynamic> updatedData) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? hospitalId = prefs.getString('HospitalId');

    if (hospitalId == null) {
      errorMessage.value = 'Hospital ID not found. Please log in again.';
      return false; // Returning false on failure
    }

    // Print the data you're sending to verify it
    print("Sending updated data: $updatedData");

    final response = await http.put(
      Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/patients/$aadhaar/diagnosis'),
      headers: {
        'Content-Type': 'application/json',
    
      },
      body: json.encode(updatedData),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Successfully updated, print the updated data
      print('Updated Data:');
      print(updatedData);

      // Parse the response to check the update result (optional)
      var responseData = json.decode(response.body);
      print('Response Data: $responseData');

      return true; // Returning true if update is successful
    } else {
      errorMessage.value = 'Failed to update patient details';
      print('Failed to update. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      return false; // Returning false if the update failed
    }
  } catch (e) {
    errorMessage.value = 'Failed to update patient details. Please try again.';
    print(e);
    return false; // Returning false if an exception occurs
  }
}


  Future<void> refreshPatients() async {
    await fetchPatients();
  }
}
