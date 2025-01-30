import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../controllers/hospitallogincontroller.dart';

class Hospitallogin extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Image.asset("assets/logo.png"),
          backgroundColor: Appcolor.Primary,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              SizedBox(width: 20),
              Text(
                'VVCMC Hospital',
                style: TextStyle(
                  fontSize: 24,
                  color: Appcolor.pure,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          toolbarHeight: 65,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 120),
                // Login card
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Obx(() => Column(
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Hospital ID TextFormField
                        TextFormField(
                          onChanged: (value) => controller.hospitalName.value = value,
                          decoration: InputDecoration(
                            hintText: 'Hospital ID',
                            prefixIcon: const Icon(Icons.local_hospital),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Password TextFormField
                        TextFormField(
                          onChanged: (value) => controller.password.value = value,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              ),
                              onPressed: () => controller.isPasswordVisible.toggle(),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35.0),
                        // Login Button
                        InkWell(
                          onTap: controller.isLoading.value
                            ? null
                            : () => controller.login(
                                controller.hospitalName.value,
                                controller.password.value,
                              ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Appcolor.Primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                ? const CircularProgressIndicator(color: Colors.white)
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
                        const SizedBox(height: 35.0),
                      ],
                    )),
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