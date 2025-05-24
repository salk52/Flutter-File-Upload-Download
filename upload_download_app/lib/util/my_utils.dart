import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        DismissDirection,
        Flexible,
        Icon,
        Icons,
        Row,
        ScaffoldMessenger,
        SizedBox,
        SnackBar,
        SnackBarBehavior,
        Text,
        TextOverflow;

extension MyUtils on BuildContext {
  void showErrorMessage(String error, {int? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(
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
