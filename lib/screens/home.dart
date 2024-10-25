import 'package:csv_converter/constant/colors.dart';
import 'package:csv_converter/constant/icons.dart';
import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/constant/text.dart';
import 'package:csv_converter/methods/pickers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'download.dart';

class HomePage extends StatefulWidget {
  final String button;

  const HomePage({super.key, required this.button});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickerMethods pickerMethods = PickerMethods();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: h / 15,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(Download());
              },
              icon: Icon(AppIcons.download,
                  size: h / 30, color: AppColor.splashScreen))
        ],
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.splashScreen,
              size: h / 30,
            )),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: h/20,),
              Image.asset(
                homeimg,
                height: h / 6,
              ),

              Text(
                'Choose an option',
                style: AppTextStyle.convert.copyWith(fontSize: h / 30),
              ),
              SizedBox(
                height: h / 60,
              ),

              GestureDetector(
                onTap: () async {
                  print('image sucesse');
                  await pickerMethods.pickImageFromCamera(widget.button);
                },
                //Create card for clicking img from camera
                child: Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: h / 40, vertical: h / 60),
                  color: AppColor.uploadBoxColor,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: [8, 6],
                    radius: Radius.circular(12),
                    padding: EdgeInsets.all(h / 16),
                    color: Colors.grey.shade500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppIcons.uploadIcon,
                            SizedBox(
                              width: w / 60,
                            ),
                            Text(
                              'Upload a images',
                              style: TextStyle(
                                  fontSize: h / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(fontSize: h / 50),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // selected img from file
              GestureDetector(
                onTap: () async {
                  print('File success load');
                  await pickerMethods.pickFileFromDrive(widget.button);
                },
                child: Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: h / 40, vertical: h / 60),
                  color: AppColor.uploadBoxColor,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: [8, 6],
                    radius: Radius.circular(12),
                    padding: EdgeInsets.all(h / 16),
                    color: Colors.grey.shade500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppIcons.uploadIcon,
                            SizedBox(
                              width: w / 60,
                            ),
                            Text(
                              'Upload a file',
                              style: TextStyle(
                                  fontSize: h / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          'Drive',
                          style: TextStyle(fontSize: h / 50),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // scan doc and create pdf
              GestureDetector(
                onTap: () async {
                  print('scan success load');
                  await pickerMethods.scanDoc(widget.button);
                  // await pickerMethods.docScanner();
                },
                child: Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: h / 40, vertical: h / 60),
                  color: AppColor.uploadBoxColor,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    dashPattern: [8, 6],
                    radius: Radius.circular(12),
                    padding: EdgeInsets.all(h / 16),
                    color: Colors.grey.shade500,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppIcons.uploadIcon,
                            SizedBox(
                              width: w / 60,
                            ),
                            Text(
                              'Scan Doc',
                              style: TextStyle(
                                  fontSize: h / 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          'Scan Document Create PDF',
                          style: TextStyle(fontSize: h / 50),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
