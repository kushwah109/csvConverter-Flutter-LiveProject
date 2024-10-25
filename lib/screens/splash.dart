import 'dart:async';

import 'package:csv_converter/constant/colors.dart';
import 'package:csv_converter/constant/icons.dart';
import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/constant/text.dart';
import 'package:csv_converter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/splashCustomButton.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppColor.splashScreen,
      body: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          // Applying the gradient here
          gradient: AppColor.myGradient3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/spashimg.png',
              height: h / 5,
            ),
            SizedBox(
              height: h / 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w / 15),
              child: SplashCustomButton(
                  label: 'Convert All Files',
                  iconPath: AppIcons.splashButtonIcon,
                  color: AppColor.uploadBoxColor,
                  onPressed: () {
                    Get.to(() => HomePage(
                          button: 'allFile',
                        ));
                  },
                  textStyle:
                      AppTextStyle.whatsappText.copyWith(fontSize: h / 40)),
            ),
            SizedBox(
              height: h / 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w / 15),
              child: SplashCustomButton(
                  label: 'Convert Doted Files',
                  iconPath: AppIcons.splashButtonIcon,
                  color: AppColor.uploadBoxColor,
                  onPressed: () {
                    print('doted button press');
                    Get.to(() => HomePage(
                          button: 'dotedFile',
                        ));
                  },
                  textStyle:
                      AppTextStyle.whatsappText.copyWith(fontSize: h / 38)),
            ),
          ],
        ),
      ),
    );
  }
}
