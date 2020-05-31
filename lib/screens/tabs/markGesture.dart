import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../faceAuthentication.dart';
import 'package:online_attendance_register/provider/Auth.dart';
import 'package:local_auth/local_auth.dart';
import '../utils/alertDialog.dart';

class MarkAttendance extends StatefulWidget {
  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  Future<bool> _checkLocation() async {
    print('hello');
    const lat1 = 9.963907, lon1 = 76.408399;
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    double distance = await Geolocator()
        .distanceBetween(position.latitude, position.longitude, lat1, lon1);
    print(distance);
    return distance < 20000;
  }

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.teal[200], borderRadius: BorderRadius.circular(20.0)),
        margin:const EdgeInsets.all(10),
        // color: Colors.teal[200],
        child: Center(
          child: _isloading
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.check,
                      size: 60,
                    ),
                    Text(
                      'Mark your Attendance',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
        ),
      ),
      onTap: () {
        setState(() {
          _isloading = true;
        });
        _checkLocation().then((a) async {
          setState(() {
            _isloading = false;
          });
          if (a) {
            print('hi again');
            bool didauth = true;
            Provider.of<Auth>(context,listen: false).canauth().then((b) async {
              didauth = await LocalAuthentication().authenticateWithBiometrics(
                  localizedReason:
                      'Please authenticate to continue with marking attendance');

              if (didauth) {
                print('yoyo');
                Navigator.of(context).pushNamed(
                  FaceAuthScreen.routeName,
                );
              }
            });
          } else {
            showDialog(
                context: context,
                builder: (ctx) => AlerttBox(
                    'You are not inside the college',
                    'Reach the College building and try again try again',
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'))));
          }
        });
      },
    );
  }
}
