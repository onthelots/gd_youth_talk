import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRequestDialog extends StatelessWidget {
  final String title;
  final String content;
  final String continueButtonText;
  final VoidCallback onContinue;

  const CustomRequestDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.continueButtonText,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: onContinue,
            child: Text(
              continueButtonText,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onContinue,
            child: Text(continueButtonText),
          ),
        ],
      );
    }
  }
}