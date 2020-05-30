import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../faceAuthentication.dart';
import 'package:online_attendance_register/provider/Auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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

  Future<void> _calculateAttendance(BuildContext context, DateTime date) async {
    final prod = Provider.of<Auth>(context, listen: false);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    print(formattedDate);
    const url = 'http://192.168.1.22:8000/api/calcattendance/';
    try {
      final response = await http.post(url,
          headers: {'Authorization': 'Token ${prod.token}'},
          body: {'username': prod.username, 'date': formattedDate});
      final k = json.decode(response.body) as Map;

      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Success'),
                content: Text('You have ${k['result']}% Attendnce'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'))
                ],
              ));
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Unknown Error'),
                content:
                    Text('Couldn\'t fetch the attendance, please try again'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'))
                ],
              ));
    }
  }

  bool _isloading = false;
  bool _isloading2 = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: TextStyle(fontSize: 50, fontFamily: 'Aaargh'),
            ),
            SizedBox(
              height: 20,
            ),
            GridView(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal[200],
                        borderRadius: BorderRadius.circular(20.0)),
                    margin: EdgeInsets.all(10),
                    // color: Colors.teal[200],
                    child: Center(
                      child: _isloading
                          ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.check,
                                  size: 60,
                                ),
                                Text('Mark your Attendance')
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
                        Provider.of<Auth>(context).canauth().then((b) async {
                          didauth = await LocalAuthentication()
                              .authenticateWithBiometrics(
                                  localizedReason:
                                      'Please authenticate to continue with marking attendance');

                          if (didauth) {
                            Navigator.of(context).pushNamed(
                              FaceAuthScreen.routeName,
                            );
                          }
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('You are not inside the college'),
                                  content: Text(
                                      'Reach the College building and try again try again'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('OK'))
                                  ],
                                ));
                      }
                    });
                  },
                ),
                GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.teal[200],
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: _isloading2
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.black),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.find_in_page, size: 60),
                                  Text('Find your Attendance')
                                ],
                              ),
                      ),
                    ),
                    onTap: () async {
                      DateTime selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2030),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child,
                          );
                        },
                      );

                      setState(() {
                        _isloading2 = true;
                      });

                      await _calculateAttendance(context, selectedDate);
                      //print(k);
                      setState(() {
                        _isloading2 = false;
                      });
                    }),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.notifications, size: 60),
                      Text('Notifications')
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.more_horiz, size: 60),
                      Text('More')
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ]),
    );
  }
}
