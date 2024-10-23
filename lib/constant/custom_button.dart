import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData iconPath;
  final Color color;
  final TextStyle textStyle;
  final Function() onPressed;
  const CustomButton({super.key, required this.label, required this.iconPath, required this.color, required this.onPressed, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    // final h = MediaQuery.of(context).size.height;
    // final w = MediaQuery.of(context).size.width;

    return Container(
      // margin: EdgeInsets.symmetric(vertical: h/80,horizontal: w/50),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: ElevatedButton(
        style:  ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)), // No border radius for square shape
          ),
          elevation: 0
        ),
        onPressed:onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: textStyle,
            ),
            Icon(iconPath)
            // Image.asset(
            //     iconPath,
            //   width: h/20,  // Adjust width as needed
            //   height: w/15,
            // ),
          ],
        ),
      ),
    );
  }
}



