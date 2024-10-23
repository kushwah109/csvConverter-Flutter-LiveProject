import 'package:flutter/material.dart';

class SplashCustomButton extends StatelessWidget {
  final String label;
  final IconData iconPath;
  final Color color;
  final TextStyle textStyle;
  final Function() onPressed;
  const SplashCustomButton({super.key, required this.label,  required this.iconPath, required this.onPressed, required this.textStyle, required this.color});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SizedBox(
      height: h/16,
      width: w/0.5,
      child: ElevatedButton(
        style:  ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)), // No border radius for square shape
            ),
            elevation: 5
        ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                style: textStyle,),
              Icon(iconPath)
            ],
          ),
        ),
    );
  }
}
