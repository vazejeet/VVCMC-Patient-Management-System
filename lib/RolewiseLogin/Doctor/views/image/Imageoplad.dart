// import 'dart:io';
// import 'package:opd_app/RolewiseLogin/Doctor/views/doctorbottombar.dart';
// import 'package:opd_app/utils/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_compression_flutter/flutter_image_compress.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:image/image.dart' as img;
// import 'package:shared_preferences/shared_preferences.dart';

// class ImageUploadPage extends StatelessWidget {
//   final String ApplicationID;
//   final String patientName;
//   final String mobileNo;
//   final DiagnosisControllerss controller = Get.put(DiagnosisControllerss());

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController createdByController = TextEditingController();
//   final TextEditingController hospitalNameController = TextEditingController();

//   ImageUploadPage({
//     required this.ApplicationID,
//     required this.patientName,
//     required this.mobileNo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Image.asset("assets/logo.png", height: 40),
//         title: const Text(
//           'Upload Diagnosis',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Appcolor.Primary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Obx(() {
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title Field
//                 const Text(
//                   'Symptoms',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: titleController,
//                   onChanged: (value) => controller.title.value = value,
//                   decoration: InputDecoration(
//                     labelText: 'Enter Symptoms',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Patient name',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),

//                 TextFormField(
//                   controller: TextEditingController(text: patientName),
//                   decoration: InputDecoration(
//                     // labelText: 'Patient Name',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     border: const OutlineInputBorder(),
//                   ),
//                   readOnly: true, // Makes the TextField non-editable
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Mobile No',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),

//                 TextFormField(
//                   controller: TextEditingController(text: mobileNo),
//                   decoration: InputDecoration(
//                     // labelText: 'Mobile No',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     border: const OutlineInputBorder(),
//                   ),
//                   readOnly: true, // Makes the TextField non-editable
//                 ),
//                 const SizedBox(height: 20),

//                 // Created By Field
//                 const Text(
//                   'Hospital Id',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller:
//                       TextEditingController(text: controller.createdBy.value),
//                   onChanged: (value) => controller.createdBy.value = value,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Created By',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     border: const OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 20),

//                 // Hospital Name Field
//                 const Text(
//                   'Hospital Name',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: TextEditingController(
//                       text: controller.hospitalName.value),
//                   onChanged: (value) => controller.hospitalName.value = value,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Hospital Name',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     border: const OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Doctor Name',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: TextEditingController(
//                       text: controller.doctorNameController.text),
//                   onChanged: (value) =>
//                       controller.doctorNameController.text = value,
//                   decoration: InputDecoration(
//                     hintText: 'Enter Doctor Name',
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     border: const OutlineInputBorder(),
//                   ),
//                   readOnly: true,
//                 ),
//                 const SizedBox(height: 20),

//                 // Patient Details

//                 // Image Picker Button
//                 ElevatedButton.icon(
//                   onPressed: controller.pickImage,
//                   icon: const Icon(
//                     Icons.photo_library, // Icon for image picker
//                     color: Appcolor.pure, // Icon color
//                   ),
//                   label: const Text(
//                     'Pick Image',
//                     style: TextStyle(color: Appcolor.pure), // Text color
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Appcolor.Primary, // Button background color
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 12), // Padding inside the button
//                     shape: RoundedRectangleBorder(
//                       // Rounded corners for the button
//                       borderRadius: BorderRadius.circular(
//                           8), // Adjust the radius for a more box-like shape
//                     ),
//                     minimumSize: const Size(double.infinity,
//                         50), // Make button take full width and fixed height
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Display Image if selected
//                 controller.imageFile.value == null
//                     ? const Text(
//                         'No image selected',
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     : Image.file(controller.imageFile.value!),

//                 const SizedBox(height: 20),

//                 // Upload Diagnosis Button
//                 ElevatedButton(
//                   onPressed: () async {
//                     String hospitalId = await controller.getHospitalId();
//                     await controller.uploadDiagnosis(
//                       ApplicationID,
//                       {
//                         'title': titleController.text,
//                         'createdBy': controller.createdBy.value,
//                         'hospitalName': controller.hospitalName.value,
//                         'DoctorName': controller.doctorNameController.text,
//                         'patientName': patientName,
//                         'mobileNo': mobileNo,
//                         'hospitalId': hospitalId,
//                       },
//                     );
//                   },
//                   child: const Text(
//                     'Submit',
//                     style: TextStyle(color: Appcolor.pure, fontSize: 20),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Appcolor.Primary, // Button background color
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10), // Padding inside the button
//                     shape: RoundedRectangleBorder(
//                       // Rounded corners to make it box-shaped
//                       borderRadius: BorderRadius.circular(
//                           8), // You can adjust the radius as needed
//                     ),
//                     minimumSize: const Size(double.infinity,
//                         50), // Makes the button take up the full width of its parent and a fixed height
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// class DiagnosisControllerss extends GetxController {
//   var title = ''.obs;
//   var createdBy = ''.obs;
//   var hospitalName = ''.obs;
//   final doctorNameController = TextEditingController();
//   var hospitalId = ''.obs; // Observable for hospital ID
//   var imageFile = Rx<File?>(null);

