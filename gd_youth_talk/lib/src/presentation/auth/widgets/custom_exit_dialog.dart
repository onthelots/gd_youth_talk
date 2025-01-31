import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomExitDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelButtonText;
  final String continueButtonText;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const CustomExitDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelButtonText,
    required this.continueButtonText,
    required this.onCancel,
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
            onPressed: onCancel,
            isDestructiveAction: true,
            child: Text(
              cancelButtonText,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
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
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onCancel,
            child: Text(cancelButtonText),
          ),
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