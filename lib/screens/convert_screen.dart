import 'dart:io';
import 'package:csv_converter/constant/colors.dart';
import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/constant/text.dart';
import 'package:csv_converter/methods/csv_converter.dart';
import 'package:csv_converter/methods/downloading_function.dart';
import 'package:csv_converter/methods/file_extension.dart';
import 'package:csv_converter/methods/sharing_platform_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/custom_button.dart';
import '../constant/icons.dart';
import '../methods/pickers.dart';
import 'download.dart';
import 'package:pdf/widgets.dart'as pw;


class ConvertScreen extends StatefulWidget {
  final File? imageFile;
  final File? driveFile;
  final File? scanPdf;
  const ConvertScreen({super.key, this.imageFile, this.driveFile,  this.scanPdf,  });

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
  File? selectedFile;
  String filePath="";
  PickerMethods pickerMethods=PickerMethods();
  FileExtension fileExtension = FileExtension();
  DownloadFunctions downloadFunctions = DownloadFunctions();
  SharingFileFunction sharingFileFunction = SharingFileFunction();
ApiService apiService = ApiService();
String? downloadLink ;
  bool isConverting = false;
  bool isDownload = false;
  String convertedFilePath = '';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.imageFile != null){
      selectedFile = widget.imageFile;
      filePath = selectedFile!.path;
      print('Image File selected: $filePath');

    }else if(widget.driveFile != null){
      selectedFile = widget.driveFile;
      filePath = selectedFile!.path;
      print('Drive File selected: $filePath');

    }else if(widget.scanPdf != null){
      selectedFile = widget.scanPdf;
      filePath = selectedFile!.path;
      print('Scan File selected: $filePath');

    }
    validateFileType();
  }

  void validateFileType() {
    if (selectedFile != null) {
      // Extract file extension
      String filePath = selectedFile!.path;
      String fileExtension = filePath.split('.').last.toLowerCase();

      // Log the extracted file extension
      print('Selected file type: $fileExtension');

      // Check if the file type is supported
      if (  fileExtension == 'pdf'||fileExtension == 'png' ||  fileExtension == 'jpeg' || fileExtension == 'jpg') {
        print('File type is valid: $fileExtension');
        showValidDialog();
        // Proceed with the upload and conversion
        // uploadAndConvert();
      } else {
        showInvalidFileDialog();
        print('Invalid file type: $fileExtension');
        print('Unsupported file type. Please select a CSV, TXT, or PDF file.');
        // Handle invalid file type (e.g., show an error message to the user)
        // showError('Unsupported file type. Please select a CSV, TXT, or PDF file.');
      }
    } else {
      print('No file selected');
    }
  }


  Future<void> uploadAndConvert()async{
    print('upload step1');
    if (selectedFile == null ||selectedFile!.path.isEmpty) {
      print('No file selected or conversion is already in progress.');
      return;
    }
    print(selectedFile);
      setState(() {
        print('upload step2');
        isConverting = true;
        progressNotifier.value = 0.1;
      });
      try{
        print('Selected file path: ${selectedFile!.path}');

        print('upload step3');
        for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(Duration(milliseconds: 300)); // Simulate work
      progressNotifier.value = i / 100; // Update progress
      // print('upload step4');
      // print('progres $i');
      }
      downloadLink = await apiService.uploadFile(selectedFile!);
        // print('dowloadlink $downloadLink');
        if(downloadLink != null && downloadLink!.isNotEmpty){
          print('File uploaded successfully. Download link: $downloadLink');
          setState(()  {
            progressNotifier.value = 1.0;
          });
          // Circular progress for file processing
          await Future.delayed(Duration(seconds: 2));
        }else{
          print('upload step6');
          setState(() {
            progressNotifier.value = 0.0;

          });
        }
        }catch(e){
        print('Error uploading file: $e');
        setState(() {
          progressNotifier.value = 0.0;

        });
      }finally{
        setState(() {
          print('upload step7');
          isConverting = false;
        });
      }

  }

  // Future<void> convertingToCSV() async {
  //   setState(() {
  //     print('true');
  //     isConverting = true;
  //   });
  //   print('converting once');
  //   convertedFilePath = await converter.convertToCSV(selectedFile!,progressNotifier);
  //   setState(() {
  //     print(false);
  //     isConverting = false;
  //   });
  //   // You can add logic to show a download option for the converted file here
  //   print('once');
  //
  // }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: h/15,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              Get.to(Download());
            },
            icon: Icon(AppIcons.download,size: h/30,color: AppColor.splashScreen))
        ],
        leading: GestureDetector(onTap: (){
          Get.back();
        },
            child: Icon(Icons.arrow_back_ios_new,color: AppColor.splashScreen,size: h/30,)),
        title: Text('Csv Convert',style:AppTextStyle.commonText.copyWith(fontSize: h/35),),
      ),
      body: SingleChildScrollView(
        child: Column(
         children: [
           SizedBox(height: h/20,),
           // Show selected image or placeholder
           // Show img on convertscreen directly
           selectedFile != null
               ? Padding(
                 padding: EdgeInsets.symmetric(horizontal: h/50),
                 child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   fileExtension.getFileIcon(fileExtension.getFileExtension(filePath), h / 20),
                       SizedBox(width: w / 80),
                       Flexible(
                         child: Text(
                           filePath,overflow: TextOverflow.visible,maxLines: 3,
                           style: TextStyle(fontSize: h / 60, color: Colors.black),
                         ),
                       ),  // Display file name
                 ],
                              ),
               )
               : Text("No image or file selected", style: TextStyle(fontSize: h / 35)),

           SizedBox(height: h/20,),

           SizedBox(
             height: h/16,
             width: w/1.2,
             child: ElevatedButton(
                 style:AppButtonStyle.buttonStyle,
                 onPressed: isConverting || downloadLink !=null ? null : ()async{
                   print('if loop start');
                     setState(() {
                       print('again true');
                       isConverting = true; // Set to true when conversion starts
                     });

                     // Start the conversion process and pass the progressNotifier
                     print('call upload');
                     await uploadAndConvert();
                     //
                     // setState(() {
                     //   print('false again');
                     //   isConverting = false; // Set to false when conversion ends
                     // });
                   Get.to(()=>ConvertScreen());
                 }, child: Padding(
               padding:  EdgeInsets.symmetric(horizontal: w/20,vertical: w/90),
               child: Text('Convert',style: AppTextStyle.homeButton.copyWith(fontSize: h/35),),
             )),
           ),
           SizedBox(height: h/20,),

           //progress Indicator
           ValueListenableBuilder(
               valueListenable: progressNotifier,
               builder: (context,progress,child){
                 print('process lister');
                 if(isConverting && progress == 1.0){
                   return CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(AppColor.progressColor),
                   );
                 }else if(isConverting){
                    return Padding(
                   padding:  EdgeInsets.symmetric(horizontal: w/20),
                       child: Column(
                         children: [
                       LinearProgressIndicator(
                         minHeight: h/40,
                         borderRadius: BorderRadius.all(Radius.circular(10)),
                         value:progress,
                         valueColor: AlwaysStoppedAnimation<Color>(AppColor.progressColor),
                       ),
                       SizedBox(height: 10,),
                       Text('${(progress * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: h / 60)),
                         ],
                       ),
                     );
                         }else if(downloadLink != null && downloadLink!.isNotEmpty){
                    return Padding(
                       padding: EdgeInsets.symmetric(horizontal: h/50),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Image.asset(splashImg,height: h/12,),

                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               TextButton(
                                   // style:AppButtonStyle.buttonStyle,
                                   onPressed: ()async{
                                     if(downloadLink!.isNotEmpty){
                                       print('downlaod start');
                                        String downloadPath = await downloadFunctions.downloadCSV(downloadLink?? 'default Link');
                                       if (downloadPath.isNotEmpty) {
                                         print('Download successful at: $downloadPath');
                                       } else {
                                         print('Download failed or path is empty');
                                       }
                                     }
                                     else{
                                       print('invalid data');
                                     }
                                     // String csvFile = await convertedFilePath;
                                     //  await downloadFunctions.downloadCSV(convertedFilePath);
                                     print('download success');

                                   }, child: Text('Download',style: AppTextStyle.downloadTextButton.copyWith(fontSize: h/60),)),
                             ],
                           ),
                           SizedBox(height: h/20,),
                           SizedBox(
                             // height: h/10,
                             width: double.infinity,
                             child: Column(
                               children: [
                                 Text('Share With',
                                   style: AppTextStyle.commonText.copyWith(fontSize: h / 40),),
                                 SizedBox(height: h / 30,),
                                 CustomButton(
                                   label: 'Share',
                                   color: AppColor.whatsappColor,
                                   onPressed: () async {
                                     print('whatsapp button ');
                                         print('Sharing as a local file...');

                                     // Check if the file is being downloaded
                                     if (downloadFunctions.isDownloading) {
                                       Get.snackbar(
                                         'Alert',
                                         'File is currently downloading. Please wait until the download is complete.',
                                         snackPosition: SnackPosition.TOP,
                                         duration: Duration(seconds: 3),
                                       );
                                       return; // Exit if the file is currently downloading
                                     }

                                     // Check if the file has already been downloaded
                                     String? downloadPath = downloadFunctions.downloadedFilePath;

                                     if (downloadPath == null || downloadPath.isEmpty) {
                                       // If no file is downloaded, download it
                                       String downloadedFilePath = await downloadFunctions.downloadCSV(downloadLink!);

                                       // After downloading, check if the path is valid
                                       if (downloadedFilePath.isNotEmpty) {
                                         downloadFunctions.downloadedFilePath = downloadedFilePath; // Update the path
                                         await sharingFileFunction.shareFileDirectly(downloadedFilePath); // Share the file
                                       } else {
                                         Get.snackbar(
                                           'Error',
                                           'Failed to download the file.',
                                           snackPosition: SnackPosition.TOP,
                                           duration: Duration(seconds: 3),
                                         );
                                       }
                                     } else {
                                       // If already downloaded, share it directly
                                       print('File already downloaded. Sharing the file...');
                                       await sharingFileFunction.shareFileDirectly(downloadPath);

                                       // Show a snackbar message after sharing
                                       Get.snackbar(
                                         'File Shared',
                                         'The file was successfully shared.',
                                         snackPosition: SnackPosition.TOP,
                                         duration: Duration(seconds: 3),
                                       );
                                     }
                                     // // Check if the file is being downloaded
                                     //     if(downloadFunctions.isDownloading){
                                     //         String downloadedFilePath = await downloadFunctions.downloadCSV(downloadLink!);
                                     //         // Once the file is downloaded, share it
                                     //         if(downloadFunctions.downloadedFilePath!.isNotEmpty){
                                     //           // Update downloadedFilePath after successful download
                                     //           downloadFunctions.downloadedFilePath = downloadedFilePath;
                                     //           await sharingFileFunction.shareFileDirectly(downloadedFilePath);
                                     //           //sharingFileFunction.resetUI();
                                     //         }else{
                                     //           Get.snackbar(
                                     //             'Error',
                                     //             'Failed to download the file.', snackPosition: SnackPosition.TOP,
                                     //             duration: Duration(seconds: 3),
                                     //           );
                                     //         }
                                     //     }else{
                                     //       // Check if the file is already downloaded
                                     //       String? downloadPath = downloadFunctions.downloadedFilePath;
                                     //       if(downloadPath == null || downloadPath.isEmpty){
                                     //         Get.snackbar('Alert', 'Please download the file before sharing.');
                                     //         // String downlaodFile= await downloadFunctions.downloadCSV(downloadLink!);
                                     //         // await sharingFileFunction.shareFileDirectly(downlaodFile);
                                     //         //sharingFileFunction.resetUI();
                                     //       }else {
                                     //         // File already downloaded, share it directly
                                     //         print('File already downloaded. Sharing the file...');
                                     //         await sharingFileFunction.shareFileDirectly(downloadPath);
                                     //
                                     //         // Show a snackbar message after sharing
                                     //         Get.snackbar(
                                     //           'File Shared',
                                     //           'The file was successfully shared.',
                                     //
                                     //         );
                                     //       }
                                     //
                                     //     }

                                   },
                                   iconPath: AppIcons.share,
                                   textStyle: AppTextStyle.whatsappText.copyWith(fontSize: h / 50),),

                                 // Row(
                                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 //   children: [
                                 //     CustomButton(
                                 //       label: 'Whatsapp',
                                 //       color: AppColor.whatsappColor,
                                 //       onPressed: () async{
                                 //         print('whatsapp button ');
                                 //         String downloadLink = await apiService.uploadFile(selectedFile!);
                                 //         print('downlaodlink $downloadLink');
                                 //         String filePath = await downloadFunctions.downloadCSV(downloadLink);
                                 //         print('filepath $filePath');
                                 //         // sharingFileFunction.shareViaWhatsapp(filePath: filePath);
                                 //
                                 //         if (filePath.isNotEmpty) {
                                 //           sharingFileFunction.shareFileDirectly( filePath: filePath);
                                 //         }
                                 //
                                 //
                                 //       },
                                 //       iconPath: whatsapp,
                                 //       textStyle: AppTextStyle.whatsappText.copyWith(fontSize: h / 50),),
                                 //     CustomButton(
                                 //       label: 'Email',
                                 //       color: AppColor.mailColor,
                                 //       onPressed: () async{
                                 //         print('start email');
                                 //
                                 //         String downloadLink = await apiService.uploadFile(selectedFile!);
                                 //         String filePath = await downloadFunctions.downloadCSV(downloadLink);
                                 //         sharingFileFunction.shareFileDirectly( filePath: filePath,);
                                 //
                                 //
                                 //
                                 //       },
                                 //       iconPath: email,
                                 //       textStyle: AppTextStyle.mailText.copyWith(fontSize: h / 40),)
                                 //   ],
                                 // )

                               ],
                             )
                           ),
                         ],
                       ),
                     );
                 }
                     return SizedBox.shrink();
               }
               ),
         ],
        ),
      ),
    );
  }

  void showInvalidFileDialog() {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context){
    //       return AlertDialog(
    //         title: Text('Invalid File'),
    //       );
    //     });
  }

  void showValidDialog() {
    // showDialog(
    //     context: context,
    //     builder: (_)=>AlertDialog());
  }
}



