

import 'package:csv_converter/constant/colors.dart';
import 'package:flutter/material.dart';
class AppTextStyle{
 static TextStyle heading1 = TextStyle(fontWeight:FontWeight.bold,fontSize: 55,color:AppColor.heading1);
 static TextStyle convert = TextStyle(fontWeight:FontWeight.bold,color:AppColor.homeButtonColor);
 static TextStyle commonText = TextStyle(fontWeight:FontWeight.bold,color:AppColor.homeButtonColor);
 static TextStyle homeButton = TextStyle(color:AppColor.buttonText);
 static TextStyle downloadTextButton = TextStyle(color:AppColor.downloadText,fontWeight: FontWeight.bold);
 static TextStyle whatsappText = TextStyle(color:AppColor.whatsappColor);
 static TextStyle mailText = TextStyle(color:AppColor.mailColor);
 static TextStyle openText = TextStyle(color: AppColor.openTextColor,fontWeight: FontWeight.bold);
}



class AppButtonStyle{
 static ButtonStyle buttonStyle =  ElevatedButton.styleFrom(backgroundColor: AppColor.homeButtonColor,
  shape: RoundedRectangleBorder(
   borderRadius: BorderRadius.all(Radius.circular(5)), // No border radius for square shape
  ),
 );
 static ButtonStyle openFileButton =  ElevatedButton.styleFrom(backgroundColor: AppColor.buttonText,
  shape: RoundedRectangleBorder(
   borderRadius: BorderRadius.all(Radius.circular(5)), // No border radius for square shape
  ),
 );


}

// class WhatsappButtonStyle{
//  static ButtonStyle buttonStyle =  ElevatedButton.styleFrom(backgroundColor: AppColor.whatsappColor,
//   shape: RoundedRectangleBorder(
//    borderRadius: BorderRadius.all(Radius.circular(5)), // No border radius for square shape
//   ),
//  );
// }
//
// class EmailButtonStyle{
//  static ButtonStyle buttonStyle =  ElevatedButton.styleFrom(backgroundColor: AppColor.mailColor,
//   shape: RoundedRectangleBorder(
//    borderRadius: BorderRadius.all(Radius.circular(5)), // No border radius for square shape
//   ),
//  );
// }