import 'package:flutter/material.dart';

class AlerttBox extends StatelessWidget {
  final text, content, wid;
  AlerttBox(this.text, this.content, this.wid);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
        style:const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(content, style:const TextStyle(fontWeight: FontWeight.w600)),
      actions: <Widget>[wid],
    );
  }
}
