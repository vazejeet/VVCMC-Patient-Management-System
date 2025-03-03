// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../../utils/color.dart';
// import 'PatientTwoController.dart';

// class PatientAddTwo extends StatelessWidget {
//   final PatientTwoController controller = Get.put(PatientTwoController());

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: Image.asset("assets/logo.png"),
//           title: const Text(
//             'Patient Entry',
//             style: TextStyle(
//               color: Appcolor.pure,
//               fontWeight: FontWeight.bold,
//               fontSize: 24,
//             ),
//           ),
//           backgroundColor: Appcolor.Primary,
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 _onClearData();
//               },
//             ),
//           ],
//         ),
//         body: RefreshIndicator(
//           onRefresh: _onClearData,
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: controller.formKey1,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 10),
//                       const Text(
//                         'Mobile Number',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Enter Mobile Number',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         maxLength: 10,
//                         onChanged: (value) {
//                           controller.mobileNo.value = value;
//                           if (value.length == 10) {
//                             controller.fetchPatientsByMobile(value);
//                           }
//                         },
//                         validator: (value) =>
//                             value!.isEmpty ? 'Enter Mobile Number' : null,
//                       ),
//                       const SizedBox(height: 16),
//                       Obx(() {
//                         if (controller.patientFound.value) {
//                           return _buildPatientAddTwoFields(
//                               enabled: false, context: context);
//                         } else {
//                           return _buildPatientAddTwoFields(
//                               enabled: true, context: context);
//                         }
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _onClearData() async {
//     controller.formKey1.currentState?.reset();
//     controller.aadharCardNumber.value = '';
//     controller.patientName.value = '';
//     controller.mobileNo.value = '';
//     controller.emailId.value = '';
//     // controller.abhaNo.value = '';
//     controller.selectedDate.value = null;
//     controller.age.value = '';
//     controller.gender.value = '';
//     controller.caste.value = '';
//     controller.address.value = '';
//     controller.title.value = '';
//   }

//   Widget _buildPatientAddTwoFields(
//       {required bool enabled, required BuildContext context}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildTextField(
//           label: 'Patient Name',
//           controllerValue: controller.patientName,
//           enabled: enabled,
//         ),
//         const SizedBox(height: 16),
//         _buildTextAadharField(
//           label: 'ID Card Number',
//           controllerValue: controller.aadharCardNumber,
//           enabled: enabled,
//         ),
//         const SizedBox(height: 10),
//         _buildTextFieldss(
//           label: 'Email ID',
//           controllerValue: controller.emailId,
//           enabled: true,
//           isRequired: false,
//           fieldType: 'email',
//         ),
//         // const SizedBox(height: 10),
//         // _buildTextFieldabha(
//         //   label: 'Abha No',
//         //   controllerValue: controller.abhaNo,
//         //   enabled: enabled,
//         // ),
//         const SizedBox(height: 10),
//         const Text(
//           'Date of Birth',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.calendar_today),
//               onPressed: () => controller.selectDate(context),
//             ),
//             const SizedBox(width: 10),
//             Obx(() => Text(
//                   controller.selectedDate.value != null
//                       ? DateFormat('dd-MM-yyyy')
//                           .format(controller.selectedDate.value!)
//                       : 'Select Date',
//                   style: const TextStyle(fontSize: 16),
//                 )),
//             const SizedBox(width: 10),
//             Obx(() => Text(
//                   controller.age.value.isNotEmpty
//                       ? 'Age: ${controller.age.value} years'
//                       : 'Age: --',
//                   style: const TextStyle(fontSize: 16),
//                 )),
//           ],
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'Gender',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 6),
//         _buildGenderRadio(),
//         const SizedBox(height: 10),
//         const Text(
//           'Address',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: TextEditingController(text: controller.address.value),
//           decoration: InputDecoration(
//             hintText: 'Address',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           onSaved: (value) => controller.address.value = value!,
//           validator: (value) => value!.isEmpty ? 'Enter Address' : null,
//         ),
//         const SizedBox(height: 10),

