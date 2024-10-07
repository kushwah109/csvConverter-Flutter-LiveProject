import 'dart:async';

import 'package:csv_converter/constant/colors.dart';
import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),(){
      Get.to(HomePage());
    });

  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.splashScreen,
      body: Center(child: Image.asset(splashImg,height: h/5,)),
    );
  }
}