//   final _picker = ImagePicker();

//   @override
//   void onInit() {
//     super.onInit();
//     initializeData();
//   }

//   Future<void> initializeData() async {
//     await loadHospitalDetails();
//     fetchDoctorName();
//   }

//   // Fetch both hospital ID and name from local storage
//   Future<void> loadHospitalDetails() async {
//     final prefs = await SharedPreferences.getInstance();
//     hospitalId.value = prefs.getString('HospitalId') ?? '';
//     hospitalName.value = prefs.getString('Hospital') ?? '';
//     createdBy.value = hospitalId.value; // Set initial createdBy value
//   }

//   void fetchDoctorName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String doctorName = prefs.getString('UserName') ?? 'Unknown Doctor';
//     doctorNameController.text = doctorName;

//     doctorNameController.selection =
//         TextSelection.collapsed(offset: doctorNameController.text.length);
//   }

//   // Get hospital ID from shared preferences
//   Future<String> getHospitalId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('HospitalId') ?? '';
//   }

//   // Upload diagnosis data and image
//    Future<void> uploadDiagnosis(
//       String ApplicationID, Map<String, String> diagnosisData) async {
//     if (imageFile.value == null ||
//         title.value.isEmpty ||
//         createdBy.value.isEmpty ||
//         hospitalName.value.isEmpty ||
//         doctorNameController.text.isEmpty) {
//       Get.snackbar("Error", "Please fill all fields and select an image.",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }

//     try {
//       File compressedImage = await compressImage(imageFile.value!);

//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             'https://vvcmhospitals.codifyinstitute.org/api/patients/$ApplicationID/diagnosis'),
//       );

//       request.fields['Title'] = diagnosisData['title']!;
//       request.fields['CreatedBy'] = diagnosisData['createdBy']!;
//       request.fields['HospitalName'] = diagnosisData['hospitalName']!;
//       request.fields['DoctorName'] = diagnosisData['DoctorName']!;
//       request.fields['PatientName'] = diagnosisData['patientName']!;
//       request.fields['MobileNo'] = diagnosisData['mobileNo']!;
//       request.fields['HospitalId'] = diagnosisData['hospitalId']!;

//       var fileBytes = await compressedImage.readAsBytes();
//       var multipartFile = http.MultipartFile.fromBytes(
//         'image',
//         fileBytes,
//         filename: compressedImage.path.split('/').last,
//         contentType: MediaType('image', 'jpeg'),
//       );
//       request.files.add(multipartFile);

//       var response = await request.send();

//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Diagnosis uploaded successfully!",
//             snackPosition: SnackPosition.BOTTOM);
//         Get.off(RoleBottomPage());
//         clearFields();
//       } else {
//         Get.snackbar("Error",
//             "Failed to upload diagnosis. Status Code: ${response.statusCode}",
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       Get.snackbar("Error", "Error occurred: $e",
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }

//   // Compress image to approximately 50KB
//   Future<File> compressImage(File imageFile) async {
//     final String targetPath =
//         '${imageFile.parent.path}/compressed_${imageFile.uri.pathSegments.last}';

//     final compressedFile = await FlutterImageCompress.compressAndGetFile(
//       imageFile.absolute.path,
//       targetPath,
//       quality: 50, // Adjust quality as needed for ~50KB
//     );

//     if (compressedFile != null) {
//       return compressedFile;
//     } else {
//       throw Exception("Image compression failed");
//     }
//   }

//   // Clear all input fields after upload
//   void clearFields() {
//     title.value = '';
//     createdBy.value = '';
//     hospitalName.value = '';
//     doctorNameController.text = '';
//     imageFile.value = null;
//   }

// // class DiagnosisControllerss extends GetxController {
// //   var title = ''.obs;
// //   var createdBy = ''.obs;
// //   var hospitalName = ''.obs;
// //   final doctorNameController = TextEditingController();
// //   var hospitalId = ''.obs; // Observable for hospital ID
// //   var imageFile = Rx<File?>(null);

// //   final _picker = ImagePicker();

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     initializeData();
// //   }

// //   Future<void> initializeData() async {
// //     await loadHospitalDetails();
// //      fetchDoctorName();
// //   }

// //   // Fetch both hospital ID and name from local storage
// //   Future<void> loadHospitalDetails() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     hospitalId.value = prefs.getString('HospitalId') ?? '';
// //     hospitalName.value = prefs.getString('Hospital') ?? '';
// //     createdBy.value = hospitalId.value; // Set initial createdBy value
// //   }
// //    void fetchDoctorName() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String doctorName = prefs.getString('UserName') ?? 'Unknown Doctor';
// //     doctorNameController.text = doctorName;

// //     doctorNameController.selection = TextSelection.collapsed(offset: doctorNameController.text.length);

// //   }