//         const Text(
//           'Weight',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: TextEditingController(text: controller.weight.value),
//           maxLength: 3,
//           decoration: InputDecoration(
//             hintText: 'Weight',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           onSaved: (value) => controller.weight.value = value!,
//           validator: (value) => value!.isEmpty ? 'Enter weight' : null,
//         ),
//         const SizedBox(height: 10),

//         const Text(
//           'Caste',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 6),
//         Obx(() => DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 hintText: 'Select Caste',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//               value: controller.caste.value.isEmpty
//                   ? null
//                   : controller.caste.value,
//               items: <String>[
//                 'General',
//                 'OBC',
//                 'SC',
//                 'ST',
//                 'Other',
//               ].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 controller.caste.value = value!;
//               },
//               // validator: (value) =>
//               //     value == null || value.isEmpty ? 'Select Caste' : null,
//             )),
//         const SizedBox(height: 10),
//         const Text(
//           'Symptoms',
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 6),

//         _buildDropdownField(
//           label: "Symptoms",
//           items: controller.symptoms,
//           selectedValues: controller.selectedSymptoms,
//         ),

//         const SizedBox(height: 10),

//         // Doctor
//         const Text(
//           'Doctor Name',
//           style: TextStyle(
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Obx(
//           () => DropdownButtonFormField<String>(
//             decoration: InputDecoration(
//               hintText: 'Select Doctor',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             items: controller.doctorsList.isEmpty
//                 ? [
//                     const DropdownMenuItem<String>(
//                         value: '', child: Text('No Doctors Available'))
//                   ]
//                 : controller.doctorsList.map((doctor) {
//                     return DropdownMenuItem<String>(
//                       value: doctor,
//                       child: Text(doctor),
//                     );
//                   }).toList(),
//             onChanged: (value) {
//               controller.selectedDoctor.value = value!;
//             },
//             value: controller.selectedDoctor.value.isNotEmpty
//                 ? controller.selectedDoctor.value
//                 : null, // Initial value
//             validator: (value) => value == null || value.isEmpty
//                 ? 'Please select a doctor'
//                 : null,
//           ),
//         ),

//         // const SizedBox(height: 20),
//         // const SizedBox(height: 20),
//         // // Optionally Display CreatedBy (HospitalId) as Read-Only
//         // Obx(() => controller.createdBy.value.isNotEmpty
//         //     ? Column(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           const Text(
//         //             'Created By (Hospital ID)',
//         //             style: TextStyle(
//         //               fontSize: 16,
//         //             ),
//         //           ),
//         //           const SizedBox(height: 6),
//         //           Container(
//         //             padding: const EdgeInsets.symmetric(
//         //                 vertical: 12, horizontal: 10),
//         //             decoration: BoxDecoration(
//         //               border: Border.all(color: Colors.grey),
//         //               borderRadius: BorderRadius.circular(5),
//         //             ),
//         //             child: Text(
//         //               controller.createdBy.value,
//         //               style: const TextStyle(fontSize: 16),
//         //             ),
//         //           ),
//         //           const SizedBox(height: 20),
//         //           const Text(
//         //             'Hospital Name',
//         //             style: TextStyle(
//         //               fontSize: 16,
//         //             ),
//         //           ),
//         //           const SizedBox(height: 6),
//         //           Container(
//         //             padding: const EdgeInsets.symmetric(
//         //                 vertical: 12, horizontal: 10),
//         //             decoration: BoxDecoration(
//         //               border: Border.all(color: Colors.grey),
//         //               borderRadius: BorderRadius.circular(5),
//         //             ),
//         //             child: Text(
//         //               controller.hospitalName.value,
//         //               style: const TextStyle(fontSize: 16),
//         //             ),
//         //           ),
//         //           const SizedBox(height: 20),
//         //           const Text(
//         //             'Data Entry Name',
//         //             style: TextStyle(
//         //               fontSize: 16,
//         //             ),
//         //           ),
//         //           const SizedBox(height: 6),
//         //           Container(
//         //             padding: const EdgeInsets.symmetric(
//         //                 vertical: 12, horizontal: 10),
//         //             decoration: BoxDecoration(
//         //               border: Border.all(color: Colors.grey),
//         //               borderRadius: BorderRadius.circular(5),
//         //             ),
//         //             child: Text(
//         //               controller.dataEntryName.value,
//         //               style: const TextStyle(fontSize: 16),
//         //             ),
//         //           ),
//         //           const SizedBox(height: 20),
//         //         ],
//         //       )
//         //     : const SizedBox.shrink()),
//         const SizedBox(height: 20),
//         // InkWell(
//         //   onTap: controller.submitForm,
//         //   child: Container(
//         //     width: double.infinity,
//         //     padding: const EdgeInsets.symmetric(vertical: 15),
//         //     decoration: BoxDecoration(
//         //       color: Appcolor.Primary,
//         //       borderRadius: BorderRadius.circular(5),
//         //     ),
//         //     child: const Center(
//         //       child: Text(
//         //         'Submit',
//         //         style: TextStyle(
//         //           fontSize: 16,
//         //           fontWeight: FontWeight.bold,
//         //           color: Appcolor.pure,
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         InkWell(
//           onTap: () => controller.submitForm(),
//           child: Obx(() {
//             return Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 15),
//               decoration: BoxDecoration(
//                 color: Appcolor.Primary,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Center(
//                 child: controller.isLoading.value
//                     ? const CircularProgressIndicator(
//                         color: Appcolor.pure,
//                       )
//                     : const Text(
//                         'Submit',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Appcolor.pure,
//                         ),
//                       ),
//               ),
//             );
//           }),
//         ),

//         const SizedBox(height: 25),
//       ],
//     );
//   }

//   Widget _buildGenderRadio() {
//     return Obx(
//       () => Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Radio<String>(
//             value: 'Male',
//             groupValue: controller.gender.value,
//             onChanged: (value) {
//               controller.gender.value = value!;
//             },
//           ),
//           const Text('Male'),
//           const SizedBox(width: 15),
//           Radio<String>(
//             value: 'Female',
//             groupValue: controller.gender.value,
//             onChanged: (value) {
//               controller.gender.value = value!;
//             },
//           ),
//           const Text('Female'),
//           const SizedBox(width: 15),
//           Radio<String>(
//             value: 'Other',
//             groupValue: controller.gender.value,
//             onChanged: (value) {
//               controller.gender.value = value!;
//             },
//           ),
//           const Text('Other'),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(
//       {required String label,
//       required RxString controllerValue,
//       required bool enabled}) {
//     return TextFormField(
//       controller: TextEditingController(text: controllerValue.value),
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         enabled: enabled,
//       ),
//       onSaved: (value) => controllerValue.value = value!,
//       validator: (value) => value!.isEmpty ? 'This field is required' : null,
//     );
//   }

//   Widget _buildTextAadharField(
//       {required String label,
//       required RxString controllerValue,
//       required bool enabled}) {
//     return TextFormField(
//       controller: TextEditingController(text: controllerValue.value),
//       // maxLength: 12,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         enabled: enabled,
//       ),
//       onSaved: (value) => controllerValue.value = value!,
//     );
//   }

//   Widget _buildTextFieldss(
//       {required String label,
//       required RxString controllerValue,
//       required bool enabled,
//       required bool isRequired,
//       required String fieldType}) {
//     return TextFormField(
//       controller: TextEditingController(text: controllerValue.value),
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         enabled: enabled,
//       ),
//       onSaved: (value) => controllerValue.value = value!,
//       // validator: (value) {
//       //   if (isRequired && value!.isEmpty) {
//       //     return 'This field is required';
//       //   } else if (fieldType == 'email' && !GetUtils.isEmail(value!)) {
//       //     return 'Enter a valid email address';
//       //   }
//       //   return null;
//       //},
//     );
//   }

//   Widget _buildTextFieldabha(
//       {required String label,
//       required RxString controllerValue,
//       required bool enabled}) {
//     return TextFormField(
//       controller: TextEditingController(text: controllerValue.value),
//       maxLength: 14,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         enabled: enabled,
//       ),
//       onSaved: (value) => controllerValue.value = value!,
//       // validator: (value) => value!.isEmpty ? 'Enter Abha No' : null,
//     );
//   }

// // Widget for symtoms dropdown

//   Widget _buildDropdownField({
//     required String label,
//     required List<String> items,
//     required RxList<String>
//         selectedValues, // Use RxList to hold multiple selections
//   }) {
//     // Create a method to show the dropdown options with a search bar
//     void _showDropdown(BuildContext context) {
//       final TextEditingController _searchController = TextEditingController();
//       final TextEditingController _othersController = TextEditingController();

//       var filteredItems = items.obs;
//       bool showOthersField =
//           false; // Toggle for showing the "Others" text field

//       void _arrangeItems() {
//         List<String> nonSelectedItems =
//             items.where((item) => !selectedValues.contains(item)).toList();

//         List<String> arrangedSelectedItems = List<String>.from(selectedValues);

//         filteredItems.value = arrangedSelectedItems + nonSelectedItems;
//       }

//       _arrangeItems();

//       showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return AlertDialog(
//                 contentPadding: const EdgeInsets.all(16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 content: SizedBox(
//                   height: 300,
//                   width: double.maxFinite,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (!showOthersField) ...[
//                         // Search bar
//                         TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             fillColor: Colors.white,
//                             filled: true,
//                             labelText: 'Search',
//                             labelStyle: const TextStyle(color: Colors.blue),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(color: Colors.blue),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 16),
//                           ),
//                           onChanged: (value) {
//                             if (value.isEmpty) {
//                               setState(() {
//                                 _arrangeItems();
//                               });
//                             } else {
//                               setState(() {
//                                 filteredItems.value = filteredItems.value
//                                     .where((item) => item
//                                         .toLowerCase()
//                                         .contains(value.toLowerCase()))
//                                     .toList();
//                               });
//                             }
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                       // List of items
//                       Expanded(
//                         child: Obx(() {
//                           return ListView.builder(
//                             itemCount: filteredItems.length +
//                                 1, // Add "Others" at the top
//                             itemBuilder: (context, index) {
//                               if (index == 0) {
//                                 // "Others" field
//                                 return ListTile(
//                                   title: const Text("Others"),
//                                   trailing: const Icon(Icons.edit,
//                                       color: Colors.grey),
//                                   onTap: () {
//                                     setState(() {
//                                       showOthersField = true;
//                                     });
//                                   },
//                                 );
//                               }

//                               final item = filteredItems[
//                                   index - 1]; // Adjust index for "Others"
//                               final isSelected = selectedValues.contains(item);
//                               return ListTile(
//                                 title: Text(item),
//                                 trailing: isSelected
//                                     ? const Icon(Icons.check_box,
//                                         color: Colors.blue)
//                                     : const Icon(Icons.check_box_outline_blank),
//                                 onTap: () {
//                                   if (isSelected) {
//                                     selectedValues.remove(item);
//                                   } else {
//                                     selectedValues.add(item);
//                                   }
//                                   _arrangeItems();
//                                   setState(() {});
//                                 },
//                               );
//                             },
//                           );
//                         }),
//                       ),
//                       if (showOthersField) ...[
//                         const SizedBox(height: 10),
//                         // Custom "Others" input field
//                         TextField(
//                           controller: _othersController,
//                           decoration: InputDecoration(
//                             fillColor: Colors.white,
//                             filled: true,
//                             labelText: 'Enter custom value',
//                             labelStyle: const TextStyle(color: Colors.blue),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(color: Colors.blue),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 16),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 actions: [
//                   // Clear button
//                   TextButton(
//                     onPressed: () {
//                       selectedValues.clear();
//                       _arrangeItems();
//                       setState(() {});
//                     },
//                     child: const Text('Clear',
//                         style: TextStyle(color: Colors.orange)),
//                   ),
//                   // Done button
//                   TextButton(
//                     onPressed: () {
//                       if (showOthersField &&
//                           _othersController.text.isNotEmpty) {
//                         selectedValues
//                             .add(_othersController.text); // Add custom value
//                       }
//                       print("Selected Values: ${selectedValues.join(', ')}");
//                       Get.back();
//                     },
//                     child: const Text('Done',
//                         style: TextStyle(color: Colors.blue)),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       );
//     }

//     return Obx(() {
//       return GestureDetector(
//         onTap: () =>
//             _showDropdown(Get.context!), // Open the dropdown when tapped
//         child: Container(
//           width: double.infinity, // Ensures it takes the full available width
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Display selected values or the label if none selected
//               Flexible(
//                 child: Text(
//                   selectedValues.isNotEmpty
//                       ? selectedValues
//                           .join(', ') // Show comma-separated selected values
//                       : label,
//                   style: TextStyle(
//                     color: selectedValues.isNotEmpty
//                         ? Colors.black
//                         : Appcolor.Primary,
//                   ),
//                   overflow:
//                       TextOverflow.ellipsis, // Adds ellipsis for long text
//                 ),
//               ),
//               const Icon(
//                 Icons.arrow_drop_down,
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/color.dart';
import '../../controllers/patients/patientAdd.dart';
import '../dataentrybottombar.dart';
import 'PatientTwoController.dart';

class PatientAddTwo extends StatelessWidget {
  final PatientTwoController controller = Get.put(PatientTwoController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          // Navigate to the dashboard page
          Get.off(() => Dataentrybottombar());
          return false; // Prevent the default back button behavior
        },
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh,color: Appcolor.pure,),
                onPressed: () {
                  // Restart the page
                  Get.offAll(() => PatientAddTwo());
                },
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey1,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onChanged: (value) {
                          controller.mobileNo.value = value;
                          if (value.length == 10) {
                            controller.fetchPatientsByMobile(value);
                          }
                        },
                        validator: (value) =>
                            value!.isEmpty ? 'Enter Mobile Number' : null,
                      ),
                      const SizedBox(height: 30),
                      Obx(() {
                        if (controller.patientFound.value) {
                          return _buildPatientAddTwoFields(
                              enabled: false, context: context);
                        } else {
                          return Column(
                            children: [
                        GestureDetector(
                     
                                onTap: () {
    Get.to(() => PatientForm(), arguments: {"mobile": controller.mobileNo.value});
  },
                                child: Container(
                                  margin: EdgeInsets.only(left: 50, right: 50),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Appcolor.Primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add New Patient',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPatientAddTwoFields(
      {required bool enabled, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Patient Name*',
          controllerValue: controller.patientName,
          enabled: enabled,
        ),
        const SizedBox(height: 16),
        _buildTextAadharField(
          label: 'ID Card Number',
          controllerValue: controller.aadharCardNumber,
          enabled: enabled,
        ),
       // const SizedBox(height: 10),
        // _buildTextFieldss(
        //   label: 'Email ID',
        //   controllerValue: controller.emailId,
        //   enabled: true,
        //   isRequired: false,
        //   fieldType: 'email',
        // ),

        // Check if the data is not empty before displaying the field
// controller.emailId.isNotEmpty 
//     ? _buildTextFieldss(
//         label: 'Email ID',
//         controllerValue: controller.emailId,
//         enabled: true,
//         isRequired: false,
//         fieldType: 'email',
//       ) 
//     : SizedBox.shrink(), // Hide the field if data is empty


        const SizedBox(height: 10),
      

         _buildTextField(
          label: 'Age*',
          controllerValue: controller.age,
          enabled: enabled,
        ),
      
        const SizedBox(height: 10),
         _buildTextField(
          label: 'Gender*',
          controllerValue: controller.gender,
          enabled: enabled,
        ),
        // const Text(
        //   'Gender*',
        //   style: TextStyle(fontSize: 16),
        // ),
        // const SizedBox(height: 6),
        // _buildGenderRadio(),
        const SizedBox(height: 10),
        const Text(
          'Address*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: TextEditingController(text: controller.address.value),
          decoration: InputDecoration(
            hintText: 'Address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onSaved: (value) => controller.address.value = value!,
          validator: (value) => value!.isEmpty ? 'Enter Address' : null,
        ),
        const SizedBox(height: 10),

        const Text(
          'Weight*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: TextEditingController(text: controller.weight.value),
          maxLength: 3,
          decoration: InputDecoration(
            hintText: 'Weight',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onSaved: (value) => controller.weight.value = value!,
          validator: (value) => value!.isEmpty ? 'Enter weight' : null,
        ),
        const SizedBox(height: 10),

        const Text(
          'Category',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Select Category',
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
              // validator: (value) =>
              //     value == null || value.isEmpty ? 'Select Caste' : null,
            )),
        const SizedBox(height: 10),
        const Text(
          'Symptoms*',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 6),

        _buildDropdownField(
          label: "Symptoms",
          items: controller.symptoms,
          selectedValues: controller.selectedSymptoms,
        ),

        const SizedBox(height: 10),

        // Doctor
        const Text(
          'Doctor Name*',
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
                        value: '', child: Text('No Doctors Available'))
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
        InkWell(
          onTap: controller.submitForm,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Appcolor.Primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.pure,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildGenderRadio() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio<String>(
            value: 'Male',
            groupValue: controller.gender.value,
            onChanged: (value) {
              controller.gender.value = value!;
            },
          ),
          const Text('Male'),
          const SizedBox(width: 15),
          Radio<String>(
            value: 'Female',
            groupValue: controller.gender.value,
            onChanged: (value) {
              controller.gender.value = value!;
            },
          ),
          const Text('Female'),
          const SizedBox(width: 15),
          Radio<String>(
            value: 'Other',
            groupValue: controller.gender.value,
            onChanged: (value) {
              controller.gender.value = value!;
            },
          ),
          const Text('Other'),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required RxString controllerValue,
      required bool enabled}) {
    return TextFormField(
      controller: TextEditingController(text: controllerValue.value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        enabled: enabled,
      ),
      onSaved: (value) => controllerValue.value = value!,
      validator: (value) => value!.isEmpty ? 'This field is required' : null,
    );
  }

  Widget _buildTextAadharField(
      {required String label,
      required RxString controllerValue,
      required bool enabled}) {
    return TextFormField(
      controller: TextEditingController(text: controllerValue.value),
      // maxLength: 12,
      // keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        enabled: enabled,
      ),
      onSaved: (value) => controllerValue.value = value!,
    );
  }

  Widget _buildTextFieldss(
      {required String label,
      required RxString controllerValue,
      required bool enabled,
      required bool isRequired,
      required String fieldType}) {
    return TextFormField(
      controller: TextEditingController(text: controllerValue.value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        enabled: enabled,
      ),
      onSaved: (value) => controllerValue.value = value!,
      // validator: (value) {
      //   if (isRequired && value!.isEmpty) {
      //     return 'This field is required';
      //   } else if (fieldType == 'email' && !GetUtils.isEmail(value!)) {
      //     return 'Enter a valid email address';
      //   }
      //   return null;
      //},
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
}