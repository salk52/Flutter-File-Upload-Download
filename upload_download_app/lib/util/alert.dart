import 'package:flutter/material.dart';

AlertDialog buildDialog(
    {title, message, confirm, cancel, confirmFn, cancelFn}) {
  return AlertDialog(
    title: title != null ? Text(title) : null,
    content: message != null ? Text(message) : null,
    actions: <Widget>[
      if (confirmFn != null)
        TextButton(onPressed: confirmFn, child: Text(confirm)),
      if (cancelFn != null)
        TextButton(onPressed: cancelFn, child: Text(cancel)),
    ],
  );

// EXAMPLE
//      var dialog = DialogShower.buildDialog(
//         message: message,
//         confirm: "OK",
//         confirmFn: () => Navigator.pop(context));
//     showDialog(context: context, child: dialog);
}
