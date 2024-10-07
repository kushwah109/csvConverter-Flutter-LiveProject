import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FileExtension {
  //function to get extension
  String getFileExtension(String filePath){
    return extension(filePath);
  }

  //function for get file name
  String getFileName(String filePath){
    return basename(filePath);
  }


  //for show file icon according to extension
  Widget getFileIcon(String fileExtension, double iconSize) {
    switch (fileExtension.toLowerCase()) {
      case '.pdf':
        return Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.red);
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icon(Icons.image, size: iconSize, color: Colors.green);
      default:
        return Icon(Icons.insert_drive_file, size: iconSize, color: Colors.grey);
    }
  }


}
