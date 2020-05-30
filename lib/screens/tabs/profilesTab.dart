import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_attendance_register/provider/Auth.dart';
import '../changePassword.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uname = Provider.of<Auth>(context).username;
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: new Container(
            width: 140.0,
            height: 140.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                image: NetworkImage(
                    'https://ui-avatars.com/api/?background=8A2BE2&color=fff&name=$uname'),
                fit: BoxFit.cover,
              ),
            )),
      ),
      Divider(
        height: 30,
        indent: 70,
        endIndent: 70,
      ),
      Text(
        'Username',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
      Text(
        '  ' + uname,
        style: TextStyle(fontSize: 30),
      ),
      Divider(),
      FlatButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(ChangePassScreen.routeName),
          child: Text('Change Password')),
      Divider(),
      FlatButton.icon(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          label: Text('Log Out', style: TextStyle(color: Colors.red)),
          onPressed: () => Provider.of<Auth>(context).logout())
    ]);
  }
}
