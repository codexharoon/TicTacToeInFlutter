import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {

  final String title;
  final String content;
  final VoidCallback callback;
  final String actionText;

  const CustomDialog(
    {
    super.key,
    required this.title,
    required this.content,
    required this.callback,
    this.actionText = 'Reset'
    }
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: callback,
          child: Text(actionText),
        )
      ],
    );
  }
}