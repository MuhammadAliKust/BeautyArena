import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showErrorDialog(
    BuildContext context, {
      required String message,
    }) async {
  showDialog(
      barrierDismissible: false,
      context: (context),
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Alert!",
            style: TextStyle(color: Colors.red),
          ),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Okay"))
          ],
        );
      });
}