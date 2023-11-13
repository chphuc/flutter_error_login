import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color textColor;
  final double buttonTextSize;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onPressed;

  const RoundedButtonWidget({
    Key? key,
    required this.buttonText,
    this.buttonColor = Colors.blue,
    this.textColor = Colors.white,
    required this.onPressed,
    this.buttonTextSize = 14.0,
    this.height = 20.0,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(this.buttonColor!),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.zero,
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
            Size(double.infinity, this.height!)),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
          fontSize: buttonTextSize,
        ),
      ),
    );
  }
}
