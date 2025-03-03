// import 'package:get/get.dart';
// import 'package:opd_app/utils/color.dart';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/services.dart';
// import 'package:printing/printing.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';

// class PatientDetailPage extends StatefulWidget {
//   final dynamic patient;

//   const PatientDetailPage({Key? key, required this.patient}) : super(key: key);

//   @override
//   _PatientDetailPageState createState() => _PatientDetailPageState();
// }

// class _PatientDetailPageState extends State<PatientDetailPage> {
//   Map<int, bool> selectedDiagnoses = {};

//   var patientDateTime = DateTime.now().obs;
//   late pw.Font marathiFont;
//   pw.Font? englishFont; // Make it nullable initially
//   Future<void> loadFonts() async {
//     // Load Marathi font
//     final marathiFontData =
//         await rootBundle.load('assets/fonts/TiroDevanagariMarathi-Regular.ttf');
//     marathiFont = pw.Font.ttf(marathiFontData);

//     // Load English font
//     final englishFontData =
//         await rootBundle.load('assets/fonts/NotoSans-Black.ttf');
//     englishFont = pw.Font.ttf(englishFontData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final patient = widget.patient;

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: Image.asset("assets/logo.png"),
//           title: const Text(
//             'Diagnosis Patient Details',
//             style: TextStyle(color: Colors.white),
//           ),
//           backgroundColor: Appcolor.Primary,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.picture_as_pdf),
//               onPressed: _generateReport,
//               tooltip: 'Generate Report',
//               color: Colors.white,
//             ),
//           ],
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Appcolor.Primary.withOpacity(0.8),
//                 Appcolor.Secondary,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Patient ID: ${patient['ApplicationID']?.toString() ?? ""}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Hospital Name: ${patient['HospitalName']?.toString() ?? ""}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Patient Name: ${patient['PatientName']?.toString() ?? ""}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Mobile No: ${patient['MobileNo']?.toString() ?? ""}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               // Text(
//               //   'ID Card No: ${patient['Idcard']}',
//               //   style: const TextStyle(
//               //     fontSize: 16,
//               //     fontWeight: FontWeight.bold,
//               //     color: Colors.white,
//               //   ),
//               // ),
//               Text(
//                 'Gender: ${patient['Gender']}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Age: ${patient['AGE']}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 'Weight: ${patient['Weight']}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               SizedBox(
//                 height: 20,
//               ),

//               Text(
//                 'Hayat Pramanpatra (Live Certificate)',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               SizedBox(
//                 height: 10,
//               ),
//               InkWell(
//                 onTap: () {
//                   // Call your method to generate and download the PDF
//                   generateAndPrintPDF();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.white, // Button background color
//                     borderRadius: BorderRadius.circular(8), // Rounded corners
//                     border: Border.all(
//                         color: Colors.teal, width: 1.5), // Border outline
//                     boxShadow: [
//                       BoxShadow(
//                         color:
//                             Colors.grey.withOpacity(0.2), // Light shadow effect
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3), // Shadow direction
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisSize:
//                         MainAxisSize.min, // Make the row size fit the content
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.print,
//                           color: Colors.teal, size: 22), // Download icon
//                       SizedBox(width: 8),
//                       Text(
//                         'Generate Certificate', // Button text
//                         style: TextStyle(
//                           color: Colors.teal,
//                           fontSize: 17,
//                           fontWeight: FontWeight
//                               .w600, // Slightly bold for better visibility
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),
//               const Text(
//                 'Diagnosis:',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),

//               Expanded(
//                 child: ListView.builder(
//                   itemCount: patient['Symptoms'].length,
//                   itemBuilder: (context, index) {
//                     final symptom = patient['Symptoms'][index];

//                     // Check if all required fields are non-empty or image is not null
//                     final hasRequiredFields =
//                         (symptom['Diagnosis']?.isNotEmpty ?? false) &&
//                             (symptom['Test']?.isNotEmpty ?? false) &&
//                             (symptom['DoctorName']?.isNotEmpty ?? false) &&
//                             (symptom['Medicine'] != null &&
//                                 symptom['Medicine'].isNotEmpty);

//                     final hasImage = symptom['image'] != null;

//                     if (!hasRequiredFields && !hasImage) {
//                       return const SizedBox.shrink(); // Skip this symptom
//                     }

