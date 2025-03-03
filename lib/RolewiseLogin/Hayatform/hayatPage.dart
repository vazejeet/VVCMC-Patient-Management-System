

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class HayatFormController extends GetxController {
//   final nameController = TextEditingController();
//   final addressController = TextEditingController();
//   final talukaController = TextEditingController();
//   final districtController = TextEditingController();
//   final locationController = TextEditingController();
//   var selectedBeneficiary = ''.obs;
//   var selectedDate = DateTime.now().obs;

//   Future<void> pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate.value,
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != selectedDate.value) {
//       selectedDate.value = picked;
//     }
//   }

//   void generateAndPrintPDF() async {
//     final pdf = pw.Document();
//     final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate.value);

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Padding(
//           padding: pw.EdgeInsets.all(16),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
             
//               pw.Center(
//                 child: pw.Text(
//                   'Hayat Pramanpatra (Live Certificate)',
//                   style: pw.TextStyle(
//                     fontSize: 20,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(height: 20),
//               buildPdfField('Name', nameController.text.trim()),
//               buildPdfField('Address', addressController.text.trim()),
//               buildPdfField('Taluka', talukaController.text.trim()),
//               buildPdfField('District', districtController.text.trim()),
//               buildPdfField('Beneficiary Scheme', selectedBeneficiary.value),
//               pw.SizedBox(height: 20),
//               pw.Text(
//                 'This is to certify that the above-mentioned person was present before me on the date: $formattedDate.',
//                 style: pw.TextStyle(fontSize: 16),
//               ),
//               pw.SizedBox(height: 20),
//               buildPdfField('Location', locationController.text.trim()),
//               pw.SizedBox(height: 30),
//               pw.Text(
//                 'Verified by: Name, Designation & Official Seal',
//                 style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }

//   pw.Widget buildPdfField(String label, String value) {
//     return pw.Padding(
//       padding: pw.EdgeInsets.symmetric(vertical: 4),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             label,
//             style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//           ),
//           pw.Text(
//             value.isNotEmpty ? value : 'N/A',
//             style: pw.TextStyle(fontSize: 14),
//           ),
//           pw.Divider(),
//         ],
//       ),
//     );
//   }
// }

// class HayatFormPage extends StatelessWidget {
//   final HayatFormController controller = Get.put(HayatFormController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('परिशिष्ट-१'),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 'हयात प्रमाणपत्र (लाईव्ह सर्टिफिकेट)',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
//               ),
//             ),
//             SizedBox(height: 20),
//             buildFormField('श्री / श्रीमती', controller.nameController),
//             buildFormField('राहणार', controller.addressController),
//             buildFormField('तालुका', controller.talukaController),
//             buildFormField('जिल्हा', controller.districtController),
//             buildDropdownField(),
//             SizedBox(height: 20),
//             Obx(
//               () => ListTile(
//                 title: Text('दिनांक: ${DateFormat('dd-MM-yyyy').format(controller.selectedDate.value)}',
//                     style: TextStyle(fontSize: 16)),
//                 trailing: Icon(Icons.calendar_today, color: Colors.teal),
//                 onTap: () => controller.pickDate(context),
//               ),
//             ),
//             buildFormField('स्थळ', controller.locationController),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (validateFields()) {
//                     controller.generateAndPrintPDF();
//                   } else {
//                     Get.snackbar('Error', 'कृपया सर्व फील्ड भरावीत.');
//                   }
//                 },
//                 child: Text('Generate & Print PDF'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool validateFields() {
//     return controller.nameController.text.isNotEmpty &&
//         controller.addressController.text.isNotEmpty &&
//         controller.talukaController.text.isNotEmpty &&
//         controller.districtController.text.isNotEmpty &&
//         controller.selectedBeneficiary.value.isNotEmpty &&
//         controller.locationController.text.isNotEmpty;
//   }

//   Widget buildFormField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontSize: 16)),
//         SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'कृपया $label भरा'),
//         ),
//         SizedBox(height: 16),
//       ],
//     );
//   }

//   Widget buildDropdownField() {
//     return Obx(
//       () => DropdownButtonFormField<String>(
//         decoration: InputDecoration(border: OutlineInputBorder()),
//         hint: Text('हा / हया योजनेखालील लाभार्थी'),
//         value: controller.selectedBeneficiary.value.isEmpty ? null : controller.selectedBeneficiary.value,
//         items: List.generate(8, (index) => 'Devyang Scheme ${index + 1}')
//             .map((scheme) => DropdownMenuItem(value: scheme, child: Text(scheme)))
//             .toList(),
//         onChanged: (value) => controller.selectedBeneficiary.value = value!,
//       ),
//     );
//   }
// }
