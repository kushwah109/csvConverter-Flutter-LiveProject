import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:csv_converter/methods/pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


PickerMethods pickerMethods=PickerMethods();
class DownloadFunctions{

  Future<String> downloadCSV(String downloadLink) async{

    try{

      print('downloadLink from downloadCSV $downloadLink');
        await pickerMethods.requestStoragePermission();
        // String? newFileName = await showDialog<String>(
        //     context: Get.context!,
        //     builder: (context){
        //       String fileName = '.csv';
        //       return AlertDialog(
        //         title: Text('Enter File Name'),
        //         content: TextField(
        //           onChanged: (value){
        //             fileName = value.isEmpty?'converted_file.csv': value;
        //           },
        //           decoration: InputDecoration(hintText: 'File Name.csv'),
        //         ),
        //         actions: [
        //           TextButton(
        //             onPressed: (){
        //               Get.back(result: fileName);
        //             },
        //             child: Text('Save'),)
        //         ],
        //       );
        //     });

        // If no file name is entered, provide a default name
        // newFileName = newFileName ?? 'converted_file';

        print('download start');
        // Save the CSV file in a user-friendly location (Documents or Downloads)
        Directory? mobileDirectory;
        // for android download folder
        if(Platform.isAndroid) {
          mobileDirectory= Directory('/storage/emulated/0/Download');

          //for ios download folder
        }
        else if(Platform.isIOS){
          mobileDirectory = await getApplicationDocumentsDirectory();
        }

        // Directory? mobileDirectory = await getExternalStorageDirectory(); // Save to Documents folder

        // Ensure the directory exists

        if (mobileDirectory!.existsSync()) {
          mobileDirectory.createSync(recursive: true);

        }
      // Generate a unique file name for the CSV file
      String uniqueTimestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      String csvFileName = 'ConvertedFile_$uniqueTimestamp.csv'; // Unique file name
      // Ensure the directory exists
      String downloadDir = '${mobileDirectory.path}/$csvFileName';
      print(' download directory $downloadDir');
      // Directory downloadDir = Directory('${mobileDirectory.path}/$csvFileName');

        //save file
        File file = File(downloadDir);
        await file.writeAsString(downloadLink);
        Get.snackbar('Download Complete', 'CSV file saved to: $csvFileName',
            snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 5),
        mainButton: TextButton(onPressed: ()async{
          print('open location');
          await openFileLocation(mobileDirectory!.path);
          print(' location of file ${mobileDirectory.path}');
        }, child: Text('show Location')));
        return csvFileName;
      // }else {
      //   throw Exception('Failed to download file');
      // }
    }catch(e){
      print('error of download $e');
      Get.snackbar('Error', 'Failed to download CSV: $e', snackPosition: SnackPosition.TOP,duration: Duration(seconds: 5));
      return '';
    }

    } // Return the path of the downloaded file




  Future<void> openFileLocation(String directoryPath)async{

    if(Platform.isAndroid){
      final Uri uri = Uri.parse('file://$directoryPath');

      // final Uri uri = Uri.file(directoryPath);
      if(await canLaunchUrl(uri)){
        await launchUrl(uri);
      }else{
        Get.snackbar('Error', 'Could not open the file location');
      }
    }
    // else if (Platform.isIOS){
    //   final Uri uri = Uri.parse(directoryPath);
    //   if(await canLaunchUrl(uri)){
    //     await launchUrl(uri);
    //   }else{
    //     Get.snackbar('Error', 'Could not open the file location');
    //   }
    // }
    else {
      Get.snackbar('Error', 'Opening file location is only supported on Android for now');
    }
  }



  // function to get file in download screen
  Future<List<File>> getCSVFiles()async{
    print('getcsvfile');
    Directory? mobileDownload = Directory('/storage/emulated/0/Download');

    // Directory mobileDownload = await Directory('/storage/emulated/0/Downloads');

    // List all file in the directory
    List<FileSystemEntity> files = mobileDownload.listSync();
    List<File> csvFiles =  files
        .where((file)=>file.path.endsWith('.csv'))
        .map((file)=>File(file.path))
        .toList();
    print(csvFiles);
    return csvFiles;
   }




   Future<void> openFile(File file)async{
    print('openFile function start ');
    await pickerMethods.requestStoragePermission();
    if(await Permission.storage.isGranted  || await Permission.manageExternalStorage.isGranted) {
      final filePath = file.path;
      if (await file.exists()) {
         await OpenFile.open(filePath);
        // if (result.message != 'success') {
        //   Get.snackbar('Error', 'Could not open the file: ${result.message}');
        //   print(result.message);
        // }
      } else {
        Get.snackbar('Error', 'File does not exist');
      }
    }else{
      Get.snackbar('Permission Denied', 'Cannot open the file without storage permission');
      openAppSettings();
    }
   }
}
