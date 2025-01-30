import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../utils/color.dart';
import '../patientregistrationcontroller.dart';

class PatientForm extends StatelessWidget {
  final PatientAddFormController controller =
      Get.put(PatientAddFormController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'Patient Entry',
            style: TextStyle(
              color: Appcolor.pure,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Appcolor.Primary,
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Mobile Number
                    const Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onSaved: (value) =>
                          controller.mobileNumber.value = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Mobile Number' : null,
                    ),
                    const SizedBox(height: 10),

                    // Patient Name
                    const Text(
                      'Patient Name',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Patient Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onSaved: (value) => controller.patientName.value = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Patient Name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Email ID
                    const Text(
                      'Email ID',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Email ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onSaved: (value) => controller.emailId.value = value!,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      'Select ID Card Type',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedDocument.value.isEmpty
                            ? null
                            : controller.selectedDocument.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        hint: const Text(
                          'Select ID Card Type',
                        ),
                        items: controller.documentTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedDocument.value = value ?? '';
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

// TextFormField for entering document number
                    Obx(
                      () => controller.selectedDocument.value.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.selectedDocument.value} Number',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText:
                                        'Enter ${controller.selectedDocument.value} Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    errorText: controller.selectedDocument.value ==
                                                'Aadharcard' &&
                                            controller.aadharCardNumber.value
                                                .isNotEmpty &&
                                            controller.aadharCardNumber.value.length ==
                                                12 &&
                                            !isValidAadhaarV1(controller
                                                .aadharCardNumber.value)
                                        ? 'Invalid Aadhaar Number'
                                        : controller.selectedDocument.value == 'Pancard' &&
                                                controller.aadharCardNumber
                                                        .value.length ==
                                                    10 &&
                                                controller.aadharCardNumber
                                                    .value.isNotEmpty &&
                                                !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                                                    .hasMatch(controller
                                                        .aadharCardNumber.value)
                                            ? 'Invalid PAN Card Number'
                                            : controller.selectedDocument.value == 'VoterID' &&
                                                    controller.aadharCardNumber.value.length ==
                                                        10 &&
                                                    controller.aadharCardNumber
                                                        .value.isNotEmpty &&
                                                    !RegExp(r'^[A-Z]{3}[0-9]{7}')
                                                        .hasMatch(controller.aadharCardNumber.value)
                                                ? 'Invalid Voter Card Number'
                                                : null,
// Show error message if Aadhaar is invalid
                                  ),
                                  keyboardType: controller
                                                  .selectedDocument.value ==
                                              'Aadharcard' ||
                                          controller.aadharCardNumber.value ==
                                              'Abhacard'
                                      ? TextInputType.number
                                      : TextInputType.text,
                                  maxLength: controller
                                              .selectedDocument.value ==
                                          'Aadharcard'
                                      ? 12
                                      : controller.selectedDocument.value ==
                                                  'Pancard' ||
                                              controller
                                                      .selectedDocument.value ==
                                                  'VoterID'
                                          ? 10
                                          : controller.selectedDocument.value ==
                                                  'Abhacard'
                                              ? 14
                                              : 0, // Default value if no document is selected or matched

                                  onChanged: (value) {
                                    // Update the respective controller field
                                    if (controller.selectedDocument.value ==
                                        'Aadharcard') {
                                      controller.aadharCardNumber.value = value;
                                    } else if (controller
                                                .selectedDocument.value ==
                                            'Pancard' ||
                                        controller.selectedDocument.value ==
                                            'VoterID' ||
                                        controller.selectedDocument.value ==
                                            'Abhacard') {
                                      controller.aadharCardNumber.value = value;
                                    }
                                  },
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
//                     const SizedBox(height: 6),
//                     Obx(
//                       () => DropdownButtonFormField<String>(
//                         value: controller.selectedDocument.value.isEmpty
//                             ? null
//                             : controller.selectedDocument.value,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         hint: const Text('Select ID Card Type'),
//                         items: controller.documentTypes.map((String type) {
//                           return DropdownMenuItem<String>(
//                             value: type,
//                             child: Text(type),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           // Reset input and validation fields on card type change
//                           controller.selectedDocument.value = value ?? '';
//                           controller.documentNumber.value =
//                               ''; // Clear document number
//                           controller.validationError.value =
//                               ''; // Clear validation error
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),

// // TextFormField for entering document number
//                     Obx(
//                       () => controller.selectedDocument.value.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '${controller.selectedDocument.value} Number',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 TextFormField(
//                                   decoration: InputDecoration(
//                                     hintText:
//                                         'Enter ${controller.selectedDocument.value} Number',
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     errorText:
//                                         controller.selectedDocument.value ==
//                                                     'Aadharcard' &&
//                                                 controller.aadharCardNumber
//                                                     .value.isNotEmpty &&
//                                                 controller.aadharCardNumber
//                                                         .value.length ==
//                                                     12 &&
//                                                 !isValidAadhaarV1(controller
//                                                     .aadharCardNumber.value)
//                                             ? 'Invalid Aadhaar Number'
//                                             : null,
//                                   ),
//                                   keyboardType:
//                                       controller.selectedDocument.value ==
//                                               'Aadharcard'
//                                           ? TextInputType.number
//                                           : TextInputType.text,
//                                   maxLength: controller
//                                               .selectedDocument.value ==
//                                           'Aadharcard'
//                                       ? 12
//                                       : controller.selectedDocument.value ==
//                                                   'Pancard' ||
//                                               controller
//                                                       .selectedDocument.value ==
//                                                   'VoterID'
//                                           ? 10
//                                           : controller.selectedDocument.value ==
//                                                   'Abhacard'
//                                               ? 14
//                                               : 0,
//                                   onChanged: (value) {
//                                     controller.documentNumber.value = value;

//                                     // Validate the entered value
//                                     final requiredLength = controller
//                                                 .selectedDocument.value ==
//                                             'Aadharcard'
//                                         ? 12
//                                         : controller.selectedDocument.value ==
//                                                     'Pancard' ||
//                                                 controller.selectedDocument
//                                                         .value ==
//                                                     'VoterID'
//                                             ? 10
//                                             : controller.selectedDocument
//                                                         .value ==
//                                                     'Abhacard'
//                                                 ? 14
//                                                 : 0;

//                                     if (value.length != requiredLength) {
//                                       controller.validationError.value =
//                                           '${controller.selectedDocument.value} Number must be exactly $requiredLength characters.';
//                                     } else {
//                                       controller.validationError.value =
//                                           ''; // Clear error
//                                     }
//                                   },
//                                 ),
//                               ],
//                             )
//                           : const SizedBox.shrink(),
//                     ),

                    const SizedBox(height: 16),
                    // Date of Birth Picker Row
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Calendar Icon Button
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => controller.selectDate(context),
                        ),
                        const SizedBox(width: 5),

