import 'package:opd_app/RolewiseLogin/DataEntry/controllers/patients/patientAdd.dart';
import 'package:opd_app/RolewiseLogin/DataEntry/views/TabBar/PatientAddTwo.dart';
import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class PatientTabPage extends StatelessWidget {
  final TabControllerX controllerX = Get.put(TabControllerX());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Appcolor.Primary, // Background color for the tab bar
              child: TabBar(
                controller: controllerX.tabController,
                labelColor: Appcolor.pure,
                unselectedLabelColor: Appcolor.pure,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'New Patient'),
                  Tab(text: ' Already Registered'),
                ],
              ),
            ),
            // TabBarView to display content
            Expanded(
              child: TabBarView(
                controller: controllerX.tabController,
                physics:
                    NeverScrollableScrollPhysics(), // Disable swipe functionality

                children: [
                  PatientForm(),
                  PatientAddTwo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
