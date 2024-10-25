import 'dart:io';
import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/methods/downloading_function.dart';
import 'package:csv_converter/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
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
  List<File> selectedFiles = [];
  List<File> csvFiles = [];
  bool showOptions = false;
  Future<List<File>>? futureCsvFiles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCsvFiles();
  }

  void loadCsvFiles() async {
    final files = await downloadFunctions.getCSVFiles();
    setState(() {
      csvFiles = files;
      futureCsvFiles = Future.value(csvFiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final h = MediaQuery.of(context).size.height;
    // final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(Download());
              },
              icon: Icon(AppIcons.downloadDone,
                  size: h / 30, color: AppColor.splashScreen))
        ],
        leading: GestureDetector(
            onTap: () {
              Get.to(() => Splash());
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.splashScreen,
              size: h / 30,
            )),
        title: Text(
          showOptions ? '${selectedFiles.length} selected' : 'Download Files',
          // 'Download Files',
          style: AppTextStyle.commonText.copyWith(fontSize: h / 35),
        ),
      ),
      body: Stack(children: [
        FutureBuilder<List<File>>(
            future: futureCsvFiles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text('No files found'),
                );
              }
              final csvFile = snapshot.data!;

              return Column(children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: csvFile.length,
                      itemBuilder: (context, index) {
                        File file = csvFile[index];

                        bool isSelected = selectedFiles.any(
                            (selectedFile) => selectedFile.path == file.path);

                        return Card(
                          color: isSelected ? Colors.grey[300] : Colors.white,
                          elevation: 0.5,
                          child: ListTile(
                            onTap: () {
                              toogleFileSelection(file);
                            },
                            leading: Image.asset(
                              splashImg,
                              height: h / 25,
                            ),
                            title: Text(file.path.split('/').last,
                                style: TextStyle(fontSize: h / 60)),
                            // subtitle: Text(file.path),
                            trailing: isSelected
                                ? IconButton(
                                    icon: const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    onPressed: () {
                                      // Deselect the item when clicking the check icon.
                                      setState(() {
                                        selectedFiles.remove(file);
                                        showOptions = selectedFiles.isNotEmpty;
                                      });
                                    },
                                  )
                                : SizedBox(
                                    height: h / 30,
                                    child: ElevatedButton(
                                      style: AppButtonStyle.openFileButton,
                                      onPressed: () {
                                        downloadFunctions.openFile(file);
                                      },
                                      child: Text('Open',
                                          style: AppTextStyle.openText
                                              .copyWith(fontSize: h / 50)),
                                    ),
                                  ),
                          ),
                        );
                      }),
                ),
                if (showOptions && selectedFiles.isNotEmpty)
                  BottomAppBar(
                    height: h / 15,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: removeFromAppList,
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: shareSelectedFile,
                            icon: Icon(Icons.share)),
                      ],
                    ),
                  )
              ]);
            }),
      ]),
    );
  }

  void toogleFileSelection(File file) {
    setState(() {
      if (selectedFiles.contains(file)) {
        print('called removed function ');
        selectedFiles
            .removeWhere((selectedFile) => selectedFile.path == file.path);
      } else {
        print('called add function ');
        selectedFiles.add(file);
        print('File selected: ${file.path}');
      }
      // Update showOptions based on selection
      showOptions = selectedFiles.isNotEmpty;
    });
  }

  void shareSelectedFile() async {
    print('Function start selected file');
    if (selectedFiles.isNotEmpty) {
      // Create a list of XFile from selectedFiles
      final xFiles = selectedFiles.map((file) => XFile(file.path)).toList();

      try {
        // Share the list of XFiles
        await Share.shareXFiles(xFiles, text: 'Here are the CSV files :');
        print('Files shared successfully.');
        // Clear the selected files after sharing
        setState(() {
          selectedFiles.clear(); // Clear the list of selected files
          showOptions = false; // Hide options if no files are selected
        });
      } catch (e) {
        print('Error sharing files: $e');
        Get.snackbar('Error', 'Failed to share files: $e',
            snackPosition: SnackPosition.TOP, duration: Duration(seconds: 5));
      }
    } else {
      print('No files selected to share.');
    }
  }

  Future<void> removeFromAppList() async {
    setState(() {
      // Loop through the selected files and remove each from the device
      for (var file in selectedFiles) {
        print('loops start');
        //file.existsSync used to dlt mobile storage files
        if (file.existsSync()) {
          print('syunc start ');
          file.deleteSync(); // Deletes the file from the device storage
        }
      }
      // Clear the selectedFiles list to update the UI
      print('selected file dlt ');
      selectedFiles.clear();
      showOptions = false;
      futureCsvFiles = downloadFunctions.getCSVFiles();
    });

    // Show a message indicating successful deletion
    Get.snackbar('Remove successfully ',
        'Selected files have been removed successfully.',
        duration: Duration(seconds: 3));
  }
}