                        // Selected Date Display
                        Expanded(
                          child: Obx(() => Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    controller.selectedDate.value != null
                                        ? DateFormat('dd-MM-yyyy').format(
                                            controller.selectedDate.value!)
                                        : 'Select Date',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(width: 5),

                        // Age Display
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  controller.age.value.isNotEmpty
                                      ? 'Age: ${controller.age.value} years'
                                      : 'Age: --',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            )),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Gender Radio Buttons
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Obx(() => Radio<String>(
                              value: 'Male',
                              groupValue: controller.gender.value,
                              onChanged: (value) =>
                                  controller.gender.value = value!,
                            )),
                        const Text('Male'),
                        Obx(() => Radio<String>(
                              value: 'Female',
                              groupValue: controller.gender.value,
                              onChanged: (value) =>
                                  controller.gender.value = value!,
                            )),
                        const Text('Female'),
                        Obx(() => Radio<String>(
                              value: 'Other',
                              groupValue: controller.gender.value,
                              onChanged: (value) =>
                                  controller.gender.value = value!,
                            )),
                        const Text('Other'),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Weight...
                    const Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onSaved: (value) => controller.weight.value = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Weight' : null,
                    ),

                    const SizedBox(height: 10),

                    // Address
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onSaved: (value) => controller.address.value = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Address' : null,
                    ),
                    const SizedBox(height: 10),

                    // Caste Dropdown
                    const Text(
                      'Caste',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(() => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Select Caste',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          value: controller.caste.value.isEmpty
                              ? null
                              : controller.caste.value,
                          items: <String>[
                            'General',
                            'OBC',
                            'SC',
                            'ST',
                            'Other',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.caste.value = value!;
                          },
                          // validator: (value) => value == null || value.isEmpty
                          //     ? 'Select Caste'
                          //     : null,
                        )),
                    const SizedBox(height: 10),

                    // Symptoms (Title)
                    const Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),

                    _buildDropdownField(
                      label: "Select Symptoms",
                      items: controller.symptoms,
                      selectedValues: controller.selectedSymptoms,
                    ),

                    const SizedBox(height: 10),

                    // Doctor
                    const Text(
                      'Doctor Name',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: 'Select Doctor',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        items: controller.doctorsList.isEmpty
                            ? [
                                const DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('No Doctors Available'))
                              ]
                            : controller.doctorsList.map((doctor) {
                                return DropdownMenuItem<String>(
                                  value: doctor,
                                  child: Text(doctor),
                                );
                              }).toList(),
                        onChanged: (value) {
                          controller.selectedDoctor.value = value!;
                        },
                        value: controller.selectedDoctor.value.isNotEmpty
                            ? controller.selectedDoctor.value
                            : null, // Initial value
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select a doctor'
                            : null,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Submit Button
                    InkWell(
                      onTap: () => controller.submitForm(),
                      child: Obx(() => Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Appcolor.Primary, // Background color
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Appcolor.pure),
                                    )
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolor.pure, // Text color
                                      ),
                                    ),
                            ),
                          )),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// Widget for symtoms dropdown

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required RxList<String>
        selectedValues, // Use RxList to hold multiple selections
  }) {
    // Create a method to show the dropdown options with a search bar
    void _showDropdown(BuildContext context) {
      final TextEditingController _searchController = TextEditingController();
      final TextEditingController _othersController = TextEditingController();

      var filteredItems = items.obs;
      bool showOthersField =
          false; // Toggle for showing the "Others" text field

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
                            itemCount: filteredItems.length +
                                1, // Add "Others" at the top
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // "Others" field
                                return ListTile(
                                  title: const Text("Others"),
                                  trailing: const Icon(Icons.edit,
                                      color: Colors.grey),
                                  onTap: () {
                                    setState(() {
                                      showOthersField = true;
                                    });
                                  },
                                );
                              }

                              final item = filteredItems[
                                  index - 1]; // Adjust index for "Others"
                              final isSelected = selectedValues.contains(item);
                              return ListTile(
                                title: Text(item),
                                trailing: isSelected
                                    ? const Icon(Icons.check_box,
                                        color: Colors.blue)
                                    : const Icon(Icons.check_box_outline_blank),
                                onTap: () {
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
                      if (showOthersField) ...[
                        const SizedBox(height: 10),
                        // Custom "Others" input field
                        TextField(
                          controller: _othersController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Enter custom value',
                            labelStyle: const TextStyle(color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ),
                      ],
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
            borderRadius: BorderRadius.circular(5),
            border: Border.all(),
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
                    color: selectedValues.isNotEmpty
                        ? Colors.black
                        : Appcolor.Primary,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Adds ellipsis for long text
                ),
              ),
              const Icon(
                Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
      );
    });
  }

  String? validateSymptomsSelection(List<String> selectedSymptoms) {
    if (selectedSymptoms.isEmpty) {
      return 'Please select at least one symptom';
    }
    return null;
  }

  bool isValidAadhaarV1(String aadhaarNumber) {
    // Ensure the input is a 12-digit numeric string
    if (!RegExp(r'^\d{12}$').hasMatch(aadhaarNumber)) {
      return false; // Invalid Aadhaar number
    }

    const String d =
        '0123456789123406789523401789563401289567401239567859876043216598710432765982104387659321049876543210';
    const String p =
        '01234567891576283094580379614289160435279453126870428657390127938064157046913258';

    int c = 0; // Checksum
    String reversedNumber =
        aadhaarNumber.split('').reversed.join(); // Reverse the number

    try {
      for (int i = 0; i < reversedNumber.length; i++) {
        int digit =
            int.parse(reversedNumber[i]); // Parse each character to an integer
        int mIndex = (i % 8) * 10 + digit;
        int m = int.parse(p[mIndex]);
        int dIndex = c * 10 + m;
        c = int.parse(d[dIndex]);
      }
    } catch (e) {
      print('Error during Aadhaar validation: $e');
      return false; // Return invalid Aadhaar number if an exception occurs
    }

    return c == 0; // Return true if valid, otherwise false
  }
}
