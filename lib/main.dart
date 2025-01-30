import 'package:opd_app/HopsitalLogin/Views/DashboarPage.dart';
import 'package:opd_app/RolewiseLogin/DataEntry/views/Dashboard/dashboard.dart';
import 'package:opd_app/RolewiseLogin/Doctor/views/Doctorupdatereport/updatecontroller.dart';
import 'package:opd_app/spalsh.dart';
import 'package:opd_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'RolewiseLogin/Doctor/views/Dashboard/Dashboarddoctor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorWidgetClass(details));
  };
  Get.put(UpdateListController());
  Get.put(DashboardController());
  Get.put(DashboardControlleer());
  Get.put(DashboardControllers());
  runApp(const MyApp());
}

class ErrorWidgetClass extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorWidgetClass(this.errorDetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(10),
            height: 300,
            width: 300,
            color: Colors.red,
            child: Center(
              child: Text(
                "An unexpected error occurred.\nPlease restart the app.\n\nError Details:\n${errorDetails.exception}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Appcolor.pure),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Spalsh(),
    );
  }
}
