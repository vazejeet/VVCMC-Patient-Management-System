import 'package:opd_app/RolewiseLogin/controller/roleslogincontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/color.dart';

class RoleLoginPage extends StatelessWidget {
  final RoleLoginController controller = Get.put(RoleLoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          title: const Text(
            'VVCMC Login',
            style: TextStyle(
              color: Appcolor.pure,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Appcolor.Primary,
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: 120),
                // Login card
                Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Obx(
                      () => Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 25),
                            // Email TextFormField
                            TextFormField(
                              onChanged: (value) =>
                                  controller.email.value = value,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 25),
                            // Password TextFormField
                            TextFormField(
                              onChanged: (value) =>
                                  controller.password.value = value,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () =>
                                      controller.isPasswordVisible.toggle(),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 35.0),
                            // Login Button
                            InkWell(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.login(
                                          controller.email.value,
                                          controller.password.value,
                                        );
                                      }
                                    },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: Appcolor.Primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: controller.isLoading.value
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 35.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
