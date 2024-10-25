import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../screens/convert_screen.dart';

class PickerMethods {
  File? selectedImg;

// method of clickimg from camera
  Future<void> pickImageFromCamera(String button) async {
    final XFile? returnedImg =
        await ImagePicker().pickImage(source: ImageSource.camera);
    print(returnedImg);
    if (returnedImg != null) {
      selectedImg = File(returnedImg.path);
      print('Selected image path: ${selectedImg!.path}');
      Get.to(() => ConvertScreen(
            filePath: selectedImg,
            button: button,
          ));
    } else {
      print('no image select');
    }
  }

  File? selectedFile;

// method of select file from drive
  Future<void> pickFileFromDrive(String button) async {
    FilePickerResult? returnFile = await FilePicker.platform.pickFiles();
    print(returnFile);
    if (returnFile != null) {
      selectedFile = File(returnFile.files.single.path!);
      print('Selected file path: ${selectedFile!.path}');
      Get.to(() => ConvertScreen(
            filePath: selectedFile,
            button: button,
          ));
    } else {
      print('no file select');
    }
  }

  // create function for scan doc from img document

  // File? scannedDoc;
  // Future<File?> docScanner()async{
  //   try{
  //     final XFile? pickedScanImg = await ImagePicker().pickImage(source: ImageSource.camera,
  //         preferredCameraDevice:CameraDevice.rear, // use rear camera
  //         imageQuality: 85); // img quality
  //
  //     if(pickedScanImg != null){
  //       return File(pickedScanImg.path); //return file of scan doc
  //     }else {
  //       print('No document was scanned.');
  //       return null;
  //     }
  //   }catch(e){
  //     print('Error scanning document: $e');
  //     return null;
  //   }
  //
  // }

  //scan doc by flutter_doc_scanner
  List<File> scannedListDocuments = [];

  //method for scan doc
  Future<void> scanDoc(String button) async {
    print('firstStep');
    try {
      print('scan doc');
      final Map<dynamic, dynamic>? scannedDocument =
          await FlutterDocScanner().getScanDocuments();
      print('Scanned document: $scannedDocument');
      if (scannedDocument != null && scannedDocument.containsKey('pdfUri')) {
        String? pdfUri = scannedDocument['pdfUri'];
        if (pdfUri != null) {
          String filePath = Uri.parse(pdfUri).toFilePath();
          File scannedFile = File(filePath);
          print('scanned doc File : $scannedFile');
          scannedListDocuments.add(scannedFile);
          print('scanned doc added: ${scannedFile.path}');
          await savePdfAndNavigate(scannedFile, button);
          // await convertListImgToPDF();
        }
        // if(scannedDocument != null){
        //   print('scan file add');
        //     scannedListDocuments.add(scannedDocument);
        //     print('Scanned document added: ${scannedDocument.path}');
        //     await convertListImgToPDF();
      } else {
        print('No document scanned');
      }
    } catch (e) {
      print('Error scanning document: $e');
      return null;
    }
  }

  //function for handle permission of storage
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        print('Storage permission granted');
      } else {
        Get.snackbar('Permission Denied',
            'Storage permission is required for this feature.');
        if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    } else if (status.isPermanentlyDenied) {
      Get.snackbar('Permission Denied',
          'Please enable storage permission from settings.');
      openAppSettings();
    }
  }

  //method to convert scan documents in pdf
  Future<void> savePdfAndNavigate(File pdfFile, String button) async {
    try {
      await requestStoragePermission();
      // Optionally, move the PDF to a permanent storage location
      // Ask user for the desired file name

      String? newFileName = await showDialog<String>(
          context: Get.context!,
          builder: (context) {
            String fileName = 'scanned_document.pdf';
            return AlertDialog(
              title: Text('Enter File Name'),
              content: TextField(
                onChanged: (value) {
                  fileName =
                      value.isEmpty ? 'scanned_document.pdf' : value + '.pdf';
                },
                decoration: InputDecoration(hintText: 'File Name'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back(result: fileName);
                  },
                  child: Text('Save'),
                )
              ],
            );
          });
      if (newFileName != null) {
        // Directory? directory = await getExternalStorageDirectory();
        String? directory = await FilePicker.platform.getDirectoryPath();

        if (directory != null) {
          final String externalPath = path.join(directory, newFileName);
          // Copy the PDF to the new location

          final File savedPdfFile = await pdfFile.copy(externalPath);

          print('PDF saved at ${savedPdfFile.path}');

          // Navigate to the ConvertScreen and pass the PDF file
          Get.to(() => ConvertScreen(
                filePath: savedPdfFile,
                button: button,
              ));
        }
      }
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }
//   Future<String?> convertListImgToPDF() async{
//     print('converting start into pdf');
//     if(scannedListDocuments.isEmpty){
//       print('no doc to convert to PDF');
//       return null;
//     }
//
//     try{
//       print('steps2');
//       final pdf = pw.Document();
//       for(var imageFile in scannedListDocuments){
//         print('loop work');
//         final image = pw.MemoryImage(File(imageFile.path).readAsBytesSync());
//         print('add page');
//         pdf.addPage(pw.Page(
//             build: ( pw.Context context){
//               return pw.Center(
//                 child: pw.Image(image),
//               );
//         }));
//       }
//
//        //Get the directory to save the PDF
// print('save file');
//       final outputDir = await getApplicationDocumentsDirectory();
//       print('pdfFile');
//       final pdfFile = File('${outputDir.path}/scanned_documents.pdf');
//       print(pdfFile);
//       //write the pdf document to the file
//
//      await pdfFile.writeAsBytes(await pdf.save());
//       print('PDF saved at ${pdfFile.path}');
//       Get.to(()=>ConvertScreen(scanPdf:pdfFile ,));
//       return pdfFile.path;
//     }catch(e){
//       print('Error converting images to PDF: $e');
//       return null;
//     }
//   }
}
