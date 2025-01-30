import 'package:opd_app/HopsitalLogin/Views/list.dart';
import 'package:opd_app/HopsitalLogin/Views/profile.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/visists/docorlist.dart';
import 'package:get/get.dart';

import '../Views/DashboarPage.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    DashboarPage(),
    PatientScreen(),
    PatientListPage(),
    ProfilePage1()
  ];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
