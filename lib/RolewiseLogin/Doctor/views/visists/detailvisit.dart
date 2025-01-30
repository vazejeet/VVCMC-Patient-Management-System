import 'package:opd_app/RolewiseLogin/DataEntry/controllers/patients/patientscontroller.dart';
import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Dianosispage/doctordiangosisi.dart';

class visitsdetails extends StatelessWidget {
  final Patient patient;

  const visitsdetails({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(patient.createdBy);
    } catch (e) {
      dateTime = DateTime.now(); // Default or error handling
    }
    String formattedDate =
        DateFormat('yyyy-MM-dd - kk:mm').format(dateTime.toLocal());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: Text(
            patient.patientName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Appcolor.pure,
            ),
          ),
          centerTitle: true,
          backgroundColor: Appcolor.Primary,
          elevation: 2,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blueGrey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Appcolor.pure,
                  // color: Appcolor.Primary.withOpacity(0.9),
                  elevation: 5,

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
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
                            _buildTableRow(
                                'Application ID:', patient.ApplicationID),
                            _buildTableRow('Created By:', patient.createdBy),

                            _buildTableRow('Hospital Name:',
                                patient.hospitalName), // Added Hospital Name
                            _buildTableRow('Doctor Name:',
                                patient.doctorName), // Added Hospital Name
                            _buildTableRow('Age:', patient.age),
                            _buildTableRow('Weight:', patient.weight),
                            _buildTableRow('Gender:', patient.gender),
                            if (patient.caste != "")
                              _buildTableRow('Caste:', patient.caste),
                            if (patient.idCard != "")
                              _buildTableRow('ID Card No:', patient.idCard),

                            _buildTableRow(
                                'Mobile:', patient.mobileNo.toString()),
                            if (patient.emailId != "")
                              _buildTableRow('Email:', patient.emailId),
                            _buildTableRow('Residence:', patient.residence),
                            _buildTableRow('Created At:', formattedDate),
                            if (patient.symptoms.isNotEmpty)
                              _buildSymptomRow(patient.symptoms),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Diagnose Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => DiagnosisByDoctorPage(
                                    ApplicationID: patient.ApplicationID,
                                    patientName: patient.patientName,
                                    mobileNo: patient.mobileNo.toString(),
                                    weight: patient.weight,
                                    gender: patient.gender,
                                    formattedDate: formattedDate,
                                    age: patient.age,
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Appcolor.Primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text(
                              'Diagnose Patient',
                              style: TextStyle(color: Appcolor.pure),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildSymptomRow(List<Symptom> symptoms) {
    final latestSymptom = symptoms
        .where((symptom) => symptom.dateTime != null)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (latestSymptom.isNotEmpty) {
      final latest = latestSymptom.first; // The most recent symptom
      return _buildTableRow("Symptoms:", latest.title);
    } else {
      return _buildTableRow("Symptoms:", "No symptoms available");
    }
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Appcolor.Primary,
            ),
          ),
        ),
      ],
    );
  }
}
