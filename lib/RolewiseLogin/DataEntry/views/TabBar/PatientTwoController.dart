import 'package:opd_app/RolewiseLogin/DataEntry/views/dataentrybottombar.dart';
import 'package:opd_app/utils/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/patients/patientAdd.dart';

class PatientTwoController extends GetxController {
  // Use unique GlobalKeys for each form
  final formKey1 = GlobalKey<FormState>(); // Key for the first form

  // Observables for form fields
  var patientName = ''.obs; // RxString for patientName
  var mobileNo = ''.obs; // RxString for mobileNo
  var emailId = ''.obs; // RxString for emailId
  var aadharCardNumber = ''.obs; // RxString for aadharCardNumber
  // var abhaNo = ''.obs;  // RxString for abhaNo
  var address = ''.obs; // RxString for address
  var title = ''.obs; // RxString for title
  var gender = ''.obs; // RxString for gender
  var caste = ''.obs; // RxString for caste
  var selectedDate = Rxn<DateTime>(); // Date of Birth (nullable DateTime)
  var age = ''.obs; // RxString for age
  var createdBy = ''.obs; // RxString for createdBy
  var patientFound = false.obs; // To check if patient is found
  var hospitalName = ''.obs; // Hospital name observable
  var dataEntryName = ''.obs; // Data Entry Name observable
  var isUserExisting =
      false.obs; // Track if the user is existing based on Aadhaar number
  var weight = ''.obs;

  var symptoms = <String>[].obs;
  var selectedSymptoms = <String>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var doctorName = ''.obs;
  RxList<String> doctorsList = <String>[].obs;

  RxString selectedDoctor = ''.obs;

  List<dynamic> patientList =
      []; // To store patient data fetched by mobile number

  @override
  void onInit() {
    super.onInit();
    // Fetch the createdBy value first
    _fetchCreatedBy().then((_) {
      // Once createdBy is fetched, fetch doctors
      if (createdBy.value.isNotEmpty) {
        fetchDoctors(createdBy.value);
      } else {
        Get.snackbar(
            'Error', 'Hospital ID not found. Unable to fetch doctors.');
      }
    });
    _fetchHospitalName();
    _fetchDataEntryName();
    fetchDropdownData();
  }

  // Fetch Hospital Name from shared preferences
  Future<void> _fetchHospitalName() async {
    final prefs = await SharedPreferences.getInstance();
    hospitalName.value = prefs.getString('Hospital') ?? '';
    if (hospitalName.value.isEmpty) {
      Get.snackbar('Error', 'Hospital name not found. Please log in again.');
    }
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

  // Fetch Data Entry Name
  Future<void> _fetchDataEntryName() async {
    final prefs = await SharedPreferences.getInstance();
    dataEntryName.value = prefs.getString('UserName') ?? '';
  }

  // Fetch Symtoms Dropdown data

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

// Fetch patients based on Mobile Number
  Future<void> fetchPatientsByMobile(String mobileNo) async {
    var url =
        'https://vvcmhospitals.codifyinstitute.org/api/patients/search?mobileNo=$mobileNo';
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['message'] == 'Patients found' &&
            data['patients'].isNotEmpty) {
          patientList = data['patients'];
          _showPatientNameSelectionDialog();
        } else {
          // Show error dialog if no patients are found
          _showNoPatientsFoundDialog();
        }
      } else {
        // Show error dialog for failed response
        _showNoPatientsFoundDialog();
      }
    } catch (e) {
      // Show error dialog for network failure
      Get.snackbar('Error', 'Failed to fetch patient data: $e',
          backgroundColor: Colors.redAccent);
    }
  }

