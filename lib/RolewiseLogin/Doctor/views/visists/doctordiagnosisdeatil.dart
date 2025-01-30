import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
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

class _PatientDetailPageState extends State<PatientDetailPage> {
  Map<int, bool> selectedDiagnoses = {};

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
                                    'Doctor: ${symptom['DoctorName'] ?? ""}',
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    'Medicine: ${symptom['Medicine']?.join(", ") ?? ""}',
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
                pw.Text('Doctor Name: ${symptom['DoctorName'] ?? ""}'),
                pw.SizedBox(height: 5),
                pw.Text('Symptoms: ${symptom['Title'] ?? ""}'),
                pw.SizedBox(height: 5),
                pw.Text('Diagnosis: ${symptom['Diagnosis'] ?? ""}'),
                pw.SizedBox(height: 5),
                pw.Text('Test: ${symptom['Test'] ?? ""}'),
                pw.SizedBox(height: 5),
                pw.Text(
                    'Medicine: ${symptom['Medicine']?.join(", ") ?? "No medicines provided"}'),
                pw.SizedBox(height: 5),
                pw.Text('Refer: ${symptom['ref'] ?? ""}'),
                pw.SizedBox(height: 5),
                pw.Text('FollowUp: ${symptom['followup'] ?? ""}'),
                pw.SizedBox(height: 20),
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
}
