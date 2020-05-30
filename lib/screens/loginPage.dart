import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './homePage.dart';
import '../provider/Auth.dart';
import './registrationPage.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = 'loginscreen';
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernamet = new TextEditingController();
  TextEditingController passwordt = new TextEditingController();
  bool _isntValidUsername = false,
      _isntValidPassword = false,
      _isloading = false;
  final logo = Hero(
    tag: 'hero',
    child: Image.asset(
      'assets/logo.png',
      height: 128,
      width: 128,
    ),
  );

  Widget usertf() {
    return TextField(
      controller: usernamet,
      autofocus: false,
      decoration: InputDecoration(
        errorText: _isntValidUsername ? "Change your username" : null,
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

  Widget passwordtf() {
    return TextField(
      controller: passwordt,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        errorText: _isntValidPassword
            ? 'Length of the password must be greater than 6'
            : null,
        labelStyle: const TextStyle(fontSize: 20),
        hintText: !_isntValidPassword ? 'Enter your Password' : null,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      //  child: ButtonTheme(minWidth: 20,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            (usernamet.text.isEmpty)
                ? _isntValidUsername = true
                : _isntValidUsername = false;
            (passwordt.text.length < 6)
                ? _isntValidPassword = true
                : _isntValidPassword = false;
          });
          if (!_isntValidUsername && !_isntValidPassword) {
            setState(() {
              _isloading = true;
            });
            Provider.of<Auth>(context, listen: false)
                .login(usernamet.text, passwordt.text)
                .catchError((e) {
              setState(() {
                _isloading = false;
              });
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
              if (!a) {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Could\'nt login with the given credentials'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Ok'))
                          ],
                        ));
              } else {
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              }
            });
            print(usernamet.text + ' ' + passwordt.text);
          }
        },
        padding: const EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
      //    ),
    );
  }

  @override
  void dispose() {
    usernamet.dispose();
    passwordt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            const SizedBox(height: 48.0),
            usertf(),
            const SizedBox(height: 15.0),
            passwordtf(),
            const SizedBox(height: 24.0),
            _isloading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: <Widget>[
                    loginButton(context),
                    const SizedBox(height: 20),
                    FlatButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(RegistrationScreen.routeName),
                        child: const Text('Sign Up instead'))
                  ]),
          ],
        ),
      ),
    );
  }
}
