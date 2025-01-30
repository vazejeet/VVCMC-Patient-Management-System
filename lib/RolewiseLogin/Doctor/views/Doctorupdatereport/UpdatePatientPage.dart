// new code

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import 'updatecontroller.dart';

class UpdatePatientPage extends StatelessWidget {
  final Map<String, dynamic> patient;
  final UpdateListController controller = Get.put(UpdateListController());
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();

  UpdatePatientPage({Key? key, required this.patient}) : super(key: key) {
    // Initialize title with the current value from the patient data
    titleController.text = patient['Title'] ?? '';
    fetchDoctorName();
  }

  void fetchDoctorName() {
    var symptomsList = patient['Symptoms'] ?? [];
    var lastSymptom = symptomsList.isNotEmpty ? symptomsList.first : {};
    String doctorName = lastSymptom['DoctorName'] ?? 'Unknown Doctor';
    doctorNameController.text = doctorName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/logo.png"),
          ),
          title: const Text(
            'Update Diagnosis',
            style: TextStyle(color: Appcolor.pure),
          ),
          backgroundColor: Appcolor.Primary,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.Primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildDetailRow(
                            'Patient ID', patient['ApplicationID']),
                        _buildDetailRow('Patient Name', patient['PatientName']),
                        if(patient['Idcard']?.isNotEmpty ?? false)
                        _buildDetailRow('ID Card No', patient['Idcard']),
                        
                        _buildDetailRow(
                            'Mobile No', patient['MobileNo'].toString()),
                            if(patient['Emailid']?.isNotEmpty ?? false)
                            _buildDetailRow(
                            'Email ID', patient['Emailid'].toString()),
                        _buildDetailRow('Created By', patient['CreatedBy']),
                        _buildDetailRow(
                            'Doctor Name', doctorNameController.text),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _showUpdateDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.Primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Update Diagnosis',
                        style: TextStyle(fontSize: 16, color: Appcolor.pure),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    var symptomsList = patient['Symptoms'] ?? [];
    var lastSymptom = symptomsList.isNotEmpty ? symptomsList.first : {};