// Show dialog when no patients are found
  // Show dialog when no patients are found
  void _showNoPatientsFoundDialog() {
    Get.defaultDialog(
      title: 'No patients found with this mobile number',
      middleText: 'add new patient',
      backgroundColor: Appcolor.pure,
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Appcolor.Primary,
      ),
      middleTextStyle: const TextStyle(
        color: Appcolor.Primary,
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
      actions: [
        // Cancel Button with GestureDetector
        GestureDetector(
          onTap: () {
            Get.back(); // Close the dialog
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Appcolor.Primary, // Background color for the button
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white, // White text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // Add space between buttons
        // Add New Patient Button with GestureDetector
        GestureDetector(
          onTap: () {
            Get.back(); // Close the dialog
            // Navigate to Add New Patient page (replace with your route)
            Get.to(() => PatientForm(),
                        arguments: {"mobile": mobileNo.value});
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Appcolor.Primary, // Background color for the button
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Add New Patient',
              style: TextStyle(
                color: Colors.white, // White text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPatientNameSelectionDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Patient'),
          content: Container(
            height: 300,
            width: 300,
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: 300,
                  child: ListView.builder(
                    itemCount: patientList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(patientList[index]['PatientName']),
                        onTap: () {
                          // Set the selected patient data using RxString
                          _fetchPatientData(patientList[index]);
                          Navigator.pop(context); // Close the dialog
                        },
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back(); // Close the dialog

                    Get.to(() => PatientForm(),
                        arguments: {"mobile": mobileNo.value});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color:
                          Appcolor.Primary, // Background color for the button
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Add New Patient',
                      style: TextStyle(
                        color: Colors.white, // White text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fetch and populate data for the selected patient
  void _fetchPatientData(dynamic patientData) {
    // Set the selected patient data using RxString's .value property
    patientName.value = patientData['PatientName'] ?? '';
    aadharCardNumber.value = patientData['Idcard'] ?? '';
    gender.value = patientData['Gender'] ?? '';
    weight.value = patientData['Weight'] ?? '';
    age.value = patientData['AGE'] ?? 'Not Available';
    selectedDate.value = patientData['DOB'] != null
        ? DateTime.tryParse(patientData['DOB']) ?? DateTime.now()
        : DateTime.now();
    mobileNo.value = (patientData['MobileNo']?.toString() ?? '');
    emailId.value = patientData['Emailid'] ?? '';
    // abhaNo.value = patientData['AbhaNo'] ?? '';
    address.value = patientData['Residence'] ?? '';
    caste.value = patientData['Caste'] ?? '';
    title.value = patientData['Title'] ?? '';

    patientFound.value = true;
    isUserExisting.value = true;

    Get.snackbar('Success', 'Patient data fetched successfully.');
  }

  // Refresh method in PatientTwoController
  void refreshPatientForm() {
    formKey1.currentState?.reset();
    patientName.value = '';
    mobileNo.value = '';
    emailId.value = '';
    aadharCardNumber.value = '';
    // abhaNo.value = '';
    address.value = '';
    title.value = '';
    gender.value = '';
    caste.value = '';
    selectedDate.value = null;
    age.value = '';
    patientFound.value = false;
    isUserExisting.value = false;
    Get.snackbar('Refreshed', 'Patient form cleared and ready for new entry.');
  }

  Future<void> submitForm() async {
    if (formKey1.currentState!.validate()) {
      formKey1.currentState!.save();

      // Convert the selected symptoms (List) to a string
      String symptomsString =
          selectedSymptoms.join(', '); // Join symptoms as a string

      var data = {
        "PatientName": patientName.value,
        "MobileNo": mobileNo.value,
        "AGE": age.value,
        "Gender": gender.value,
        // "Emailid": emailId.value,
        "Weight": weight.value,
        "Caste": caste.value,
        "Idcard": aadharCardNumber.value,
        "DoctorName": selectedDoctor.value,
        "Residence": address.value,
        "CreatedBy": createdBy.value,
        "Title": symptomsString,
        "HospitalName": hospitalName.value,
        "DataEntryName": dataEntryName.value
      };

      if (emailId.value.isNotEmpty) {
        data["Emailid"] = emailId.value;
      }

      var url = 'https://vvcmhospitals.codifyinstitute.org/api/patients/';
      isLoading.value = true; // Show the loader
      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
        print('Response body: ${response.body}');
        isLoading.value = false; // Hide the loader
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Successfully submitted data
          Get.defaultDialog(
            title: 'Submitted Successfully',
            titleStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            middleText: 'Patient information has been successfully submitted.',
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
            onConfirm: () {
              Get.offAll(() => Dataentrybottombar());
            },
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            buttonColor: Colors.green,
            radius: 15.0,
            barrierDismissible: false,
          );
        } else {
          Get.snackbar('Error',
              'Failed to submit patient information: ${response.statusCode}');
        }
      } catch (e) {
        isLoading.value = false; // Hide the loader on error
        Get.snackbar(
            'Error', 'An error occurred while submitting the information: $e');
      }
    } else {
      Get.snackbar('Error', 'Please fill all required fields.');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      final currentDate = DateTime.now();
      final calculatedAge = currentDate.year - pickedDate.year;
      age.value = (pickedDate.isAfter(
              DateTime(currentDate.year, pickedDate.month, pickedDate.day)))
          ? (calculatedAge - 1).toString()
          : calculatedAge.toString();
    }
  }

  void clearFetchedData() {
    patientName.value = '';
    mobileNo.value = '';
    emailId.value = '';
    // abhaNo.value = '';
    age.value = '';
    gender.value = '';
    weight.value = '';
    caste.value = '';
    address.value = '';
    title.value = '';
    createdBy.value = '';
    hospitalName.value = '';
    selectedDate.value = null;
    aadharCardNumber.value = '';
    patientFound.value = false;
  }
}