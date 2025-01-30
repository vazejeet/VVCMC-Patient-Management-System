import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'RolewiseLogin/views/roleslogin.dart';

class MultiLogin extends StatelessWidget {
  const MultiLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'VVCMC Patient Management System',
            style: TextStyle(
              color: Appcolor.pure,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Appcolor.Primary,
        ),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/bg.jpg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            // Foreground content
            Center(
              child: RoleCard(
                title: 'Role login',
                icon: Icons.local_hospital,
                onTap: () {
                  Get.offAll(() => RoleLoginPage());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const RoleCard({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Appcolor.Primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 200, // Adjust width
          height: 200, // Adjust height
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Appcolor.Primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.Primary,
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
