import 'package:opd_app/RolewiseLogin/Doctor/views/Dashboard/Dashboarddoctor.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/Doctorupdatereport/Updatelist.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/visists/docorlist.dart';
import 'package:get/get.dart';

import '../views/doctorprofile.dart';
import '../views/visists/visit.dart';

class RoleBottomController extends GetxController {
  // The index of the current selected tab
  var currentIndex = 0.obs;

  // List of pages for each tab
  final pages = [
    DashboardPage(),
    visit(),
    PatientListPage(),
    UpdateList(),
    RoleProfilePage(),
  ];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
