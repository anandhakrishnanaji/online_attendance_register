import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
//import 'package:camera/camera.dart';

class Auth with ChangeNotifier {
  String _username = null;
  String _token = null;
  //CameraDescription _cameras;
  get username {
    return _username;
  }

  get token {
    return _token;
  }

  bool isAuth() {
    return token != null;
  }

  /*get cameras {
    return _cameras;
  }*/

  Future<bool> login(String username, String password) async {
    const url = 'http://192.168.1.22:8000/api/login/';
    print('hi ' + username);
    try {
      var response = await http
          .post(url, body: {'username': username, 'password': password});
      print(response.body);
      var r = json.decode(response.body) as Map;
      if (r.containsKey('non_field_errors')) return false;
      _token = r['token'];
      _username = username;
      _saveToken();
      notifyListeners();
      return true;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<Map> register(String username, String password, String email) async {
    const url = 'http://192.168.1.22:8000/api/register/';
    try {
      var response = await http.post(url, body: {
        'username': username,
        'password': password,
        'password2': password,
        'email': email
      });
      print('hi boi');
      print(response.body);
      var r = json.decode(response.body) as Map;
      if (r['email'] == "0") return {"email": "0", "username": "1"};
      if (r['username'] == "0") return {"email": "0", "username": "1"};
      _token = r['token'];
      _username = username;
      _saveToken();
      notifyListeners();
      return {"email": "1", "username": "1"};
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  void _saveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token);
    prefs.setString('username', _username);
    print('token set');
  }

  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token') && prefs.containsKey('username')) {
      _token = prefs.getString('token');
      _username = prefs.getString('username');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _token = null;
    _username = null;
    notifyListeners();
  }

  /* void setCamera(CameraDescription cameraas) {
    _cameras = cameraas;
  }*/

  Future<int> changepassword(String opassword, String npassword) async {
    const url = 'http://192.168.1.22:8000/api/login/';

    try {
      var response = await http
          .post(url, body: {'username': username, 'password': opassword});
      print(response.body);
      var r = json.decode(response.body);
      if (r.containsKey('non_field_errors'))
        return -1;
      else {
        const url1 = 'http://192.168.1.22:8000/api/changepassword/';
        response = await http.post(url1,
            body: {'password': npassword,'username':username},
            headers: {'Authorization': 'Token $_token'});
        r = json.decode(response.body) as Map;
        if (r['result'] == "true")
          return 1;
        else
          return 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> canauth() async {
    final localauth = LocalAuthentication();
    bool checkb = await localauth.canCheckBiometrics;
    if (!checkb) return checkb;
    List<BiometricType> avalable = await localauth.getAvailableBiometrics();
    return avalable.contains(BiometricType.fingerprint);
  }

  Future<int> changeEmail(String password,String email) async{
    const url = 'http://192.168.1.22:8000/api/login/';

    try {
      var response = await http
          .post(url, body: {'username': username, 'password': password});
      print(response.body);
      var r = json.decode(response.body) as Map;
      if (r.containsKey('non_field_errors'))
        return -1;
      else {
        const url1 = 'http://192.168.1.22:8000/api/changeemail/';
        response = await http.post(url1,
            body: {'email': email,'username':username},
            headers: {'Authorization': 'Token $_token'});
        r = json.decode(response.body) as Map;
        if (r['result']=='true')
          return 1;
        else
          return 0;
      }
    } catch (e) {
      throw e;
    }

  }
}
