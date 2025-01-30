import 'package:opd_app/HopsitalLogin/Views/hospitallogin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/color.dart';
import '../controllers/hospitallogincontroller.dart';

class ProfilePage1 extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          backgroundColor: Appcolor.Primary,
          title: const Text(
            'Hospital Profile',
            style: TextStyle(
              fontSize: 24,
              color: Appcolor.pure,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Appcolor.Primary.withOpacity(0.8),
                      Appcolor.Secondary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                elevation: 4,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        Appcolor.Primary.withOpacity(0.8),
                                        Appcolor.Secondary.withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 110,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Appcolor.Secondary,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: const CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Appcolor.Primary,
                                            child: Icon(Icons.person,
                                                color: Colors.white, size: 50),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildInfoField('Hospital ID:',
                                          controller.hospitalId),
                                      const SizedBox(height: 16),
                                      _buildInfoField('Hospital Name:',
                                          controller.hospitalName),
                                      const SizedBox(height: 16),
                                      _buildInfoField(
                                          'Location:', controller.location),
                                      const SizedBox(height: 16),
                                      _buildInfoField(
                                          'Facility:', controller.facility),
                                      const SizedBox(height: 16),
                                      _buildInfoField(
                                          'Open Hours:', controller.openHours),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  controller.logout();
                                  Get.offAll(Hospitallogin());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 50, right: 40),
                                  width: 200,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Appcolor.Primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
      ),
    );
  }

  Widget _buildInfoField(String title, RxString value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(() => Text(
                value.isNotEmpty ? value.value : 'N/A',
                style: const TextStyle(fontSize: 16, color: Appcolor.pure),
                textAlign: TextAlign.end,
              )),
        ),
      ],
    );
  }
}
