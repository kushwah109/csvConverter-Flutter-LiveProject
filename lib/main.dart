import 'package:csv_converter/methods/pickers.dart';
import 'package:csv_converter/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PickerMethods pickerMethods = PickerMethods();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pickerMethods.requestStoragePermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
