import 'dart:io';
import 'package:csv_converter/constant/imgespath.dart';
import 'package:csv_converter/methods/downloading_function.dart';
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
  // List<File> selectedFiles = [];
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
    // final prefs = await SharedPreferences.getInstance();
    // List<String>? paths = prefs.getStringList('selected_files');
    //
    // // Convert the list of paths back to List<File>
    // if (paths != null) {
    //   selectedFiles = paths.map((path) => File(path)).toList();
    // }
    // setState(() {
    //
    // });
    final files = await downloadFunctions.getCSVFiles();
    setState(() {
      csvFiles = files;
      futureCsvFiles = Future.value(csvFiles);
    });
  }
  //
  // Future<void> saveSelectedFiles() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> paths = selectedFiles.map((file) => file.path).toList(); // Convert to paths
  //   await prefs.setStringList('selected_files', paths);
  // }


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
              onPressed: (){
                Get.to(Download());
              },
              icon: Icon(AppIcons.downloadDone,size: h/30,color: AppColor.splashScreen))
        ],
        leading: GestureDetector(
            onTap: (){
          Get.back();
        },
            child: Icon(Icons.arrow_back_ios_new,color: AppColor.splashScreen,size: h/30,)),
        title: Text(
          showOptions ? '${selectedFiles.length} selected' : 'Download Files',
          // 'Download Files',
          style:AppTextStyle.commonText.copyWith(fontSize: h/35),),
      ),
      body: Stack(
        children:[ FutureBuilder<List<File>>(
            future:futureCsvFiles,
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasError || !snapshot.hasData){
                return Center(child:Text('No files found') ,);
              }
              final  csvFile = snapshot.data!;
        
              return Column(
                children: [
                  Expanded(
                  child: ListView.builder(
                    itemCount: csvFile.length,
                      itemBuilder: (context,index){
                      File file =csvFile[index];
                      // File file =csvFile[index];
                      // bool isSelected = selectedFiles.contains(file);
                      bool isSelected = selectedFiles.any((selectedFile) => selectedFile.path == file.path);

                      return Card(
                        color:isSelected ? Colors.grey[300] : Colors.white,
                        elevation: 0.5,
                        child:  ListTile(
                          // onTap: ()async{
                          //   if(showOptions){
                          //     setState(() async {
                          //       if(isSelected){
                          //         selectedFiles.removeWhere((selectedFile) => selectedFile.path == file.path);
                          //         if(selectedFiles.isEmpty){
                          //           showOptions = false;
                          //         }
                          //       }else {
                          //         await downloadFunctions.openFile(file);
                          //       }
                          //     });
                          //   }
                          //     // if(!isSelected){
                          //   //   await downloadFunctions.openFile(file);
                          //   //
                          //   // }
                          // },
                          onTap: (){
                            toogleFileSelection(file);
                          },
                          leading: Image.asset(splashImg,height: h/25,),
                          title: Text(file.path.split('/').last,style:TextStyle(fontSize: h/60)),
                          // subtitle: Text(file.path),
                          trailing:isSelected?IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              // Deselect the item when clicking the check icon.
                              setState(() {
                                selectedFiles.remove(file);
                                showOptions = selectedFiles.isNotEmpty;

                                // if (selectedFiles.isEmpty) {
                                //   showOptions = false; // Exit selection mode if no items are selected.
                                // }
                              });
                            },
                          )
                              : SizedBox(
                            height: h/30,
                                child: ElevatedButton(
                                  style: AppButtonStyle.openFileButton,
                                  onPressed: () {
                                downloadFunctions.openFile(file);
                                },
                                  child: Text('Open',style: AppTextStyle.openText.copyWith(fontSize: h/50)),
                                ),
                              ),

                        ),
                      );
                    }
                    ),
                ),
                  if(showOptions && selectedFiles.isNotEmpty)
                    BottomAppBar(
                      height: h/15,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                          //   onPressed: (){
                          //     removeFromAppList();
                          //   },
                              onPressed: removeFromAppList,
                              icon: Icon(Icons.delete)),
                          IconButton(
                              onPressed: shareSelectedFile,
                              icon: Icon(Icons.share)),
                        ],
                      ),
                    )
                ]
              );
            }
            ),
        ]
      ),
    );
  }
  void toogleFileSelection(File file){
    setState(() {
      // showOptions = true;
      // if (!isSelected) {
      //   selectedFiles.add(file);
      // }
      if(selectedFiles.contains(file)) {
        print('called removed function ');
        // selectedFiles.remove(file);
        selectedFiles.removeWhere((selectedFile) => selectedFile.path == file.path);

      }else{
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
        Get.snackbar('Error', 'Failed to share files: $e', snackPosition: SnackPosition.TOP, duration: Duration(seconds: 5));
      }
      // Show the sharing options dialog
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Share Via'),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           ListTile(
      //             title: Text('WhatsApp'),
      //             onTap: () {
      //               Navigator.of(context).pop(); // Close the dialog
      //               // shareToWhatsApp(xFiles);
      //               shareFileToWhatsApp(xFiles);
      //               // Share.shareXFiles(xFiles);
      //             },
      //           ),
      //           ListTile(
      //             title: Text('Email'),
      //             onTap: () {
      //               // Close the dialog
      //               Navigator.of(context).pop();
      //               // Email sharing implementation
      //               Share.share(
      //                 'Here are the files I wanted to share with you!',
      //                 subject: 'Sharing Files',
      //               );
      //             },
      //           ),
      //         ],
      //       ),
      //       actions: [
      //         TextButton(
      //           child: Text('Cancel'),
      //           onPressed: () {
      //             Navigator.of(context).pop(); // Close the dialog
      //             setState(() {
      //               showOptions = false;
      //             });
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      print('No files selected to share.');
    }
  }
  Future<void> removeFromAppList() async {
    // for (var file in selectedFiles) {
    //   if (await file.exists()) {
    //     await file.delete(); // Deletes the file from device storage
    //   }
    // }
    // // selectedFiles.clear(); // Clear the list after deletion
    // // await saveSelectedFiles(); // Update shared preferences
    //
    // // if (selectedFiles.isNotEmpty) {
    //   setState(() {
    // //     // Remove selected files from the futureCsvFiles result
    //     csvFiles.removeWhere((file) => selectedFiles.contains(file));
    // //
    // //     // Update the future to reflect the new list
    // //     futureCsvFiles = Future.value(csvFiles);
    //     });
    // //
    // //     // Clear the selected files after updating the future
    //     selectedFiles.clear();
    //     showOptions = false;
    //   // });
    //
    // // }
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
