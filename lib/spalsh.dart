import 'package:opd_app/controllers/splashcontroller.dart';
import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Spalsh extends StatelessWidget {
  const Spalsh({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Splashcontroller());

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Appcolor.Primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 120, // Adjust the height as needed
              ),
              const SizedBox(height: 20), // Spacing between logo and text
              const Text(
                'VVCMC Patient Management System',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.pure,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
