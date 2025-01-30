import 'package:opd_app/RolewiseLogin/DataEntry/views/dataentrybottombar.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/doctorbottombar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';

class RoleLoginController extends GetxController {
  var isLoading = false.obs;
  var userId = ''.obs;
  var userName = ''.obs;
  var email = ''.obs;
  var mobileNo = ''.obs;
  var role = ''.obs;
  var hospitalId = ''.obs;
  var isActive = false.obs;

  var isPasswordVisible = false.obs;
  var password = ''.obs;
  var hospital = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      var url = Uri.parse(
          'https://vvcmhospitals.codifyinstitute.org/api/users/login');

      var response = await https.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['message'] == 'Login successful') {
          var user = jsonResponse['user'];

          userId.value = user['UserId']?.toString() ?? '';
          userName.value = user['UserName']?.toString() ?? '';
          email = user['Email']?.toString() ?? '';
          mobileNo.value = user['MobileNo']?.toString() ?? '';
          role.value = user['Role']?.toString() ?? '';
          hospitalId.value = user['Hospital']?.toString() ?? '';
          isActive.value = user['isActive'] ?? false;

          // Fetch the Hospital name and save it
          hospital.value = user['HospitalName']?.toString() ??
              ''; // Make sure the server returns the hospital name as 'HospitalName'

          _saveUserData();

          if (role.value.toLowerCase() == 'doctor') {
            Get.off(RoleBottomPage(), arguments: {
              'UserId': userId.value,
              'UserName': userName.value,
              'Email': email,
              'MobileNo': mobileNo.value,
              'Role': role.value,
              'HospitalId': hospitalId.value,
              'isActive': isActive.value,
              'Hospital': hospital.value, // Add hospital data in arguments
            });
          } else {
            Get.off(Dataentrybottombar(), arguments: {
              'UserId': userId.value,
              'UserName': userName.value,
              'Email': email,
              'MobileNo': mobileNo.value,
              'Role': role.value,
              'HospitalId': hospitalId.value,
              'isActive': isActive.value,
              'Hospital': hospital.value, // Add hospital data in arguments
            });
          }
        } else {
          print("Login failed: ${jsonResponse['message']}");
          Get.snackbar("Login Failed", jsonResponse['message']);
        }
      } else {
        Get.snackbar("Login Failed", "Invalid credentials");
      }
    } catch (e) {
      print("Error during login: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserId', userId.value);
    await prefs.setString('UserName', userName.value);
    await prefs.setString('Email', email.value);
    await prefs.setString('MobileNo', mobileNo.value);
    await prefs.setString('Role', role.value);
    await prefs.setString('HospitalId', hospitalId.value);
    await prefs.setBool('isActive', isActive.value);
    await prefs.setString('Hospital', hospital.value);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('UserId') ?? '';
    userName.value = prefs.getString('UserName') ?? '';
    email.value = prefs.getString('Email') ?? '';
    mobileNo.value = prefs.getString('MobileNo') ?? '';
    role.value = prefs.getString('Role') ?? '';
    hospitalId.value = prefs.getString('HospitalId') ?? '';
    isActive.value = prefs.getBool('isActive') ?? false;
    hospital.value = prefs.getString('Hospital') ?? '';

    // Navigate based on the user's role if logged in
    if (userId.value.isNotEmpty) {
      if (role.value.toLowerCase() == 'doctor') {
        Get.offAll(RoleBottomPage(), arguments: {
          'UserId': userId.value,
          'UserName': userName.value,
          'Email': email.value,
          'MobileNo': mobileNo.value,
          'Role': role.value,
          'HospitalId': hospitalId.value,
          'isActive': isActive.value,
          'Hospital': hospital.value, // Add hospital data in arguments
        });
      } else {
        Get.offAll(Dataentrybottombar(), arguments: {
          'UserId': userId.value,
          'UserName': userName.value,
          'Email': email.value,
          'MobileNo': mobileNo.value,
          'Role': role.value,
          'HospitalId': hospitalId.value,
          'isActive': isActive.value,
          'Hospital': hospital.value, // Add hospital data in arguments
        });
      }
    }
  }

//   void logout() async {
//     userId.value = '';
//     userName.value = '';
//     email.value = '';
//     mobileNo.value = '';
//     role.value = '';
//     hospitalId.value = '';
//     isActive.value = false;
//     hospital.value = '';

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     Get.offAll(MultiLogin());
//   }
// }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('UserId');

    if (userId != null && userId.isNotEmpty) {
      userId = '';
      userName.value = '';
      email.value = '';
      mobileNo.value = '';
      role.value = '';
      hospitalId.value = '';
      isActive.value = false;
      hospital.value = '';

      await prefs.clear();
    } else {
      Get.snackbar("Not Logged In", "No user is logged in.");
    }
  }

  Future<void> _saveHospitalId(String hospitalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('HospitalId', hospitalId);
  }
}
