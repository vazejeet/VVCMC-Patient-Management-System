import 'package:opd_app/RolewiseLogin/Doctor/views/doctorbottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../utils/color.dart';
import '../../../controller/roleslogincontroller.dart';
import '../../controllers/Diagnosiscontrollers.dart';

class DiagnosisByDoctorPage extends StatelessWidget {
  final String weight;
  final String patientName;
  final String age;
  final String gender;
  final String mobileNo;
  final String ApplicationID;
  final String formattedDate;
  final DiagnosisController diagnosisController =
      Get.put(DiagnosisController());

  final TextEditingController remarksController = TextEditingController();

  DiagnosisByDoctorPage({
    Key? key,
    required this.patientName,
    required this.weight,
    required this.age,
    required this.mobileNo,
    required this.gender,
    required this.ApplicationID,
    required this.formattedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RoleLoginController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            "Diagnosis Details",
            style: TextStyle(color: Appcolor.pure),
          ),
          centerTitle: true,
          backgroundColor: Appcolor.Primary,
        ),
        body: Obx(() => diagnosisController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter Diagnosis Information",
                    style: TextStyle(
                      color: Appcolor.Primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildPatientInfoTable(),
                  const SizedBox(height: 10),
                  // _buildTextField(
                  //     "Hospital ID", diagnosisController.hospitalIdController,
                  //     isEditable: false),
                  // const SizedBox(height: 05),
                  // _buildTextField("Hospital Name",
                  //     diagnosisController.hospitalNameController,
                  //     isEditable: false),
                  // const SizedBox(height: 05),
                  // _buildTextField(
                  //     "Doctor Name", diagnosisController.doctorNameController,
                  //     isEditable: false),
                  // const SizedBox(height: 20),
                  _buildDropdownField(
                    label: "Symptoms",
                    items: diagnosisController.symptoms,
                    selectedValues: diagnosisController.selectedSymptoms,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    label: "Test",
                    items: diagnosisController.tests,
                    selectedValues: diagnosisController.selectedTests,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    label: "Diagnosis",
                    items: diagnosisController.diagnosis,
                    selectedValues: diagnosisController.selectedDiagnosis,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    label: "Medicine",
                    items: diagnosisController.medicine,
                    selectedValues: diagnosisController.selectedMedicine,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Refer",
                    diagnosisController.refController,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Follow Up",
                    diagnosisController.followUpController,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.save, color: Appcolor.pure),
                      label: const Text(
                        "Submit Diagnosis",
                        style: TextStyle(color: Appcolor.pure),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.Primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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

  Future<void> _handleSubmit() async {
    if (!_validateFields()) {
      Get.snackbar("Error", "Please fill all required fields.",
          backgroundColor: Colors.red);

      return;
    }

    final diagnosisData = {
      "Title": diagnosisController.selectedSymptoms.join(', '),
      "Test": diagnosisController.selectedTests.join(', '),
      "HospitalName": diagnosisController.hospitalNameController.text,
      "CreatedBy": diagnosisController.hospitalIdController.text,
      "DoctorName": diagnosisController.doctorNameController.text,
      "Diagnosis": diagnosisController.selectedDiagnosis.join(', '),
      "Medicine": diagnosisController.selectedMedicine.join(', '),
      "ref": diagnosisController.refController.text,
      "followup": diagnosisController.followUpController.text,
      "Remarks": remarksController.text,
    };

    try {
      await diagnosisController.diagnosePatient(ApplicationID, diagnosisData);
      await _generatePdf(diagnosisData);
      Get.offAll(RoleBottomPage());
    } catch (e) {
      Get.snackbar("Error", "Failed to submit diagnosis",
          backgroundColor: Colors.red);
    }
  }

  bool _validateFields() {
    return diagnosisController.selectedSymptoms.isNotEmpty &&
        diagnosisController.doctorNameController.text.isNotEmpty &&
        diagnosisController.hospitalNameController.text.isNotEmpty &&
        diagnosisController.hospitalIdController.text.isNotEmpty &&
        diagnosisController.selectedDiagnosis.isNotEmpty &&
        diagnosisController.selectedMedicine.isNotEmpty;
  }

  Widget _buildPatientInfoTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      border: const TableBorder(
        horizontalInside: BorderSide(
          color: Appcolor.Secondary,
          width: 1.5,
        ),
      ),
      children: [
        _buildTableRow('Patient Name:', patientName),
        _buildTableRow('Age:', age),
        _buildTableRow('Weight:', weight),
        _buildTableRow('Gender:', gender),
        _buildTableRow('DateTime:', formattedDate),
        // _buildTableRow('Patient ID:', ApplicationID),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required RxList<String> selectedValues,
  }) {
    return Obx(() {
      return GestureDetector(
        onTap: () => _showDropdown(Get.context!, label, items, selectedValues),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Appcolor.Primary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedValues.isNotEmpty ? selectedValues.join(', ') : label,
                  style: TextStyle(
                    color:
                        selectedValues.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Appcolor.Primary),
            ],
          ),
        ),
      );
    });
  }

  void _showDropdown(BuildContext context, String label, List<String> items,
      RxList<String> selectedValues) {
    final searchController = TextEditingController();
    final othersController = TextEditingController();
    var filteredItems = items.obs;
    var showOthersField = false.obs;

    void arrangeItems() {
      List<String> nonSelectedItems =
          items.where((item) => !selectedValues.contains(item)).toList();
      List<String> arrangedSelectedItems = List<String>.from(selectedValues);
      filteredItems.value = arrangedSelectedItems + nonSelectedItems;
    }

    arrangeItems();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select $label'),
            contentPadding: const EdgeInsets.all(16.0),
            content: SizedBox(
              height: 400,
              width: double.maxFinite,
              child: Column(
                children: [
                  if (!showOthersField.value) ...[
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          arrangeItems();
                        } else {
                          filteredItems.value = items
                              .where((item) => item
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                  Expanded(
                    child: Obx(() => ListView.builder(
                          itemCount: filteredItems.length +
                              (showOthersField.value ? 1 : 2),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return ListTile(
                                title: const Text("Others"),
                                trailing: showOthersField.value
                                    ? const Icon(Icons.edit,
                                        color: Appcolor.Primary)
                                    : const Icon(Icons.edit),
                                onTap: () => setState(
                                    () => showOthersField.value = true),
                              );
                            }

                            if (showOthersField.value && index == 1) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextField(
                                  controller: othersController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter custom value',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              );
                            }

                            if (index == (showOthersField.value ? 2 : 1)) {
                              return ListTile(
                                title: const Text("None"),
                                trailing: selectedValues.contains("None")
                                    ? const Icon(Icons.check_box,
                                        color: Appcolor.Primary)
                                    : const Icon(Icons.check_box_outline_blank),
                                onTap: () {
                                  setState(() {
                                    selectedValues.clear();
                                    selectedValues.add("None");
                                  });
                                },
                              );
                            }

                            final itemIndex =
                                index - (showOthersField.value ? 3 : 2);
                            if (itemIndex >= 0 &&
                                itemIndex < filteredItems.length) {
                              final item = filteredItems[itemIndex];
                              return ListTile(
                                title: Text(item),
                                trailing: selectedValues.contains(item)
                                    ? const Icon(Icons.check_box,
                                        color: Appcolor.Primary)
                                    : const Icon(Icons.check_box_outline_blank),
                                onTap: () {
                                  setState(() {
                                    if (selectedValues.contains("None")) {
                                      selectedValues.remove("None");
                                    }
                                    if (selectedValues.contains(item)) {
                                      selectedValues.remove(item);
                                    } else {
                                      selectedValues.add(item);
                                    }
                                    arrangeItems();
                                  });
                                },
                              );
                            }
                            return null;
                          },
                        )),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  selectedValues.clear();
                  arrangeItems();
                  setState(() {});
                },
                child:
                    const Text('Clear', style: TextStyle(color: Colors.orange)),
              ),
              TextButton(
                onPressed: () {
                  if (showOthersField.value &&
                      othersController.text.isNotEmpty) {
                    if (!selectedValues.contains("None") &&
                        !selectedValues.contains(othersController.text)) {
                      selectedValues.add(othersController.text);
                    }
                  }
                  Get.back();
                },
                child: const Text('Done',
                    style: TextStyle(color: Appcolor.Primary)),
              ),
            ],
          );
        },
      ),
    );
  }
  // Widget _buildDropdownField({
  //   required String label,
  //   required List<String> items,
  //   required RxList<String> selectedValues,
  // }) {
  //   return Obx(() {
  //     return GestureDetector(
  //       onTap: () => _showDropdown(Get.context!, label, items, selectedValues),
  //       child: Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: Appcolor.Primary),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Flexible(
  //               child: Text(
  //                 selectedValues.isNotEmpty ? selectedValues.join(', ') : label,
  //                 style: TextStyle(
  //                   color:
  //                       selectedValues.isNotEmpty ? Colors.black : Colors.grey,
  //                 ),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //             const Icon(Icons.arrow_drop_down, color: Appcolor.Primary),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  // void _showDropdown(BuildContext context, String label, List<String> items,
  //     RxList<String> selectedValues) {
  //   final searchController = TextEditingController();
  //   final othersController = TextEditingController();
  //   var filteredItems = items.obs;
  //   var showOthersField = false.obs;

  //   if (!items.contains("None")) {
  //     items.insert(0, "None");
  //   }

  //   void arrangeItems() {
  //     List<String> nonSelectedItems =
  //         items.where((item) => !selectedValues.contains(item)).toList();
  //     List<String> arrangedSelectedItems = List<String>.from(selectedValues);
  //     filteredItems.value = arrangedSelectedItems + nonSelectedItems;
  //   }

  //   arrangeItems();

  //   Get.dialog(
  //     StatefulBuilder(
  //       builder: (context, setState) {
  //         return AlertDialog(
  //           title: Text('Select $label'),
  //           contentPadding: const EdgeInsets.all(16.0),
  //           content: SizedBox(
  //             height: 300,
  //             width: double.maxFinite,
  //             child: Column(
  //               children: [
  //                 if (!showOthersField.value) ...[
  //                   TextField(
  //                     controller: searchController,
  //                     decoration: InputDecoration(
  //                       labelText: 'Search',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     onChanged: (value) {
  //                       if (value.isEmpty) {
  //                         arrangeItems();
  //                       } else {
  //                         filteredItems.value = items
  //                             .where((item) => item
  //                                 .toLowerCase()
  //                                 .contains(value.toLowerCase()))
  //                             .toList();
  //                       }
  //                     },
  //                   ),
  //                   const SizedBox(height: 10),
  //                 ],
  //                 Expanded(
  //                   child: Obx(() => ListView.builder(
  //                         itemCount: filteredItems.length +
  //                             (showOthersField.value ? 1 : 2),
  //                         itemBuilder: (context, index) {
  //                           if (index == 0) {
  //                             return ListTile(
  //                               title: const Text("None"),
  //                               trailing: selectedValues.contains("None")
  //                                   ? const Icon(Icons.check_box,
  //                                       color: Appcolor.Primary)
  //                                   : const Icon(Icons.check_box_outline_blank),
  //                               onTap: () {
  //                                 setState(() {
  //                                   if (selectedValues.contains("None")) {
  //                                     selectedValues.remove("None");
  //                                   } else {
  //                                     selectedValues.clear();
  //                                     selectedValues.add("None");
  //                                   }
  //                                   arrangeItems();
  //                                 });
  //                               },
  //                             );
  //                           }

  //                           if (!showOthersField.value && index == 1) {
  //                             return ListTile(
  //                               title: const Text("Others"),
  //                               trailing: const Icon(Icons.edit),
  //                               onTap: () => setState(
  //                                   () => showOthersField.value = true),
  //                             );
  //                           }

  //                           if (showOthersField.value && index == 1) {
  //                             return Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 8.0),
  //                               child: TextField(
  //                                 controller: othersController,
  //                                 decoration: const InputDecoration(
  //                                   labelText: 'Enter custom value',
  //                                   border: OutlineInputBorder(),
  //                                 ),
  //                               ),
  //                             );
  //                           }

  //                           final itemIndex =
  //                               index - (showOthersField.value ? 2 : 1);
  //                           if (itemIndex >= 0 &&
  //                               itemIndex < filteredItems.length) {
  //                             final item = filteredItems[itemIndex];
  //                             return ListTile(
  //                               title: Text(item),
  //                               trailing: selectedValues.contains(item)
  //                                   ? const Icon(Icons.check_box,
  //                                       color: Appcolor.Primary)
  //                                   : const Icon(Icons.check_box_outline_blank),
  //                               onTap: () {
  //                                 setState(() {
  //                                   if (selectedValues.contains("None")) {
  //                                     selectedValues.remove("None");
  //                                   }
  //                                   if (selectedValues.contains(item)) {
  //                                     selectedValues.remove(item);
  //                                   } else {
  //                                     selectedValues.add(item);
  //                                   }
  //                                   arrangeItems();
  //                                 });
  //                               },
  //                             );
  //                           }
  //                           return null;
  //                         },
  //                       )),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 selectedValues.clear();
  //                 arrangeItems();
  //                 setState(() {});
  //               },
  //               child:
  //                   const Text('Clear', style: TextStyle(color: Colors.orange)),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 if (showOthersField.value &&
  //                     othersController.text.isNotEmpty) {
  //                   selectedValues.add(othersController.text);
  //                 }
  //                 Get.back();
  //               },
  //               child: const Text('Done',
  //                   style: TextStyle(color: Appcolor.Primary)),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        enabled: isEditable,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolor.Primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolor.Primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Appcolor.Primary),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  Future<void> _generatePdf(Map<String, Object> diagnosisData) async {
    final pdf = pw.Document();
    final ByteData bytes = await rootBundle.load('assets/logo.png');
    final logoImage = pw.MemoryImage(bytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Image(logoImage, width: 100),
                    pw.SizedBox(width: 20),
                    pw.Text(
                      'VVCMC ${diagnosisData['HospitalName'] ?? ""}',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Diagnosis Report',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Date: $formattedDate',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.normal),
                    ),
                  ],
                ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FractionColumnWidth(0.3),
                    1: const pw.FractionColumnWidth(0.7),
                  },
                  children: [
                    _buildPdfTableRow('Patient Name:', patientName),
                    _buildPdfTableRow('Gender:', gender),
                    _buildPdfTableRow('Age:', age),
                    _buildPdfTableRow('Weight:', weight),
                    _buildPdfTableRow('Patient ID:', ApplicationID),
                    _buildPdfTableRow('Hospital Name:',
                        diagnosisData["HospitalName"]?.toString() ?? ""),
                    _buildPdfTableRow(
                        'Symptoms:', diagnosisData["Title"]?.toString() ?? ""),
                    _buildPdfTableRow(
                        'Test:', diagnosisData["Test"]?.toString() ?? ""),
                    _buildPdfTableRow('Doctor Name:',
                        diagnosisData["DoctorName"]?.toString() ?? ""),
                    _buildPdfTableRow('Diagnosis:',
                        diagnosisData["Diagnosis"]?.toString() ?? ""),
                    _buildPdfTableRow('Medicine:',
                        diagnosisData["Medicine"]?.toString() ?? ""),
                    _buildPdfTableRow(
                        'Refer:', diagnosisData["ref"]?.toString() ?? ""),
                    _buildPdfTableRow('Follow Up:',
                        diagnosisData["followup"]?.toString() ?? ""),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Remarks:',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Container(
                  height: 130,
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.TableRow _buildPdfTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value),
        ),
      ],
    );
  }
}
