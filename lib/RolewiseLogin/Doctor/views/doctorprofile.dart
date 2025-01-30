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
            'Doctor Profile',
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
                        const SizedBox(height: 20),
                        _buildProfileCard(),
                        const SizedBox(height: 20),
                        _buildLogoutButton(),
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

  Widget _buildProfileCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15.0),
        //   gradient: LinearGradient(
        //     colors: [
        //       Appcolor.Primary.withOpacity(0.8),
        //       Appcolor.Secondary.withOpacity(0.8),
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        color: Appcolor.pure,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 16),
            _buildInfoField(
              title: 'User ID:',
              value: controller.userId.value.isNotEmpty
                  ? controller.userId.value
                  : 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              title: 'User Name:',
              value: controller.userName.value.isNotEmpty
                  ? controller.userName.value
                  : 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              title: 'Email:',
              value: controller.email.value.isNotEmpty
                  ? controller.email.value
                  : 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              title: 'Mobile No:',
              value: controller.mobileNo.value.isNotEmpty
                  ? controller.mobileNo.value
                  : 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              title: 'Role:',
              value: controller.role.value.isNotEmpty
                  ? controller.role.value
                  : 'N/A',
            ),
            const SizedBox(height: 16),
            _buildHospitalField(),
            SizedBox(
              height: 16,
            ),
            _buildInfoField(
              title: 'HospitalId:',
              value: controller.hospitalId.value.isNotEmpty
                  ? controller.hospitalId.value
                  : 'N/A',
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              title: 'Active Status:',
              value: controller.isActive.value ? 'Active' : 'Inactive',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
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
          child: Icon(Icons.person, color: Colors.white, size: 50),
        ),
      ),
    );
  }

  Widget _buildHospitalField() {
    return Obx(() {
      // Check if the hospital name is loaded in the controller
      String hospitalName = controller.hospital.value.isNotEmpty
          ? controller.hospital.value
          : 'N/A';

      return _buildInfoField(
        title: 'Hospital:',
        value: hospitalName,
      );
    });
  }

  Widget _buildInfoField({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
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

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () {
        controller.logout();
        Get.offAll(() => RoleLoginPage());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
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
    );
  }
}
