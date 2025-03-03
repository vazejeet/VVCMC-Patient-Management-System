

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/dataentrybottombar.dart';

class PatientAddFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

 var selectedDocument = ''.obs;

    // Observable for entered document number
  var documentNumber = ''.obs;

  // Observable for validation error message
  var validationError = ''.obs;

  // List of document types
  final List<String> documentTypes = ['Aadharcard', 'Pancard', 'VoterID', 'Abhacard'];


  var patientName = ''.obs;
  var mobileNumber = ''.obs;
  var emailId = ''.obs;
  var aadharCardNumber = ''.obs;
  var address = ''.obs;
  var title = ''.obs;
  var gender = ''.obs;
  var caste = ''.obs;
  var selectedDate = Rxn<DateTime>();
  var age = ''.obs;
  var createdBy = ''.obs;
  var hospitalName = ''.obs;
  var dataEntryName = ''.obs;
  var symptoms = <String>[].obs;
  var selectedSymptoms = <String>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var weight = ''.obs;
  var doctorName = ''.obs;
  RxList<String> doctorsList = <String>[].obs;

  RxString selectedDoctor = ''.obs;

  @override
  void onInit() {
    
    super.onInit();

    // Fetch the createdBy value first
    _fetchCreatedBy().then((_) {
      // Once createdBy is fetched, fetch doctors
      if (createdBy.value.isNotEmpty) {
        fetchDoctors(createdBy.value);
      } else {
        Get.snackbar('Error', 'Hospital ID not found. Unable to fetch doctors.');
      }
    });

    _fetchHospitalName(); // Fetch hospital name
    _fetchDataEntryName(); // Fetch data entry name
    fetchDropdownData(); // Fetch dropdown data (symptoms)
  }

  // Fetch Hospital ID (createdBy) from shared preferences
  Future<void> _fetchCreatedBy() async {
    final prefs = await SharedPreferences.getInstance();
    createdBy.value = prefs.getString('HospitalId') ?? '';
    if (createdBy.value.isEmpty) {
      Get.snackbar('Error', 'Hospital ID not found. Please log in again.');
    }
  }

  // Fetch doctors based on hospitalId
  Future<void> fetchDoctors(String hospitalId) async {
    final url =
        'https://vvcmhospitals.codifyinstitute.org/api/users/api/hospital/doctors?hospitalId=$hospitalId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure 'users' key exists and is a list
        if (data['users'] is List) {
          // Parse the list of doctors from the 'users' key
          doctorsList.value = List<String>.from(
              data['users'].map((user) => user['UserName'] as String));
          // Get.snackbar('Success', 'Doctors fetched successfully');
        } else {
          Get.snackbar('Error', 'No doctors data found.');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch doctors');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching doctors');
    }
  }

  // Fetch Hospital Name from shared preferences
  Future<void> _fetchHospitalName() async {
    final prefs = await SharedPreferences.getInstance();
    hospitalName.value =
        prefs.getString('Hospital') ?? ''; // Fetch hospital name
    if (hospitalName.value.isEmpty) {
      Get.snackbar('Error', 'Hospital name not found. Please log in again.');
    }
  }

  // Fetch Data Entry Name
  Future<void> _fetchDataEntryName() async {
    final prefs = await SharedPreferences.getInstance();
    dataEntryName.value = prefs.getString('UserName') ?? '';
    print("Fetched Data Entry Name: ${dataEntryName.value}"); // Debug
  }

  // Fetch Symptoms Dropdown data
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

 

void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Save form data

      // Show the loading indicator
      isLoading.value = true;

      // Your existing data preparation code
      String symptomsString = selectedSymptoms.join(', '); 
      var data = {
        "PatientName": patientName.value,
        "MobileNo": mobileNumber.value,
        "Emailid": emailId.value,
        "AGE": age.value,
        "Gender": gender.value,
        "Caste": caste.value,
        "Idcard": aadharCardNumber.value,
        "Weight": weight.value,
        "DoctorName": selectedDoctor.value,
        // "AbhaNo": abhaNo.value,
        "Residence": address.value,
        "CreatedBy": createdBy.value,
        "Title": symptomsString,
        "HospitalName": hospitalName.value,
        "DataEntryName": dataEntryName.value,
      };

      var url = 'https://vvcmhospitals.codifyinstitute.org/api/patients/';

      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
  print('Response body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Hide the loading indicator
          isLoading.value = false;

          await Get.defaultDialog(
            title: 'Submitted Successfully',
            titleStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            middleText:
                'Patient information has been successfully submitted.',
            middleTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            content: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Icon(
                Icons.check_circle_outline,
                size: 40,
                color: Colors.green,
              ),
            ),
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            backgroundColor: Colors.white,
            radius: 15.0,
            onConfirm: () {
              Get.offAll(() => Dataentrybottombar());
            },
          );
        } else {
          isLoading.value = false;
          print('Error status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
          Get.snackbar(
            'Error',
            'Failed to submit patient information. Status Code: ${response.statusCode}\nResponse: ${response.body}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'An error occurred while submitting the information: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }
}