//                     return Card(
//                       elevation: 5,
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 10.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: selectedDiagnoses[index] ?? false,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedDiagnoses[index] = value ?? false;
//                                     });
//                                   },
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     'Symptoms: ${symptom['Title'] ?? ""}',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.0,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Diagnosis: ${symptom['Diagnosis'] ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
//                                   Text(
//                                     'Test: ${symptom['Test'] ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
//                                    Text(
//                                     'Medicine: ${symptom['Medicine']?.join(", ") ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
//                                   Text(
//                                     'Doctor: ${symptom['DoctorName'] ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
//                                    Text(
//                                     'Hospital Name: ${symptom['HospitalName'] ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
                                 
//                                   Text(
//                                     'Refer: ${symptom['ref'] ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
//                                   Text(
//                                     'FollowUp: ${symptom['followup'] ?? ""}',
//                                     style: const TextStyle(fontSize: 14.0),
//                                   ),
//                                   if (symptom['DateTime'] != null)
//                                     Text(
//                                       'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(symptom['DateTime']))}',
//                                       style: const TextStyle(fontSize: 14.0),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             if (hasImage)
//                               GestureDetector(
//                                 onTap: () {
//                                   _showZoomedImageDialog(
//                                       context, symptom['image']);
//                                 },
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   child: Image.network(
//                                     symptom['image']!,
//                                     width: 60,
//                                     height: 60,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error,
//                                             stackTrace) =>
//                                         const Icon(Icons.image_not_supported,
//                                             size: 60),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to show the zoomed-in image in a dialog
//   void _showZoomedImageDialog(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Stack(
//             children: [
//               Center(
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: IconButton(
//                   icon: Icon(Icons.close, color: Colors.white, size: 30),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Generate PDF Report
//   void _generateReport() async {
//     final pdf = pw.Document();
//     final patient = widget.patient;

//     // Collect selected symptoms
//     final selectedSymptoms = patient['Symptoms']
//         .asMap()
//         .entries
//         .where((entry) => selectedDiagnoses[entry.key] == true)
//         .map((entry) => entry.value)
//         .toList();

//     if (selectedSymptoms.isEmpty) {
//       // Show a message if no items are selected
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'Please select at least one diagnosis to generate a report.'),
//         ),
//       );
//       return;
//     }

//     // Add the logo image at the top (you need to put the logo in assets)
//     final logoImage = await _loadImageFromAssets('assets/logo.png');

//     // Add the report pages for each selected symptom
//     for (final symptom in selectedSymptoms) {
//       // Fetch the image from network if it exists
//       Uint8List? imageBytes;
//       if (symptom['image'] != null) {
//         imageBytes = await _fetchImageBytes(symptom['image']);
//       }

//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 // Add the logo at the top
//                 if (logoImage != null)
//                   pw.Row(
//                     children: [
//                       if (logoImage != null)
//                         pw.Image(
//                           pw.MemoryImage(logoImage),
//                           width: 50, // Adjust logo width
//                         ),
//                       pw.SizedBox(width: 10),
//                       pw.Text(
//                         'VVCMC ${patient['HospitalName'] ?? ""}',
//                         style: pw.TextStyle(
//                           fontSize: 18,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),

//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text(
//                       'Diagnosis Report',
//                       style: pw.TextStyle(
//                         fontSize: 20,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     if (symptom['DateTime'] != null)
//                       pw.Text(
//                         'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(symptom['DateTime']))}',
//                         style: pw.TextStyle(
//                           fontSize: 18,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                   ],
//                 ),

//                 pw.Divider(),
//                 pw.Text('Case Paper: ${patient['ApplicationID'] ?? ""}'),
//                 pw.SizedBox(height: 3),
//                 pw.Text('Patient Name: ${patient['PatientName'] ?? ""}'),
//                 pw.SizedBox(height: 3),
//                 pw.Text('Gender: ${patient['Gender'] ?? ""}'),
//                 pw.SizedBox(height: 3),
//                 pw.Text('Age: ${patient['AGE'] ?? ""}'),
//                 pw.SizedBox(height: 3),
//                 pw.Text('Mobile No: ${patient['MobileNo'] ?? ""}'),
//                 pw.SizedBox(height: 3),
//                 pw.Text('Weight: ${patient['Weight'] ?? ""}'),
//                 pw.SizedBox(height: 16),

//                 pw.Text(
//                   'Diagnosis Details:',
//                   style: pw.TextStyle(
//                       fontSize: 20, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Table(
//                   border: pw.TableBorder.all(),
//                   children: [
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('Doctor Name:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('${symptom['DoctorName'] ?? ""}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('Symptoms:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('${symptom['Title'] ?? ""}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('Diagnosis:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('${symptom['Diagnosis'] ?? ""}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('Test:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('${symptom['Test'] ?? ""}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('Medicine:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text(
//                               '${symptom['Medicine']?.join(", ") ?? "No medicines provided"}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('Refer:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('${symptom['ref'] ?? ""}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('FollowUp:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Padding(
//                           padding: pw.EdgeInsets.all(5),
//                           child: pw.Text('${symptom['followup'] ?? ""}'),
//                         ),
//                       ],
//                     ),
//                     pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: pw.EdgeInsets.only(
//                             top: 30,
//                             left: 5,
//                           ),
//                           child: pw.Text('Remarks:',
//                               style:
//                                   pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                         ),
//                         pw.Container(
//                           width: 300,
//                           height: 80,
//                           decoration: pw.BoxDecoration(
//                             border: pw.Border.all(),
//                           ),
//                           child: pw.Padding(
//                             padding: pw.EdgeInsets.all(5),
//                             child: pw.Text(
//                               '',
//                               style: pw.TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 if (imageBytes != null)
//                   pw.Image(
//                     pw.MemoryImage(imageBytes),
//                     fit: pw.BoxFit.contain,
//                     width: 150,
//                   ),
//               ],
//             );
//           },
//         ),
//       );
//     }

//     // Print or save the generated PDF
//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save(),
//     );
//   }

//   // Function to load image from assets
//   Future<Uint8List?> _loadImageFromAssets(String path) async {
//     try {
//       final ByteData data = await rootBundle.load(path);
//       return data.buffer.asUint8List();
//     } catch (e) {
//       return null;
//     }
//   }

//   // Fetch image from URL and return the bytes
//   Future<Uint8List?> _fetchImageBytes(String imageUrl) async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return null;
//     }
//   }

//   // hayat form

//   // Future<void> generateAndPrintPDF() async {
//   //   await loadFonts(); // Ensure fonts are loaded before using them

//   //   final patient = widget.patient; // Ensure this is a map with 'PatientName'

//   //   final pdf = pw.Document();
//   //   final formattedPatientDate =
//   //       DateFormat('dd-MM-yyyy').format(patientDateTime.value);

//   //   pdf.addPage(
//   //     pw.Page(
//   //       build: (pw.Context context) => pw.Padding(
//   //         padding: pw.EdgeInsets.all(16),
//   //         child: pw.Column(
//   //           crossAxisAlignment: pw.CrossAxisAlignment.start,
//   //           children: [
//   //             pw.SizedBox(height: 30),
//   //             pw.Center(
//   //               child: pw.Text(
//   //                 'हयात प्रमाणपत्र  (Live Certificate)',
//   //                 style: pw.TextStyle(
//   //                   fontSize: 20,
//   //                   fontWeight: pw.FontWeight.bold,
//   //                   font: marathiFont, // Fallback font
//   //                   // letterSpacing: 1.3,
//   //                   height: 1.6,
//   //                 ),
//   //               ),
//   //             ),
//   //             pw.SizedBox(height: 50),
//   //             buildPdfRow(
//   //                 '            असे प्रमाणित करण्यात येते की, Mr/Mrs : ${patient['PatientName'] ?? ""} '
//   //                 'राहणार: ${patient['Residence'] ?? ""}, तालुका: वसई, जिल्हा: पालघर, '
//   //                 'हे / ह्या _____________________________________________ या योजनेखालील लाभार्थी असून, '
//   //                 'हयातीचा पुरावा म्हणून आज दिनांक $formattedPatientDate रोजी माझ्यासमोर प्रत्यक्ष हजर राहिले / राहिल्या.',
//   //                 font: marathiFont),

//   //             pw.SizedBox(height: 50),
//   //             //             // First Row: Place and Signature
//   //             pw.Row(
//   //               children: [
//   //                 pw.Expanded(
//   //                   flex: 1, // Left side of the row
//   //                   child: pw.Text(
//   //                     'स्थळ: ____________',
//   //                     style: pw.TextStyle(
//   //                       fontSize: 18,
//   //                       font: marathiFont,
//   //                       letterSpacing: 1.3,
//   //                       height: 2.0,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 pw.Expanded(
//   //                   flex: 1, // Right side of the row
//   //                   child: pw.Text(
//   //                     'सही: ___________',
//   //                     style: pw.TextStyle(
//   //                       fontSize: 18,
//   //                       font: marathiFont,
//   //                       height: 2.0,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //             pw.SizedBox(height: 10),

//   //             // Second Row: Date and Officer Details
//   //             pw.Row(
//   //               children: [
//   //                 pw.Expanded(
//   //                   flex: 1, // Left side of the row
//   //                   child: pw.Text(
//   //                     'दिनांक: $formattedPatientDate',
//   //                     style: pw.TextStyle(
//   //                       fontSize: 18,
//   //                       font: marathiFont,
//   //                       height: 2.0,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 pw.Expanded(
//   //                   flex: 1, // Right side of the row
//   //                   child: pw.Text(
//   //                     'तपासणी अधिकाऱ्याने नाव, हुद्दा व कार्यालयाचा शिक्का.',
//   //                     style: pw.TextStyle(
//   //                       fontSize: 18,
//   //                       font: marathiFont,
//   //                       height: 2.0,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );

//   //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   // }

//   // pw.Widget buildPdfRow(String text, {pw.Font? font}) {
//   //   return pw.Padding(
//   //     padding: pw.EdgeInsets.symmetric(vertical: 8),
//   //     child: pw.Row(
//   //       crossAxisAlignment: pw.CrossAxisAlignment.start,
//   //       children: [
//   //         pw.Expanded(
//   //           child: pw.Text(
//   //             text,
//   //             style: pw.TextStyle(
//   //               fontSize: 18,
//   //               font: font ?? englishFont,
//   //               height: 16.0,
//   //             ),
//   //             textAlign: pw.TextAlign.justify,
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Future<void> generateAndPrintPDF() async {
//     final patient = widget.patient; // Ensure this is a map with 'PatientName'

//     final pdf = pw.Document();
//     final formattedPatientDate =
//         DateFormat('dd-MM-yyyy').format(patientDateTime.value);

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Padding(
//           padding: pw.EdgeInsets.all(16),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               pw.SizedBox(height: 20),
//               pw.Center(
//                 child: pw.Text(
//                   'Hayat Pramanpatra (Live Certificate)',
//                   style: pw.TextStyle(
//                     fontSize: 20,
//                     fontWeight: pw.FontWeight.bold,
//                     font: englishFont,
//                     letterSpacing: 1.3,
//                     height: 1.6,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 50),

//               buildPdfRow(
//                   '         It is hereby certified that, Mr/Mrs : ${patient['PatientName']?.toString() ?? ""}. '
//                   'Residing at: ${patient['Residence']?.toString() ?? ""}, Taluka: Vasai, District: Palghar, '
//                   'is a beneficiary under the ___________________________________. '
//                   'Appeared before me today, $formattedPatientDate as proof of life.'),

//               pw.SizedBox(height: 50),

//               // First Row: Place and Signature
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     flex: 1, // Left side of the row
//                     child: pw.Text(
//                       'Place: ____________',
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         font: englishFont,
//                         letterSpacing: 1.3,
//                         height: 1.6,
//                       ),
//                     ),
//                   ),
//                   pw.Expanded(
//                     flex: 1, // Right side of the row
//                     child: pw.Text(
//                       'Signature: ___________',
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         font: englishFont,
//                         letterSpacing: 1.3,
//                         height: 1.6,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               pw.SizedBox(height: 10),

//               // Second Row: Date and Officer Details
//               pw.Row(
//                 children: [
//                   pw.Expanded(
//                     flex: 1, // Left side of the row
//                     child: pw.Text(
//                       'Date: $formattedPatientDate',
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         font: englishFont,
//                         letterSpacing: 1.3,
//                         height: 1.6,
//                       ),
//                     ),
//                   ),
//                   pw.Expanded(
//                     flex: 1, // Right side of the row
//                     child: pw.Text(
//                       'Name, Title, and Official Seal of the Verification Officer.',
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         font: englishFont,
//                         letterSpacing: 1.3,
//                         height: 1.6,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               // Add Date and Patient's Name in English
//               pw.SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   pw.Widget buildPdfRow(String text) {
//     return pw.Padding(
//       padding: pw.EdgeInsets.symmetric(vertical: 8),
//       child: pw.Row(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Expanded(
//             child: pw.Text(
//               text,
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 font: englishFont,
//                 letterSpacing: 1.3,
//                 height: 1.6,
//               ),
//               textAlign:
//                   pw.TextAlign.justify, // Justify the text for proper alignment
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:opd_app/utils/color.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class PatientDetailPage extends StatefulWidget {
  final dynamic patient;

  const PatientDetailPage({Key? key, required this.patient}) : super(key: key);

  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

  String? selectedCertificate;

 

class _PatientDetailPageState extends State<PatientDetailPage> {
   void handleCertificateSelection(String? value) {
    setState(() {
      selectedCertificate = value;
    });

    if (value == 'Hayat Pramanpatra') {
      generateAndPrintPDF();
    } else if (value == 'Certificate of Rest') {
      generateAndPrintCertificatePDF();
    } else if (value == 'Fitness for Duty') {
      generateFitnessCertificatePDF();
    }
  }
  Map<int, bool> selectedDiagnoses = {};

  var patientDateTime = DateTime.now().obs;
  late pw.Font marathiFont;
  pw.Font? englishFont; // Make it nullable initially
  Future<void> loadFonts() async {
    // Load Marathi font
    final marathiFontData =
        await rootBundle.load('assets/fonts/TiroDevanagariMarathi-Regular.ttf');
    marathiFont = pw.Font.ttf(marathiFontData);

    // Load English font
    final englishFontData =
        await rootBundle.load('assets/fonts/NotoSans-Black.ttf');
    englishFont = pw.Font.ttf(englishFontData);
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'Diagnosis Patient Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Appcolor.Primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _generateReport,
              tooltip: 'Generate Report',
              color: Colors.white,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Appcolor.Primary.withOpacity(0.8),
                Appcolor.Secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient ID: ${patient['ApplicationID']?.toString() ?? ""}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Hospital Name: ${patient['HospitalName']?.toString() ?? ""}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Patient Name: ${patient['PatientName']?.toString() ?? ""}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Mobile No: ${patient['MobileNo']?.toString() ?? ""}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Text(
              //   'ID Card No: ${patient['Idcard']}',
              //   style: const TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              Text(
                'Gender: ${patient['Gender']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Age: ${patient['AGE']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Weight: ${patient['Weight']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              
        const Text(
          'Generate Certificate',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCertificate,
              hint: const Text(
                'Select Certificate',
                style: TextStyle(color: Colors.teal),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'Hayat Pramanpatra',
                  child: Text('Hayat Pramanpatra (Live Certificate)'),
                ),
                DropdownMenuItem(
                  value: 'Certificate of Rest',
                  child: Text('Certificate of Rest'),
                ),
                DropdownMenuItem(
                  value: 'Fitness for Duty',
                  child: Text('Certificate of Fitness for Duty'),
                ),
              ],
              onChanged: handleCertificateSelection,
            ),
          ),
        ),
   

              // const Text(
              //   'Hayat Pramanpatra (Live Certificate)',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),

              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     // Call your method to generate and download the PDF
              //     generateAndPrintPDF();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              //     decoration: BoxDecoration(
              //       color: Colors.white, // Button background color
              //       borderRadius: BorderRadius.circular(8), // Rounded corners
              //       border: Border.all(
              //           color: Colors.teal, width: 1.5), // Border outline
              //       boxShadow: [
              //         BoxShadow(
              //           color:
              //               Colors.grey.withOpacity(0.2), // Light shadow effect
              //           spreadRadius: 2,
              //           blurRadius: 5,
              //           offset: Offset(0, 3), // Shadow direction
              //         ),
              //       ],
              //     ),
              //     child: const Row(
              //       mainAxisSize:
              //           MainAxisSize.min, // Make the row size fit the content
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.print,
              //             color: Colors.teal, size: 22), // Download icon
              //         SizedBox(width: 8),
              //         Text(
              //           'Generate Certificate', // Button text
              //           style: TextStyle(
              //             color: Colors.teal,
              //             fontSize: 17,
              //             fontWeight: FontWeight
              //                 .w600, // Slightly bold for better visibility
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const Text(
              //   'CERTIFICATE OF REST',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(  height: 8,   ),
              // InkWell(
              //   onTap: () {
              //     // Call your method to generate and download the PDF
              //     generateAndPrintCertificatePDF();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              //     decoration: BoxDecoration(
              //       color: Colors.white, // Button background color
              //       borderRadius: BorderRadius.circular(8), // Rounded corners
              //       border: Border.all(
              //           color: Colors.teal, width: 1.5), // Border outline
              //       boxShadow: [
              //         BoxShadow(
              //           color:
              //               Colors.grey.withOpacity(0.2), // Light shadow effect
              //           spreadRadius: 2,
              //           blurRadius: 5,
              //           offset: Offset(0, 3), // Shadow direction
              //         ),
              //       ],
              //     ),
              //     child: const Row(
              //       mainAxisSize:
              //           MainAxisSize.min, // Make the row size fit the content
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.print,
              //             color: Colors.teal, size: 22), // Download icon
              //         SizedBox(width: 8),
              //         Text(
              //           'Generate Certificate', // Button text
              //           style: TextStyle(
              //             color: Colors.teal,
              //             fontSize: 17,
              //             fontWeight: FontWeight
              //                 .w600, // Slightly bold for better visibility
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(
              //   height: 20,
              // ),
              // const Text(
              //   'CERTIFICATE OF FITNESS FOR DUTY',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // InkWell(
              //   onTap: () {
              //     // Call your method to generate and download the PDF
              //     generateFitnessCertificatePDF();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              //     decoration: BoxDecoration(
              //       color: Colors.white, // Button background color
              //       borderRadius: BorderRadius.circular(8), // Rounded corners
              //       border: Border.all(
              //           color: Colors.teal, width: 1.5), // Border outline
              //       boxShadow: [
              //         BoxShadow(
              //           color:
              //               Colors.grey.withOpacity(0.2), // Light shadow effect
              //           spreadRadius: 2,
              //           blurRadius: 5,
              //           offset: const Offset(0, 3), // Shadow direction
              //         ),
              //       ],
              //     ),
              //     child: const Row(
              //       mainAxisSize:
              //           MainAxisSize.min, // Make the row size fit the content
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.print,
              //             color: Colors.teal, size: 22), // Download icon
              //         SizedBox(width: 8),
              //         Text(
              //           'Generate Certificate', // Button text
              //           style: TextStyle(
              //             color: Colors.teal,
              //             fontSize: 17,
              //             fontWeight: FontWeight
              //                 .w600, // Slightly bold for better visibility
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              const SizedBox(height: 10),

              const Text(
                'Diagnosis:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: patient['Symptoms'].length,
                  itemBuilder: (context, index) {
                    final symptom = patient['Symptoms'][index];

                    // Check if all required fields are non-empty or image is not null
                    final hasRequiredFields =
                        (symptom['Diagnosis']?.isNotEmpty ?? false) &&
                            (symptom['Test']?.isNotEmpty ?? false) &&
                            (symptom['DoctorName']?.isNotEmpty ?? false) &&
                            (symptom['Medicine'] != null &&
                                symptom['Medicine'].isNotEmpty);

                    final hasImage = symptom['image'] != null;

                    if (!hasRequiredFields && !hasImage) {
                      return const SizedBox.shrink(); // Skip this symptom
                    }

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: selectedDiagnoses[index] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDiagnoses[index] = value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'Symptoms: ${symptom['Title'] ?? ""}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Diagnosis: ${symptom['Diagnosis'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Test: ${symptom['Test'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Medicine: ${symptom['Medicine']?.join(", ") ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Doctor: ${symptom['DoctorName'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Hospital Name: ${symptom['HospitalName'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Refer: ${symptom['ref'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'FollowUp: ${symptom['followup'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  if (symptom['DateTime'] != null)
                                    Text(
                                      'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(symptom['DateTime']))}',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                ],
                              ),
                            ),
                            if (hasImage)
                              GestureDetector(
                                onTap: () {
                                  _showZoomedImageDialog(
                                      context, symptom['image']);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    symptom['image']!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.image_not_supported,
                                            size: 60),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the zoomed-in image in a dialog
  void _showZoomedImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Generate PDF Report
  void _generateReport() async {
    final pdf = pw.Document();
    final patient = widget.patient;

    // Collect selected symptoms
    final selectedSymptoms = patient['Symptoms']
        .asMap()
        .entries
        .where((entry) => selectedDiagnoses[entry.key] == true)
        .map((entry) => entry.value)
        .toList();

    if (selectedSymptoms.isEmpty) {
      // Show a message if no items are selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please select at least one diagnosis to generate a report.'),
        ),
      );
      return;
    }

    // Add the logo image at the top (you need to put the logo in assets)
    final logoImage = await _loadImageFromAssets('assets/logo.png');

    // Add the report pages for each selected symptom
    for (final symptom in selectedSymptoms) {
      // Fetch the image from network if it exists
      Uint8List? imageBytes;
      if (symptom['image'] != null) {
        imageBytes = await _fetchImageBytes(symptom['image']);
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Add the logo at the top
                if (logoImage != null)
                  pw.Row(
                    children: [
                      if (logoImage != null)
                        pw.Image(
                          pw.MemoryImage(logoImage),
                          width: 50, // Adjust logo width
                        ),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'VVCMC ${patient['HospitalName'] ?? ""}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Diagnosis Report',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (symptom['DateTime'] != null)
                      pw.Text(
                        'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(symptom['DateTime']))}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                  ],
                ),

                pw.Divider(),
                pw.Text('Case Paper: ${patient['ApplicationID'] ?? ""}'),
                pw.SizedBox(height: 3),
                pw.Text('Patient Name: ${patient['PatientName'] ?? ""}'),
                pw.SizedBox(height: 3),
                pw.Text('Gender: ${patient['Gender'] ?? ""}'),
                pw.SizedBox(height: 3),
                pw.Text('Age: ${patient['AGE'] ?? ""}'),
                pw.SizedBox(height: 3),
                pw.Text('Mobile No: ${patient['MobileNo'] ?? ""}'),
                pw.SizedBox(height: 3),
                pw.Text('Weight: ${patient['Weight'] ?? ""}'),
                pw.SizedBox(height: 16),

                pw.Text(
                  'Diagnosis Details:',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 5),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Doctor Name:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${symptom['DoctorName'] ?? ""}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Symptoms:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${symptom['Title'] ?? ""}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Diagnosis:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${symptom['Diagnosis'] ?? ""}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Test:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${symptom['Test'] ?? ""}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Medicine:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(
                              '${symptom['Medicine']?.join(", ") ?? "No medicines provided"}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Refer:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${symptom['ref'] ?? ""}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('FollowUp:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${symptom['followup'] ?? ""}'),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                            top: 30,
                            left: 5,
                          ),
                          child: pw.Text('Remarks:',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Container(
                          width: 300,
                          height: 80,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                          ),
                          child: pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(
                              '',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (imageBytes != null)
                  pw.Image(
                    pw.MemoryImage(imageBytes),
                    fit: pw.BoxFit.contain,
                    width: 150,
                  ),
              ],
            );
          },
        ),
      );
    }

    // Print or save the generated PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Function to load image from assets
  Future<Uint8List?> _loadImageFromAssets(String path) async {
    try {
      final ByteData data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  // Fetch image from URL and return the bytes
  Future<Uint8List?> _fetchImageBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // hayat form

  // Future<void> generateAndPrintPDF() async {
  //   await loadFonts(); // Ensure fonts are loaded before using them

  //   final patient = widget.patient; // Ensure this is a map with 'PatientName'

  //   final pdf = pw.Document();
  //   final formattedPatientDate =
  //       DateFormat('dd-MM-yyyy').format(patientDateTime.value);

  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) => pw.Padding(
  //         padding: pw.EdgeInsets.all(16),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.SizedBox(height: 30),
  //             pw.Center(
  //               child: pw.Text(
  //                 'हयात प्रमाणपत्र  (Live Certificate)',
  //                 style: pw.TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: pw.FontWeight.bold,
  //                   font: marathiFont, // Fallback font
  //                   // letterSpacing: 1.3,
  //                   height: 1.6,
  //                 ),
  //               ),
  //             ),
  //             pw.SizedBox(height: 50),
  //             buildPdfRow(
  //                 '            असे प्रमाणित करण्यात येते की, Mr/Mrs : ${patient['PatientName'] ?? ""} '
  //                 'राहणार: ${patient['Residence'] ?? ""}, तालुका: वसई, जिल्हा: पालघर, '
  //                 'हे / ह्या _____________________________________________ या योजनेखालील लाभार्थी असून, '
  //                 'हयातीचा पुरावा म्हणून आज दिनांक $formattedPatientDate रोजी माझ्यासमोर प्रत्यक्ष हजर राहिले / राहिल्या.',
  //                 font: marathiFont),

  //             pw.SizedBox(height: 50),
  //             //             // First Row: Place and Signature
  //             pw.Row(
  //               children: [
  //                 pw.Expanded(
  //                   flex: 1, // Left side of the row
  //                   child: pw.Text(
  //                     'स्थळ: ____________',
  //                     style: pw.TextStyle(
  //                       fontSize: 18,
  //                       font: marathiFont,
  //                       letterSpacing: 1.3,
  //                       height: 2.0,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Expanded(
  //                   flex: 1, // Right side of the row
  //                   child: pw.Text(
  //                     'सही: ___________',
  //                     style: pw.TextStyle(
  //                       fontSize: 18,
  //                       font: marathiFont,
  //                       height: 2.0,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             pw.SizedBox(height: 10),

  //             // Second Row: Date and Officer Details
  //             pw.Row(
  //               children: [
  //                 pw.Expanded(
  //                   flex: 1, // Left side of the row
  //                   child: pw.Text(
  //                     'दिनांक: $formattedPatientDate',
  //                     style: pw.TextStyle(
  //                       fontSize: 18,
  //                       font: marathiFont,
  //                       height: 2.0,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Expanded(
  //                   flex: 1, // Right side of the row
  //                   child: pw.Text(
  //                     'तपासणी अधिकाऱ्याने नाव, हुद्दा व कार्यालयाचा शिक्का.',
  //                     style: pw.TextStyle(
  //                       fontSize: 18,
  //                       font: marathiFont,
  //                       height: 2.0,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  // }

  // pw.Widget buildPdfRow(String text, {pw.Font? font}) {
  //   return pw.Padding(
  //     padding: pw.EdgeInsets.symmetric(vertical: 8),
  //     child: pw.Row(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Expanded(
  //           child: pw.Text(
  //             text,
  //             style: pw.TextStyle(
  //               fontSize: 18,
  //               font: font ?? englishFont,
  //               height: 16.0,
  //             ),
  //             textAlign: pw.TextAlign.justify,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //  certificate of Rest
  Future<void> generateAndPrintCertificatePDF() async {
    final patient = widget.patient;
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Center(
                  child: pw.Text("CERTIFICATE OF REST",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 30),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                        // borderRadius: pw.BorderRadius.circular(5),
                      ),
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('LETTER HEAD',
                          style: pw.TextStyle(
                            fontSize: 14,
                          )),
                    ),
                    // pw.Text('LETTER HEAD', style: pw.TextStyle(fontSize: 16)),
                    pw.Text("Date: $formattedDate"),
                  ]),
              pw.SizedBox(height: 20),
              pw.Text(
                "This is to certify that Mr./Mrs./Smt/Ku: ${patient['PatientName']?.toString() ?? "___________"},\n"
                "Age: ${patient['AGE']?.toString() ?? "____"} yrs, was suffering from _________________\n"
                "He/She was advised rest from ________ to ________\n"
                "He/She is fit to resume his/her duties/school from __________________________________________.",
                style: pw.TextStyle(fontSize: 16, height: 1.5),
              ),
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(""),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "Signature    ",
                        style: pw.TextStyle(fontSize: 16, height: 1.5),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Dr. ____________",
                        style: pw.TextStyle(fontSize: 16, height: 1.5),
                      ),
                      pw.Text(
                        "(Rubber Stamp)",
                        style: pw.TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

// certificate of fitness for duty
  Future<void> generateFitnessCertificatePDF() async {
    final patient = widget.patient;
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Center(
                  child: pw.Text("CERTIFICATE OF FITNESS FOR DUTY",
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 30),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                        // borderRadius: pw.BorderRadius.circular(5),
                      ),
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('LETTER HEAD',
                          style: pw.TextStyle(
                            fontSize: 14,
                          )),
                    ),
                    // pw.Text('LETTER HEAD', style: pw.TextStyle(fontSize: 16)),
                    pw.Text("Date: $formattedDate"),
                  ]),
              pw.SizedBox(height: 20),
              pw.Text(
                "This is to certify that Mr./Mrs./Smt/Ku: ${patient['PatientName']?.toString() ?? "___________"},\n"
                "Age: ${patient['AGE']?.toString() ?? "____"} yrs, was suffering from _________________\n"
                "He/She was advised rest from ________ to ________\n"
                "He/She is fit to resume his/her duties/school from __________________________________________.",
                style: pw.TextStyle(fontSize: 16, height: 1.5),
              ),
              pw.SizedBox(height: 50),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Signature of Patient",
                    style: pw.TextStyle(fontSize: 16, height: 1.5),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        "Signature    ",
                        style: pw.TextStyle(fontSize: 16, height: 1.5),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Dr. ____________",
                        style: pw.TextStyle(fontSize: 16, height: 1.5),
                      ),
                      pw.Text(
                        "(Rubber Stamp)",
                        style: pw.TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

// Hayar certificate

  Future<void> generateAndPrintPDF() async {
    final patient = widget.patient; // Ensure this is a map with 'PatientName'

    final pdf = pw.Document();
    final formattedPatientDate =
        DateFormat('dd-MM-yyyy').format(patientDateTime.value);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Padding(
          padding: pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Hayat Pramanpatra (Live Certificate)',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    font: englishFont,
                    letterSpacing: 1.3,
                    height: 1.6,
                  ),
                ),
              ),
              pw.SizedBox(height: 50),

              buildPdfRow(
                  '         It is hereby certified that, Mr/Mrs : ${patient['PatientName']?.toString() ?? ""}. '
                  'Residing at: ${patient['Residence']?.toString() ?? ""}, Taluka: Vasai, District: Palghar, '
                  'is a beneficiary under the ___________________________________. '
                  'Appeared before me today, $formattedPatientDate as proof of life.'),

              pw.SizedBox(height: 50),

              // First Row: Place and Signature
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1, // Left side of the row
                    child: pw.Text(
                      'Place: ____________',
                      style: pw.TextStyle(
                        fontSize: 18,
                        font: englishFont,
                        letterSpacing: 1.3,
                        height: 1.6,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1, // Right side of the row
                    child: pw.Text(
                      'Signature: ___________',
                      style: pw.TextStyle(
                        fontSize: 18,
                        font: englishFont,
                        letterSpacing: 1.3,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Second Row: Date and Officer Details
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1, // Left side of the row
                    child: pw.Text(
                      'Date: $formattedPatientDate',
                      style: pw.TextStyle(
                        fontSize: 18,
                        font: englishFont,
                        letterSpacing: 1.3,
                        height: 1.6,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1, // Right side of the row
                    child: pw.Text(
                      'Name: ______________',
                      style: pw.TextStyle(
                        fontSize: 18,
                        font: englishFont,
                        letterSpacing: 1.3,
                        height: 1.6,
                      ),
                    ),
                  ),
                 
                ],
              ),
 pw.SizedBox(height: 10),
               pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1, // Left side of the row
                    child: pw.Text(
                      '',
                      style: pw.TextStyle(
                        fontSize: 18,
                        font: englishFont,
                        letterSpacing: 1.3,
                        height: 1.6,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1, // Right side of the row
                    child: pw.Text(
                      'Seal: _______________',
                      style: pw.TextStyle(
                        fontSize: 18,
                        font: englishFont,
                        letterSpacing: 1.3,
                        height: 1.6,
                      ),
                    ),
                  ),
                 
                ],
              ),

              // Add Date and Patient's Name in English
              pw.SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget buildPdfRow(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: 18,
                font: englishFont,
                letterSpacing: 1.3,
                height: 1.6,
              ),
              textAlign:
                  pw.TextAlign.justify, // Justify the text for proper alignment
            ),
          ),
        ],
      ),
    );
  }
}