import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// dialog result enumeration
enum DialogResult {
  /// user accepted
  ok,
  /// user canceled the operation
  cancel,
  /// user closed the dialog
  close
}
/// Dialogs showing utility
class Dialogs {
  /// show a simple ok-close dialog
  static Future<DialogResult> messageDialog
  (
    BuildContext context,
    String title,
    String message,
    {bool prompt=false}
  ) async =>
    showDialog<DialogResult>(
      context: context,
      barrierDismissible: !prompt,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(DialogResult.close);
              },
            ),
            Visibility(
              visible: prompt,
              child: FlatButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop(DialogResult.ok);
                },
              ),
            )
          ],
        )
    );
}