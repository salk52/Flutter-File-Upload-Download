import 'package:flutter/material.dart';

AlertDialog buildDialog({title, message, confirm, cancel, confirmFn, cancelFn}) {
  return new AlertDialog(
    title: title != null ? new Text(title) : null,
    content: message != null ? new Text(message) : null,
    actions: <Widget>[
      confirmFn != null ? new FlatButton(onPressed: confirmFn, child: new Text(confirm)) : null,
      cancelFn != null ? new FlatButton(onPressed: cancelFn, child: new Text(cancel)) : null
    ],
  );

// EXAMPLE
//      var dialog = DialogShower.buildDialog(
//         message: message,
//         confirm: "OK",
//         confirmFn: () => Navigator.pop(context));
//     showDialog(context: context, child: dialog);
}
