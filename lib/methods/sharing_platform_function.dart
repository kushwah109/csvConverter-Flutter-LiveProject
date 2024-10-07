
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SharingFileFunction{

  // Future<void> shareViaWhatsapp({required File file})async{
  //   print('start');
  //   // final Uri whatsappUrl = Uri.parse('https://flutter.dev');
  //   final Uri whatsappUrl = Uri.parse('whatsapp://send?text='Csv file');
  //   try{
  //     // await Share.shareXFiles([XFile(file.path)]);
  //     print('Sharing file...');
  //     if(await canLaunchUrl(whatsappUrl)) {
  //       print('Launching WhatsApp...');
  //       await launchUrl(whatsappUrl);
  //       print('sucessfully');
  //     }else{
  //       print('WhatsApp URL cannot be launched.');
  //       throw 'Could not launch whatsapp ';
  //     }
  //   }catch(e){
  //     print('Error sharing via WhatsApp: $e');
  //
  //   }
  //
  // }
  Future<void> shareCSV(String filePath )async {
    Share.shareXFiles([XFile(filePath)]);
  }


  Future<void> shareViaWhatsapp({required String downloadLink})async{
    print('start');
    final Uri whatsappUrl = Uri.parse('whatsapp://send?text=Download%20your%20file%20from%20this%20link:%20$downloadLink');
    try{
      if(await canLaunchUrl(whatsappUrl)) {
              print('Launching WhatsApp...');
              await launchUrl(whatsappUrl);
              print('sucessfully');
            }else{
              print('WhatsApp URL cannot be launched.');
              throw 'Could not launch whatsapp ';
            }
    }catch(e){
      print('Error sharing via WhatsApp: $e');

    }

  }



  Future<void> shareViaEmail({required String emailAddress,required String downloadLink})async{
    final Uri emailUrl = Uri.parse('mailto:$emailAddress?subject=Sharing Csv file&body=Find the attached file');
    try{
      // await Share.shareXFiles([XFile(file.path)]);
      if(await canLaunchUrl(emailUrl)){
        await launchUrl(emailUrl);
      } else {
        throw 'Could not launch Email';
      }
    }catch(e){
      print('Error sharing via Email: $e');

    }
  }
}
