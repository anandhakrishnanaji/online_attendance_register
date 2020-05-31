import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './homePage.dart';
import '../provider/Auth.dart';
import './faceRegister.dart';

class RegistrationScreen extends StatefulWidget {
  static String routeName = '/regpage';
  @override
  _RegistrationScreenState createState() => new _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailt = new TextEditingController();
  TextEditingController passwordt = new TextEditingController();
  TextEditingController usernamet = new TextEditingController();
  TextEditingController password2t = new TextEditingController();
  bool _isntValidEmail = false,
      _isntValidPassword = false,
      _isntValidPassword2 = false,
      _isntValidUsername = false,
      _isloading = false;

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget passwordtf(String text, String errortext) {
    bool _foo = text == "Password" ? _isntValidPassword : _isntValidPassword2;
    return TextField(
      controller: text == "Password" ? passwordt : password2t,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _foo ? errortext : null,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: !_foo ? text : null,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget usertf() {
    return TextField(
      controller: usernamet,
      autofocus: false,
      decoration: InputDecoration(
        errorText: _isntValidUsername ? "Username already exists" : null,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: !_isntValidUsername ? "Username" : null,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(
          Icons.person,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            (emailt.text.isEmpty || !emailt.text.contains('@'))
                ? _isntValidEmail = true
                : _isntValidEmail = false;
            (passwordt.text.length < 6)
                ? _isntValidPassword = true
                : _isntValidPassword = false;
            (password2t.text != passwordt.text)
                ? _isntValidPassword2 = true
                : _isntValidPassword2 = false;
          });
          if (!_isntValidEmail && !_isntValidPassword && !_isntValidPassword2) {
            setState(() {
              _isloading = true;
            });

            Provider.of<Auth>(context, listen: false)
                .register(usernamet.text, passwordt.text, emailt.text)
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

              if (a['email'] == "1" && a['username'] == "1") {
                Navigator.of(context)
                    .pushReplacementNamed(FaceRegisterScreen.routeName);
              } else {
                _isntValidUsername = a['username'] == "1" ? true : false;
                _isntValidEmail = a['email'] == "1" ? true : false;
              }
            });

            //print(emailt.text + ' ' + passwordt
          }
        },
        padding: const EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: const Text('Register', style: TextStyle(color: Colors.white)),
      ),
      //    ),
    );
  }

  @override
  void dispose() {
    emailt.dispose();
    usernamet.dispose();
    password2t.dispose();
    passwordt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor:Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            const Text(
              'Sign Up',
              /* style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),*/
            ),
            const SizedBox(height: 48.0),
            emailtf(),
            const SizedBox(height: 15.0),
            passwordtf("Password", "Length of password must be greater than 6"),
            const SizedBox(height: 15.0),
            passwordtf("Confirm Password", "Passowrds do not match"),
            const SizedBox(height: 15.0),
            usertf(),
            const SizedBox(height: 24.0),
            _isloading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: <Widget>[
                    registerButton(context),
                    const SizedBox(height: 20),
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Login instead'))
                  ]),
          ],
        ),
      ),
    );
  }
}
