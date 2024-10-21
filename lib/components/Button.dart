import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const Button({
    super.key,
    this.isLoading = false,
    this.backgroundColor = sucess,
    this.textColor = Colors.white,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(textColor),
              )
            : Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
