import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: const ListTile(
            leading: Icon(
              Icons.notifications_paused,
              color: Colors.white,
            ),
            title:const Text('No new Notifications'),
          ),
        )
      ],
    );
  }
}
