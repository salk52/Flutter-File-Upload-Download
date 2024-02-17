import 'package:flutter/material.dart';

class DialogService {
  final GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  Future<void> showMyDialog({required String title, required String description}) async {
    return showDialog<void>(
      context: _dialogNavigationKey.currentState!.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(description)],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
