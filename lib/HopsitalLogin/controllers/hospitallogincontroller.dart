import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;
import 'dart:convert';
import '../Views/bottom.dart';
import '../Views/hospitallogin.dart';

class SignInController extends GetxController {
  var isLoading = false.obs;
  var hospitalId = ''.obs; // New observable for HospitalId
  var hospitalName = ''.obs;
  var location = ''.obs;
  var facility = ''.obs;
  var openHours = ''.obs;
  var isPasswordVisible = false.obs; 
  var password = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    _loadHospitalData();
  }

  Future<void> login(String hospitalId, String password) async {
    isLoading(true);
    try {
      var url = Uri.parse('https://vvcmhospitals.codifyinstitute.org/api/hospitals/login');

      var response = await https.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'hospitalId': hospitalId,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['message'] == 'Login successful') {
          var hospital = jsonResponse['hospital'];

          this.hospitalId.value = hospital['HospitalId']; 
          hospitalName.value = hospital['HospitalName'];
          location.value = hospital['Location'];
          facility.value = hospital['Facility'];
          openHours.value = hospital['open_hours'];

          await _saveHospitalData();

          await Future.delayed(Duration(milliseconds: 300)); // Small delay for UI consistency
          
          Get.off(BottomNavPage(), arguments: {
            'HospitalId': hospitalId.toString(), 
            'HospitalName': hospitalName.value,
            'Location': location.value,
            'Facility': facility.value,
            'open_hours': openHours.value,
          });
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

  Future<void> _saveHospitalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('HospitalId', hospitalId.value); 
    await prefs.setString('HospitalName', hospitalName.value);
    await prefs.setString('Location', location.value);
    await prefs.setString('Facility', facility.value);
    await prefs.setString('open_hours', openHours.value);
  }

  Future<void> _loadHospitalData() async {
    final prefs = await SharedPreferences.getInstance();
    hospitalId.value = prefs.getString('HospitalId') ?? ''; 
    hospitalName.value = prefs.getString('HospitalName') ?? '';
    location.value = prefs.getString('Location') ?? '';
    facility.value = prefs.getString('Facility') ?? '';
    openHours.value = prefs.getString('open_hours') ?? '';

    if (hospitalId.value.isNotEmpty) { 
      Get.off(BottomNavPage(), arguments: {
        'HospitalId': hospitalId.value,
        'HospitalName': hospitalName.value,
        'Location': location.value,
        'Facility': facility.value,
        'open_hours': openHours.value,
      });
    }
  }

  void logout() async {
    hospitalId.value = ''; 
    hospitalName.value = '';
    location.value = '';
    facility.value = '';
    openHours.value = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    Get.offAll(Hospitallogin());
  }
}
