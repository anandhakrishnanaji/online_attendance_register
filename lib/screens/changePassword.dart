import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Auth.dart';
import './homePage2.dart';

class ChangePassScreen extends StatefulWidget {
  static String routeName = '/changepassword';
  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  TextEditingController password = new TextEditingController();
  TextEditingController npassword = new TextEditingController();
  TextEditingController npassword2 = new TextEditingController();
  bool _isntValidPassword = false,
      _isntValidnPassword2 = false,
      _isntValidnPassword = false,
      _isloading = false;

  Widget npasswordtf(String text, String errortext) {
    bool _foo = text == "Password" ? _isntValidnPassword : _isntValidnPassword2;
    return TextField(
      controller: text == "Password" ? npassword : npassword2,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _foo ? errortext : null,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: !_foo ? text : null,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.black,
        ),
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
            (npassword.text.length < 6)
                ? _isntValidnPassword = true
                : _isntValidnPassword = false;
            (npassword2.text != npassword.text)
                ? _isntValidnPassword2 = true
                : _isntValidnPassword2 = false;
          });
          if (!_isntValidnPassword && !_isntValidnPassword2) {
            setState(() {
              _isloading = true;
            });

            Provider.of<Auth>(context, listen: false)
                .changepassword(password.text, npassword.text)
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
                          content: const Text('Password successfully changed'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok'))
                          ],
                        ));
              } else {
                setState(() {
                  _isntValidPassword = a == -1 ? true : false;
                });
              }
            });

            //print(emailt.text + ' ' + passwordt
          }
        },
        padding: const EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: const Text('Change Password',
            style: TextStyle(color: Colors.white)),
      ),
      //    ),
    );
  }

  @override
  void dispose() {
    password.dispose();
    npassword2.dispose();
    npassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          const SizedBox(height: 25.0),
          const Text(
            'Change Password',
          ),
          const SizedBox(height: 48.0),
          passwordtf(),
          const SizedBox(height: 15.0),
          npasswordtf("Password", "Length of password must be greater than 6"),
          const SizedBox(height: 15.0),
          npasswordtf("Confirm Password", "Passowrds do not match"),
          const SizedBox(height: 24.0),
          _isloading
              ? const Center(child: CircularProgressIndicator())
              : registerButton(context)
        ],
      ),
    );
  }
}
