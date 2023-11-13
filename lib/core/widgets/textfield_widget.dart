import 'package:boilerplate/constants/app_theme.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String title;
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final TextEditingController textController;
  final EdgeInsets padding;
  final ValueChanged? onChanged;

  const TextFieldWidget({
    Key? key,
    required this.title,
    required this.textController,
    required this.errorText,
    this.hint,
    this.isObscure = false,
    this.padding = const EdgeInsets.all(0),
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          this.title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextField(
          controller: this.textController,
          onChanged: this.onChanged,
          cursorColor: Colors.transparent,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.blue.shade800,
              ),
            ),
            hintText: this.hint,
          ),
          style: TextStyle(fontSize: 12),
          obscureText: this.isObscure,
        ),
        SizedBox(
          height: 8,
        ),
        if (errorText != null)
          Text(
            errorText!,
            style: TextStyle(
              color: Colors.red, // Customize the error text color
              fontSize: AppThemeData.bodyText5, // Customize the error text size
            ),
          ),
      ],
    );
  }
}
