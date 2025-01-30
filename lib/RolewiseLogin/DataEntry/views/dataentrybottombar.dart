import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/color.dart';
import '../controllers/dataentrycontroller.dart';
import 'package:flutter/services.dart'; // Import for handling back button

class Dataentrybottombar extends StatelessWidget {
  final RoleBottomController controller = Get.put(RoleBottomController());

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Intercept the back button to show confirmation dialog
        return await _showExitDialog(context);
      },
      child: Scaffold(
        body: Obx(() => controller.pages[controller.currentIndex.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changeTabIndex(index),
            backgroundColor: Appcolor.Primary,
            fixedColor: Appcolor.pure,
            unselectedItemColor: Appcolor.pure,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Appcolor.Primary,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: 'Patients',
                backgroundColor: Appcolor.Primary,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
                backgroundColor: Appcolor.Primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a confirmation dialog when back button is pressed
  Future<bool> _showExitDialog(BuildContext context) async {
    // Using Get.defaultDialog to show the exit confirmation dialog
    return await Get.defaultDialog<bool>(
      title: 'Are you sure?',
      middleText: 'Do you really want to exit?',
      barrierDismissible: false, // Don't allow dismissing the dialog by tapping outside
      actions: <Widget>[
        TextButton(
          child: Text('No'),
          onPressed: () {
            Get.back(result: false); // Don't exit
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            SystemNavigator.pop(); // Exit the app
          },
        ),
      ],
    ) ?? false; // If no result, return false by default
  }
}
