import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: ListTile(
            leading: Icon(
              Icons.notifications_paused,
              color: Colors.white,
            ),
            title: Text('No new Notifications'),
          ),
        )
      ],
    );
  }
}
