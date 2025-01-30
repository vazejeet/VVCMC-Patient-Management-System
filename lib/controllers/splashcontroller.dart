import 'package:opd_app/RolewiseLogin/views/roleslogin.dart';
import 'package:get/get.dart';

class Splashcontroller extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(
      Duration(seconds: 2),
      () {
        // Get.offAll(MultiLogin());
        Get.offAll(RoleLoginPage());
      },
    );
  }
}
