import 'dart:io';
import 'package:csv_converter/methods/sharing_platform_function.dart';
import 'package:http/http.dart' as http;
import 'package:csv_converter/methods/pickers.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

PickerMethods pickerMethods = PickerMethods();
SharingFileFunction sharingFileFunction = SharingFileFunction();

class DownloadFunctions {
  bool isDownloading = false;

// To store the downloaded file path
  String? downloadedFilePath;

  Future<String> downloadCSV(String downloadLink) async {
    if (isDownloading || downloadedFilePath != null) {
      return downloadedFilePath ?? '';
    }
    isDownloading = true;
    try {
      print('downloadLink from downloadCSV $downloadLink');
      await pickerMethods.requestStoragePermission();

      print('download start');
      // Save the CSV file in a user-friendly location (Documents or Downloads)
      Directory? mobileDirectory;
      // for android download folder
      if (Platform.isAndroid) {
        mobileDirectory = Directory('/storage/emulated/0/Download');

        //for ios download folder
      } else if (Platform.isIOS) {
        mobileDirectory = await getApplicationDocumentsDirectory();
      }

      // Ensure the directory exists

      if (mobileDirectory!.existsSync()) {
        mobileDirectory.createSync(recursive: true);
      }
      // Generate a unique file name for the CSV file

      String uniqueTimestamp =
          DateTime.now().toIso8601String().replaceAll(':', '-');
      String csvFileName =
          'ConvertedFile_$uniqueTimestamp.csv'; // Unique file name
      // Ensure the directory exists
      String downloadDir = '${mobileDirectory.path}/$csvFileName';
      print(' download directory $downloadDir');

      //save file
      File file = File(downloadDir);
      await file.writeAsString(downloadLink);
      downloadedFilePath = downloadDir;

      Get.snackbar(
        'Download Complete',
        'CSV file saved to: $downloadDir',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

      return downloadDir;
    } catch (e) {
      print('error of download $e');
      Get.snackbar('Error', 'Failed to download CSV: $e',
          snackPosition: SnackPosition.TOP, duration: Duration(seconds: 3));
      return '';
    } finally {
      isDownloading = false;
    }
  } // Return the path of the downloaded file

  Future<void> openFileLocation(String directoryPath) async {
    if (Platform.isAndroid) {
      try {
        final result = await OpenFilex.open(directoryPath);
        if (result.type != ResultType.done) {
          Get.snackbar('Error', 'Could not open the file location');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to open file location: $e');
      }
    } else if (Platform.isIOS) {
      final Uri uri = Uri.parse(directoryPath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Could not open the file location');
      }
    } else {
      Get.snackbar('Error',
          'Opening file location is only supported on Android for now');
    }
  }

  // function to get file in download screen
  Future<List<File>> getCSVFiles() async {
    print('getcsvfile');

    Directory? mobileDownload;
    // for android download folder
    if (Platform.isAndroid) {
      mobileDownload = Directory('/storage/emulated/0/Download');

      //for ios download folder
    } else if (Platform.isIOS) {
      mobileDownload = await getApplicationDocumentsDirectory();
    }

    // List all file in the directory
    List<FileSystemEntity> files = mobileDownload!.listSync();
    List<File> csvFiles = files
        .where((file) => file.path.endsWith('.csv'))
        .map((file) => File(file.path))
        .toList();
    print(csvFiles);
    return csvFiles;
  }

  Future<void> openFile(File file) async {
    print('openFile function start ');
    await pickerMethods.requestStoragePermission();
    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      final filePath = file.path;
      if (await file.exists()) {
        await OpenFilex.open(filePath);
      } else {
        Get.snackbar('Error', 'File does not exist');
      }
    } else {
      Get.snackbar('Permission Denied',
          'Cannot open the file without storage permission');
      openAppSettings();
    }
  }
}
