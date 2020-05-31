import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Auth.dart';
import './homePage2.dart';

class ChangeEmailScreen extends StatefulWidget {
  static String routeName = '/changeemail';
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  TextEditingController password = new TextEditingController();
  TextEditingController emailt = new TextEditingController();
  bool _isntValidPassword = false, _isntValidEmail = false, _isloading = false;

  Widget emailtf() {
    return TextField(
      controller: emailt,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        errorText: _isntValidEmail ? 'Enter Valid E mail' : null,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: !_isntValidEmail ? 'Email' : null,
        prefixIcon: const Icon(
          Icons.email,
          color: Colors.black,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget passwordtf() {
    return TextField(
      controller: password,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _isntValidPassword ? "Current Password is Incorrect" : null,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: !_isntValidPassword ? "Current Password" : null,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget registerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      //  child: ButtonTheme(minWidth: 20,
      child: RaisedButton(
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
        onPressed: () {
          setState(() {
            (emailt.text.isEmpty || !emailt.text.contains('@'))
                ? _isntValidEmail = true
                : _isntValidEmail = false;
          });
          if (!_isntValidEmail) {
            setState(() {
              _isloading = true;
            });

            Provider.of<Auth>(context, listen: false)
                .changeEmail(password.text, emailt.text)
                .catchError((e) {
              setState(() {
                _isloading = false;
              });

              print(e.toString());
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: const Text('Unknown Error'),
                        content: const Text(
                            'Can\'t connect to the server, Check your Internet Connection'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Ok'))
                        ],
                      ));
            }).then((a) {
              setState(() {
                _isloading = false;
              });

              if (a == 1) {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Email successfully changed'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok'))
                          ],
                        ));
              } else if (a == -1) {
                setState(() {
                  _isntValidPassword = a == -1 ? true : false;
                });
              } else {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Task Failed'),
                          content: const Text(
                              'Entered email is linked with another account'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Ok'))
                          ],
                        ));
              }
            });

            //print(emailt.text + ' ' + passwordt
          }
        },
        padding: const EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child:
            const Text('Change Email', style: TextStyle(color: Colors.white)),
      ),
      //    ),
    );
  }

  @override
  void dispose() {
    password.dispose();
    emailt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          const SizedBox(height: 25.0),
          const Text(
            'Change Email',
          ),
          const SizedBox(height: 48.0),
          emailtf(),
          const SizedBox(height: 15.0),
          passwordtf(),
          const SizedBox(height: 24.0),
          _isloading
              ? const Center(child: CircularProgressIndicator())
              : registerButton(context)
        ],
      ),
    );
  }
}
