
import 'package:get/get.dart';
import '../views/Dashboard/dashboard.dart';
import '../views/dataentryprofile.dart';
import '../views/patients/list.dart';

class RoleBottomController extends GetxController {
  // The index of the current selected tab
  var currentIndex = 0.obs;

  // List of pages for each tab
  final pages = [
    DashboardPage(),
    PatientScreen(),
    RoleProfilePage(),
  ];


  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}