// //   // Get hospital ID from shared preferences
// //   Future<String> getHospitalId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('HospitalId') ?? '';
// //   }

// //   // Upload diagnosis data and image
// //   Future<void> uploadDiagnosis(
// //       String ApplicationID, Map<String, String> diagnosisData) async {
// //     if (imageFile.value == null ||
// //         title.value.isEmpty ||
// //         createdBy.value.isEmpty ||
// //         hospitalName.value.isEmpty ||
// //        doctorNameController.text.isEmpty ) {
// //       Get.snackbar("Error", "Please fill all fields and select an image.",
// //           snackPosition: SnackPosition.BOTTOM);
// //       return;
// //     }

// //     try {
// //       File resizedImage = await resizeImage(imageFile.value!);

// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse(
// //             'https://vvcmhospitals.codifyinstitute.org/api/patients/$ApplicationID/diagnosis'),
// //       );

// //       request.fields['Title'] = diagnosisData['title']!;
// //       request.fields['CreatedBy'] = diagnosisData['createdBy']!;
// //       request.fields['HospitalName'] = diagnosisData['hospitalName']!;
// //        request.fields['DoctorName'] = diagnosisData['DoctorName']!;
// //       request.fields['PatientName'] = diagnosisData['patientName']!;
// //       request.fields['MobileNo'] = diagnosisData['mobileNo']!;
// //       request.fields['HospitalId'] = diagnosisData['hospitalId']!;

// //       var fileBytes = await resizedImage.readAsBytes();
// //       var multipartFile = http.MultipartFile.fromBytes(
// //         'image',
// //         fileBytes,
// //         filename: resizedImage.path.split('/').last,
// //         contentType: MediaType('image', 'jpeg'),
// //       );
// //       request.files.add(multipartFile);

// //       var response = await request.send();

// //       if (response.statusCode == 200) {
// //         Get.snackbar("Success", "Diagnosis uploaded successfully!",
// //             snackPosition: SnackPosition.BOTTOM);
// //             Get.off(RoleBottomPage());
// //         clearFields();
// //       } else {
// //         Get.snackbar("Error",
// //             "Failed to upload diagnosis. Status Code: ${response.statusCode}",
// //             snackPosition: SnackPosition.BOTTOM);
// //       }
// //     } catch (e) {
// //       Get.snackbar("Error", "Error occurred: $e",
// //           snackPosition: SnackPosition.BOTTOM);
// //     }
// //   }

// //   // Resize image for upload
// //   Future<File> resizeImage(File imageFile) async {
// //     final img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
// //     img.Image resizedImage = img.copyResize(image, width: 800);

// //     final String newPath =
// //         '${imageFile.parent.path}/resized_${imageFile.uri.pathSegments.last}';
// //     final File resizedFile = File(newPath)
// //       ..writeAsBytesSync(img.encodeJpg(resizedImage));

// //     return resizedFile;
// //   }

//   Future<void> pickImage() async {
//     // Show a dialog to choose between camera or gallery
//     await showDialog(
//       context: Get.context!,
//       builder: (context) => AlertDialog(
//         backgroundColor: Appcolor.pure, // Background color of the dialog
//         title: const Text(
//           "Select Image Source",
//           style: TextStyle(
//             color: Appcolor.Primary, // Title color using pure color
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(
//                 Icons.camera_alt,
//                 color: Appcolor.Primary, // Icon color for camera option
//               ),
//               title: const Text(
//                 "Camera",
//                 style: TextStyle(
//                   color: Appcolor.Primary, // Text color using pure color
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               onTap: () async {
//                 Navigator.pop(context); // Close the dialog
//                 final pickedFile =
//                     await _picker.pickImage(source: ImageSource.camera);
//                 if (pickedFile != null) {
//                   imageFile.value = File(pickedFile.path);
//                 } else {
//                   Get.snackbar(
//                     "Error",
//                     "No image captured.",
//                     snackPosition: SnackPosition.BOTTOM,
//                     backgroundColor: Appcolor.Secondary,
//                     colorText: Appcolor.pure,
//                   );
//                 }
//               },
//             ),
//             Divider(
//               color: Appcolor.Secondary.withOpacity(
//                   0.5), // Divider between options
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.photo_library,
//                 color: Appcolor.Primary, // Icon color for gallery option
//               ),
//               title: const Text(
//                 "Gallery",
//                 style: TextStyle(
//                   color: Appcolor.Primary, // Text color using pure color
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               onTap: () async {
//                 Navigator.pop(context); // Close the dialog
//                 final pickedFile =
//                     await _picker.pickImage(source: ImageSource.gallery);
//                 if (pickedFile != null) {
//                   imageFile.value = File(pickedFile.path);
//                 } else {
//                   Get.snackbar(
//                     "Error",
//                     "No image selected.",
//                     snackPosition: SnackPosition.BOTTOM,
//                     backgroundColor: Appcolor.Secondary,
//                     colorText: Appcolor.pure,
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12), // Rounded corners for dialog
//         ),
//       ),
//     );
//   }
// }
