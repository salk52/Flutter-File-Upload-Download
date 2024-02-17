import 'package:flutter/material.dart';

class SnackbarService {
  //final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<ScaffoldState> messengerKey = GlobalKey<ScaffoldState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void showSnackBar(String message, {Color? backgroundColor, int? duration}) {
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message),
      dismissDirection: DismissDirection.startToEnd,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: duration ?? 2),
    );
    //messengerKey.currentState?.showSnackBar(snackBar);
    ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(snackBar);
  }
}
