
import 'dart:io';
import 'package:csv_converter/methods/downloading_function.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:share_plus/share_plus.dart';


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

  // If you have any UI elements related to file or conversion, reset them here
  // For example:
  //  selectedFile = null;
   //conversionStatus = 'Awaiting conversion...';

  // Trigger UI update by using setState if necessary in your widget
  // setState(() {
  //   // reset any UI state here
  // });
}

  // Future<void> shareViaWhatsapp({required String filePath})async{
  //   print('start');
  //   final Uri whatsappUrl = Uri.parse('whatsapp://send?text=Download%20your%20file%20from%20this%20link:%20$filePath');
  //   try{
  //
  //     if(await canLaunchUrl(whatsappUrl)) {
  //             print('Launching WhatsApp...');
  //             await launchUrl(whatsappUrl);
  //             print('sucessfully');
  //           }else{
  //             print('WhatsApp URL cannot be launched.');
  //             throw 'Could not launch whatsapp ';
  //           }
  //   }catch(e){
  //     print('Error sharing via WhatsApp: $e');
  //
  //   }
  //
  // }



  // Future<void> shareViaEmail({required String emailAddress,required String downloadLink})async{
  //   final Uri emailUrl = Uri.parse('mailto:$emailAddress?subject=Sharing Csv file&body=Find the attached file');
  //   try{
  //     // await Share.shareXFiles([XFile(file.path)]);
  //     if(await canLaunchUrl(emailUrl)){
  //       await launchUrl(emailUrl);
  //     } else {
  //       throw 'Could not launch Email';
  //     }
  //   }catch(e){
  //     print('Error sharing via Email: $e');
  //
  //   }
  // }
}
