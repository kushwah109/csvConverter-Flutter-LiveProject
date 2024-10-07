
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;

class ApiService{
 Future<dynamic> uploadFile(File file)async{
   print('step1');
   var baseUrl = 'http://20.106.63.29/process_invoice/';

   var url = Uri.parse(baseUrl);
   var request = http.MultipartRequest('POST', url);
   print('step2');
   print('File path: ${file.path}');
  request.files.add(await http.MultipartFile.fromPath('file',file.path));
   try{
   request.headers['Content-Type'] = 'multipart/form-data';

     var response = await request.send();
     if (response.statusCode == 200){
       print('step4');
       var responseBody = await http.Response.fromStream(response);

       // Assuming the response contains CSV data
       // You can parse the CSV and extract data
       print('Response data: ${responseBody.body}');

       // // Example of how to process CSV data
       // List<String> csvLines = responseBody.body.split('\n');
       // for (var line in csvLines) {
       //   print("line $line");
       // }
       print('step5');
       // var jsonResponse = jsonDecode(responseBody.body);
       // var downloadLink = jsonResponse['download_link'];
       
       // var downloadLink = extractDownloadLink(responseBody.body);
       var downloadLink = responseBody.body;
       print('downloadLink data $downloadLink');
       return downloadLink;
     }else{
       print('Failed to upload file ${response.statusCode}');
     }
   }catch(e){
     print('Error uploading file $e');
   }
   return null;
 }
String? extractDownloadLink(String responseBody){
   try{
     print('extract');
     var json = jsonDecode(responseBody);
     print(json);
     return json['file_url'];
   }catch (e) {
     print('Error parsing JSON response: $e');
     return null;
   }


}

}
// class Converter{
//
//   Future<String>  convertToCSV(File inputFile ,ValueNotifier<double> progressNotifier)async{
//     print('process method start');
//
//     List<List<dynamic>> csvData = []; // This will hold your CSV data
//
//     for (int i = 0; i <= 100; i += 10) {
//       await Future.delayed(Duration(milliseconds: 300)); // Simulate work
//       progressNotifier.value = i / 100; // Update progress
//       csvData.add(['Row $i', 'Data $i']); // Sample data
//     }
//     //
//     // // Save the CSV file in a user-friendly location (Documents or Downloads)
//     // Directory directory = Directory('/storage/emulated/0/Documents'); // Save to Documents folder
//     // if (!directory.existsSync()) {
//     //   directory.createSync(); // Create the folder if it doesn't exist
//     // }
//     //
//     // String csvFilePath = '${directory.path}/converted_file_${DateTime.now().millisecondsSinceEpoch}.csv'; // Unique file name
//
//     // Convert to CSV format
//     String csv = ListToCsvConverter().convert(csvData);
//
//     // Return the CSV data as a string
//     return csv;
//     // // Write the CSV file
//     // File csvFile = File(csvFilePath);
//     // await csvFile.writeAsString(csv);
//     //
//     // print('CSV file saved at: $csvFilePath');
//     // return csvFilePath; // Return the path of the converted CSV file
//   }
//
//
//
// }
