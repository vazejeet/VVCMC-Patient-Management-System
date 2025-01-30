

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/doctorbottombar.dart';

class DiagnosisController extends GetxController {
  var symptoms = <String>[].obs;
  var tests = <String>[].obs;
  var diagnosis = <String>[].obs;
  var medicine = <String>[].obs;
  var datetime = <String>[].obs;

  var selectedSymptoms = <String>[].obs;
  var selectedTests = <String>[].obs;
  var selectedDiagnosis = <String>[].obs;
  var selectedMedicine = <String>[].obs;

  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final doctorNameController = TextEditingController();
  final hospitalNameController = TextEditingController();
  final hospitalIdController = TextEditingController();

  final refController = TextEditingController();
  final followUpController = TextEditingController();

  RxList<TextEditingController> symptomsAdditionalFields = <TextEditingController>[].obs;
  RxList<TextEditingController> testsAdditionalFields = <TextEditingController>[].obs;
  RxList<TextEditingController> diagnosisAdditionalFields = <TextEditingController>[].obs;
  RxList<TextEditingController> medicineAdditionalFields = <TextEditingController>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctorName();
    fetchDropdownData();
    fetchHospitalDetails();
  }

  void fetchDoctorName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String doctorName = prefs.getString('UserName') ?? 'Unknown Doctor';
    doctorNameController.text = doctorName;
    doctorNameController.selection = TextSelection.collapsed(offset: doctorNameController.text.length);
  }

  void fetchHospitalDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hospitalName = prefs.getString('Hospital') ?? 'Unknown Hospital';
    hospitalNameController.text = hospitalName;
    String hospitalId = prefs.getString('HospitalId') ?? 'Unknown ID';
    hospitalIdController.text = hospitalId;
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

  Future<void> diagnosePatient(String ApplicationID, Map<String, dynamic> diagnosisData) async {
    final url = Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/patients/$ApplicationID/diagnosis');
    isLoading(true);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(diagnosisData),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Diagnosis successful: ${json.encode(responseBody)}');
        errorMessage.value = '';
        Get.snackbar("Success", "Diagnosis added successfully!", snackPosition: SnackPosition.TOP,);
        
        Get.off(() => RoleBottomPage());
      } else {
        errorMessage.value = 'Error: ${response.statusCode}, ${response.body}';
        print('Error: ${response.statusCode}, ${response.body}');
        Get.snackbar("Error", errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Exception occurred: $e';
      print('Exception occurred: $e');
      Get.snackbar("Exception", errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveHospitalDetails(String hospitalName, String hospitalId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Hospital', hospitalName);
    await prefs.setString('HospitalId', hospitalId);
  }
}



