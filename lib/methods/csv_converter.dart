import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> uploadFile(File file) async {
    print('uploadFile method called');
    var baseUrl = 'http://20.106.63.29/upload-file/';
    var url = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', url);
    print('step2');
    print('File path: ${file.path}');
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    try {
      request.headers['Content-Type'] = 'multipart/form-data';

      var response = await request.send();
      if (response.statusCode == 200) {
        print('step4');
        var responseBody = await http.Response.fromStream(response);

        // Assuming the response contains CSV data
        // You can parse the CSV and extract data
        print('Response data: ${responseBody.body}');

        print('step5');

        var downloadLink = responseBody.body;
        print('downloadLink data $downloadLink');
        return downloadLink;
      } else {
        print('Failed to upload file ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file $e');
    }
    return null;
  }

  Future<dynamic> uploadDotedFile(File file) async {
    print('step1 for upload doted file');
    var baseUrl = 'http://20.106.63.29/process_invoice/';
    var url = Uri.parse(baseUrl);
    var request = await http.MultipartRequest('Post', url);
    print('step2 for upload doted file');
    print('File path of doted file : ${file.path}');
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    try {
      request.headers['Content-Type'] = 'multipart/form-data';
      var response = await request.send();
      if (response.statusCode == 200) {
        print('step4 for upload doted file');
        var responseBody = await http.Response.fromStream(response);
        print('Response data of doted file: ${responseBody.body}');

        print('step5 for uploading doted file');

        var downloadLink = responseBody.body;
        print('downloadLink data of doted file  $downloadLink');
        return downloadLink;
      } else {
        print('Failed to upload file ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file for doted file $e');
    }
    return null;
  }
}
