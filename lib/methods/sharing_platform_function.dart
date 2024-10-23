
import 'dart:io';
import 'package:csv_converter/methods/downloading_function.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:share_plus/share_plus.dart';

import '../screens/home.dart';


DownloadFunctions downloadFunctions = DownloadFunctions();
class SharingFileFunction{
  Future<void> shareFileDirectly(String filePath) async {
    try{
      print('share function start');

      final file = File(filePath);
      if(await file.exists()){
        print('file exist');
        // Share the file directly as an attachment

        await Share.shareXFiles([XFile(filePath)],text: 'Check out this file');
       }

    }catch(e){
      print('Error sharing file: $e');
      Get.snackbar('Error', 'Failed to share file: $e',
          snackPosition: SnackPosition.TOP);    }

  }


//function for reset ui after sharing file same as before conversion
void resetUI() {
  print('Resetting UI to initial state...');
  // Reset the file path or any variables that store the conversion status
  downloadFunctions.downloadedFilePath = null;
  downloadFunctions.isDownloading = false;

  Get.offAll(()=>HomePage(button: '',));
}


}
