
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../Dianosispage/doctordiangosisi.dart';
import 'Imageoplad.dart';

class DoctorDiagnosisTabBarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabbarController;

  @override
  void onInit() {
    super.onInit();
    tabbarController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabbarController.dispose();
    super.onClose();
  }
}

class PatientTabPagess extends StatelessWidget {
  final String ApplicationID;
  final String patientName;
  final String mobileNo;
  final String gender;
  final String age;
  final String weight;
  final String formattedDate;

  // Constructor updated with new parameter
  PatientTabPagess({
    required this.ApplicationID,
    required this.patientName,
    required this.mobileNo,
    required this.gender,
    required this.age,
    required this.formattedDate,
    required this.weight,
  });

  final DoctorDiagnosisTabBarController _tabBarController =
      Get.put(DoctorDiagnosisTabBarController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // TabBar directly in the body
            Container(
              color: Appcolor.Primary,
              child: TabBar(
                controller: _tabBarController.tabbarController,
                labelColor: Appcolor.pure,
                unselectedLabelColor: Appcolor.pure,
                tabs: const [
                  Tab(text: 'Diagnosis'),
                  Tab(
                    text: 'Diagnosis by Image',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabBarController.tabbarController,
                physics: NeverScrollableScrollPhysics(),  // Disable swipe functionality
                children: [
                  // Pass all parameters to DiagnosisByDoctorPage
                  DiagnosisByDoctorPage(
                    ApplicationID: ApplicationID,
                    patientName: patientName,
                    mobileNo: mobileNo, 
                    gender: gender,
                    age: age,
                    weight: weight,
                    formattedDate:formattedDate,
                  ),
                  // Pass all parameters to ImageUploadPage
                  // ImageUploadPage(
                  //   ApplicationID: ApplicationID,
                  //   patientName: patientName,
                  //   mobileNo: mobileNo,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

