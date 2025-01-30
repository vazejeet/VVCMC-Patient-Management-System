import 'package:opd_app/RolewiseLogin/views/roleslogin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/color.dart';
import '../../controller/roleslogincontroller.dart';

class RoleProfilePage extends StatelessWidget {
  final RoleLoginController controller = Get.put(RoleLoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'Profile of Data Entry',
            style: TextStyle(color: Appcolor.pure),
          ),
          backgroundColor: Appcolor.Primary,
        ),
        body: Container(
          color: Appcolor.pure,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          elevation: 4,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            color: Appcolor.pure,
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
                                SizedBox(height: 16),
                                _buildInfoField(
                                  title: 'User ID:',
                                  value: controller.userId.value.isNotEmpty
                                      ? controller.userId.value
                                      : 'N/A',
                                ),
                                SizedBox(height: 16),
                                _buildInfoField(
                                  title: 'User Name:',
                                  value: controller.userName.value.isNotEmpty
                                      ? controller.userName.value
                                      : 'N/A',
                                ),
                                SizedBox(height: 16),
                                _buildInfoField(
                                  title: 'Email:',
                                  value: controller.email.value.isNotEmpty
                                      ? controller.email.value
                                      : 'N/A',
                                ),
                                SizedBox(height: 16),
                                _buildInfoField(
                                  title: 'Mobile No:',
                                  value: controller.mobileNo.value.isNotEmpty
                                      ? controller.mobileNo.value
                                      : 'N/A',
                                ),
                                SizedBox(height: 16),
                                _buildInfoField(
                                  title: 'Role:',
                                  value: controller.role.value.isNotEmpty
                                      ? controller.role.value
                                      : 'N/A',
                                ),
                                SizedBox(height: 16),
                                // Update here to show the hospital name
                                _buildInfoField(
                                  title: 'Hospital:',
                                  value: controller.hospital.value.isNotEmpty
                                      ? controller.hospital.value
                                      : 'N/A',
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                _buildInfoField(
                                  title: 'HospitalId:',
                                  value: controller.hospitalId.value.isNotEmpty
                                      ? controller.hospitalId.value
                                      : 'N/A',
                                ),
                                SizedBox(height: 16),
                                _buildInfoField(
                                  title: 'Active Status:',
                                  value: controller.isActive.value
                                      ? 'Active'
                                      : 'Inactive',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            controller.logout();
                            Get.offAll(RoleLoginPage());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 50, right: 40),
                            padding: EdgeInsets.symmetric(vertical: 15),
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
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Appcolor.Primary),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
