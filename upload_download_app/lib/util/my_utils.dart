import 'package:flutter/material.dart';

extension MyUtils on BuildContext {
  void showErrorMessage(String error, {int? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  error,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          dismissDirection: DismissDirection.startToEnd,
          behavior: SnackBarBehavior.fixed,
          duration: Duration(seconds: duration ?? 2),
        ),
      );
  }
}
