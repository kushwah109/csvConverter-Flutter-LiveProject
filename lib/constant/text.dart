import 'package:csv_converter/constant/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle convert =
      TextStyle(fontWeight: FontWeight.bold, color: AppColor.homeButtonColor);
  static TextStyle commonText =
      TextStyle(fontWeight: FontWeight.bold, color: AppColor.homeButtonColor);
  static TextStyle homeButton = TextStyle(color: AppColor.buttonText);
  static TextStyle downloadTextButton =
      TextStyle(color: AppColor.downloadText, fontWeight: FontWeight.bold);
  static TextStyle whatsappText = TextStyle(
      color: AppColor.convertHeadingColor, fontWeight: FontWeight.bold);
  static TextStyle mailText = TextStyle(color: AppColor.mailColor);
  static TextStyle openText =
      TextStyle(color: AppColor.openTextColor, fontWeight: FontWeight.bold);
}

class AppButtonStyle {
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColor.homeButtonColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(5)), // No border radius for square shape
    ),
  );
  static ButtonStyle openFileButton = ElevatedButton.styleFrom(
    backgroundColor: AppColor.buttonText,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(5)), // No border radius for square shape
    ),
  );
}
