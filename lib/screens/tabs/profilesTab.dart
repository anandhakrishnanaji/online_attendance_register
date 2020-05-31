import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_attendance_register/provider/Auth.dart';
import '../changePassword.dart';
import '../changeEmail.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uname = Provider.of<Auth>(context, listen: false).username;
    return Column(children: <Widget>[
      Padding(
        padding:const EdgeInsets.only(top: 20.0),
        child: Container(
            width: 140.0,
            height: 140.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    'https://ui-avatars.com/api/?background=8A2BE2&color=fff&name=$uname&size=140'),
                fit: BoxFit.cover,
              ),
            )),
      ),
      const Divider(
        height: 30,
        indent: 70,
        endIndent: 70,
      ),
      const Text(
        'Username',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
      Text(
        '  ' + uname,
        style: TextStyle(fontSize: 30),
      ),
      const Divider(),
      FlatButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(ChangePassScreen.routeName),
          child: Text('Change Password')),
      const Divider(),
      FlatButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(ChangeEmailScreen.routeName),
          child:const Text('Change Email address')),
      const Divider(),
      FlatButton.icon(
          icon:const Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          label:const Text('Log Out', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).pushReplacementNamed('/');
          })
    ]);
  }
}
