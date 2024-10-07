import 'dart:io';

import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/methods/downloading_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

import '../constant/colors.dart';
import '../constant/icons.dart';
import '../constant/text.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {

  DownloadFunctions downloadFunctions = DownloadFunctions();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: (){
                Get.to(Download());
              },
              icon: Icon(AppIcons.downloadDone,size: h/30,color: AppColor.splashScreen))
        ],
        leading: GestureDetector(onTap: (){
          Get.back();
        },
            child: Icon(Icons.arrow_back_ios_new,color: AppColor.splashScreen,size: h/30,)),
        title: Text('Download Files',style:AppTextStyle.commonText.copyWith(fontSize: h/35),),
      ),
      body: FutureBuilder(
          future:downloadFunctions.getCSVFiles(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.hasError || !snapshot.hasData){
              return Center(child:Text('No files found') ,);
            }
            List<File> csvFile = snapshot.data!;

            return ListView.builder(
              itemCount: csvFile.length,
                itemBuilder: (context,index){
                File file =csvFile[index];
                return Card(
                  color: Colors.white,
                  elevation: 0.5,
                  child:  ListTile(
                    onTap: ()async{
                      await downloadFunctions.openFile(file);
                    },
                    leading: Image.asset(splashImg),
                    title: Text(file.path.split('/').last),
                    subtitle: Text(file.path),
                  ),
                );

                });
          }),
    );
  }
}