    // Controllers for `ref` and `followup` fields
    TextEditingController refController =
        TextEditingController(text: lastSymptom['ref'] ?? '');
    TextEditingController followupController =
        TextEditingController(text: lastSymptom['followup'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Update Patient Diagnosis',
            style: TextStyle(color: Appcolor.Primary),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDropdownField(
                    label: lastSymptom['Title'],
                    items: controller.symptoms,
                    selectedValues: controller.selectedSymptoms,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    label: lastSymptom['Test'],
                    items: controller.tests,
                    selectedValues: controller.selectedTests,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    label: lastSymptom['Diagnosis'],
                    items: controller.diagnosis,
                    selectedValues: controller.selectedDiagnosis,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(
                    label: lastSymptom['Medicine']?.join(", "),
                    items: controller.medicine,
                    selectedValues: controller.selectedMedicine,
                  ),
                  const SizedBox(height: 10),
                  // Editable fields for `ref` and `followup`
                  _buildFormField('Ref', refController),
                  const SizedBox(height: 10),
                  _buildFormField('Follow-up', followupController),
                  const SizedBox(height: 10),
                  // _buildFormField('Doctor Name', doctorNameController),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Appcolor.Primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolor.Primary,
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Ensure each field is processed correctly as a list or string
                  var symptomsTitle = (controller.selectedSymptoms.isNotEmpty
                          ? controller.selectedSymptoms
                          : (lastSymptom['Title'] is List
                              ? lastSymptom['Title']
                              : (lastSymptom['Title'] ?? '').split(', ')))
                      .toSet()
                      .toList()
                      .join(', ');

                  var tests = (controller.selectedTests.isNotEmpty
                          ? controller.selectedTests
                          : (lastSymptom['Test'] is List
                              ? lastSymptom['Test']
                              : (lastSymptom['Test'] ?? '').split(', ')))
                      .toSet()
                      .toList()
                      .join(', ');

                  var diagnosis = (controller.selectedDiagnosis.isNotEmpty
                          ? controller.selectedDiagnosis
                          : (lastSymptom['Diagnosis'] is List
                              ? lastSymptom['Diagnosis']
                              : (lastSymptom['Diagnosis'] ?? '').split(', ')))
                      .toSet()
                      .toList()
                      .join(', ');

                  var medicine = (controller.selectedMedicine.isNotEmpty
                          ? controller.selectedMedicine
                          : (lastSymptom['Medicine'] is List
                              ? lastSymptom['Medicine']
                              : (lastSymptom['Medicine'] ?? '').split(', ')))
                      .toSet()
                      .toList()
                      .join(', ');

                  // Handle `ref` and `followup`
                  String updatedRef = refController.text.trim();
                  String updatedFollowup = followupController.text.trim();

                  Map<String, dynamic> updatedData = {
                    'Title': symptomsTitle,
                    'DoctorName': doctorNameController.text,
                    'Test': tests,
                    'Diagnosis': diagnosis,
                    'Medicine': medicine,
                    'ref': updatedRef,
                    'followup': updatedFollowup,
                    'CreatedBy': patient['CreatedBy'],
                    'HospitalName':
                        patient['HospitalName'] ?? 'Unknown Hospital',
                  };

                  controller
                      .updatePatientDetails(patient['ApplicationID'], updatedData)
                      .then((success) {
                    if (success) {
                      Get.snackbar(
                        'Success',
                        'Diagnosis updated successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Failed to update diagnosis',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  });
                  Get.back();
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Appcolor.pure),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required RxList<String>
        selectedValues, // Use RxList to hold multiple selections
  }) {
    
  

    void _showDropdown(BuildContext context) {
      final TextEditingController _searchController = TextEditingController();
      final TextEditingController _othersController = TextEditingController();
      var filteredItems = items.obs;
      bool showOthersField =
          false; // Toggle for showing the "Others" text field

      // Add "None" as the top option and include it in the filtered items
      if (!items.contains("None")) {
        items.insert(0, "None");
      }

      void _arrangeItems() {
        List<String> nonSelectedItems =
            items.where((item) => !selectedValues.contains(item)).toList();

        List<String> arrangedSelectedItems = List<String>.from(selectedValues);

        filteredItems.value = arrangedSelectedItems + nonSelectedItems;
      }

      _arrangeItems();

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!showOthersField) ...[
                        // Search bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Search',
                            labelStyle: const TextStyle(color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _arrangeItems();
                              });
                            } else {
                              setState(() {
                                filteredItems.value = filteredItems.value
                                    .where((item) => item
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                      // List of items
                      Expanded(
                        child: Obx(() {
                          return ListView.builder(
                            itemCount:
                                filteredItems.length + 1, // Include "None"
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // "None" field
                                return ListTile(
                                  title: const Text("None"),
                                  trailing: selectedValues.contains("None")
                                      ? const Icon(Icons.check_box,
                                          color: Colors.blue)
                                      : const Icon(
                                          Icons.check_box_outline_blank),
                                  onTap: () {
                                    setState(() {
                                      if (selectedValues.contains("None")) {
                                        selectedValues.remove("None");
                                      } else {
                                        selectedValues
                                            .clear(); // Clear all other selections
                                        selectedValues.add(
                                            "None"); // Add "None" selection
                                      }
                                      _arrangeItems(); // Reorganize items
                                    });
                                  },
                                );
                              } else if (index == 1 && !showOthersField) {
                                // "Others" field
                                return ListTile(
                                  title: const Text("Others"),
                                  trailing: const Icon(Icons.edit,
                                      color: Colors.grey),
                                  onTap: () {
                                    setState(() {
                                      showOthersField =
                                          true; // Show custom input field for "Others"
                                    });
                                  },
                                );
                              } else if (index == 1 && showOthersField) {
                                // Custom "Others" input field
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextField(
                                    controller: _othersController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: 'Enter custom value',
                                      labelStyle:
                                          const TextStyle(color: Colors.blue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.blue),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                    ),
                                  ),
                                );
                              }

                              // Adjust index for "None" and optional "Others"
                              final item = filteredItems[
                                  index - (showOthersField ? 2 : 1)];
                              final isSelected = selectedValues.contains(item);
                              return ListTile(
                                title: Text(item),
                                trailing: isSelected
                                    ? const Icon(Icons.check_box,
                                        color: Colors.blue)
                                    : const Icon(Icons.check_box_outline_blank),
                                onTap: () {
                                  if (selectedValues.contains("None")) {
                                    selectedValues.remove(
                                        "None"); // Deselect "None" if another item is selected
                                  }
                                  if (isSelected) {
                                    selectedValues.remove(item);
                                  } else {
                                    selectedValues.add(item);
                                  }
                                  _arrangeItems();
                                  setState(() {});
                                },
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // Clear button
                  TextButton(
                    onPressed: () {
                      selectedValues.clear();
                      _arrangeItems();
                      setState(() {});
                    },
                    child: const Text('Clear',
                        style: TextStyle(color: Colors.orange)),
                  ),
                  // Done button
                  TextButton(
                    onPressed: () {
                      if (showOthersField &&
                          _othersController.text.isNotEmpty) {
                        selectedValues
                            .add(_othersController.text); // Add custom value
                      }
                      print("Selected Values: ${selectedValues.join(', ')}");
                      Get.back();
                    },
                    child: const Text('Done',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Obx(() {
      return GestureDetector(
        onTap: () =>
            _showDropdown(Get.context!), // Open the dropdown when tapped
        child: Container(
          width: double.infinity, // Ensures it takes the full available width
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display selected values or the label if none selected
              Flexible(
                child: Text(
                  selectedValues.isNotEmpty
                      ? selectedValues
                          .join(', ') // Show comma-separated selected values
                      : label,
                  style: TextStyle(
                    color:
                        selectedValues.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Adds ellipsis for long text
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.blue),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      //   validator: (value) =>
      //       value?.isEmpty ?? true ? 'Please enter $label' : null,
       ),
    );
  }

  Widget _buildEditableOrDisabledField(String label, dynamic value) {
    bool isEditable = value != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        initialValue: value != null ? value.toString() : '',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        enabled: isEditable,
      ),
    );
  }
}
