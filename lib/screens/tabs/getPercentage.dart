import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_attendance_register/provider/Auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../utils/alertDialog.dart';

class PercentageGesture extends StatefulWidget {
  @override
  _PercentageGestureState createState() => _PercentageGestureState();
}

class _PercentageGestureState extends State<PercentageGesture> {
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
          builder: (ctx) => AlerttBox(
              'Success',
              'You have ${k['result']}% Attendnce',
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))));
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlerttBox(
              'Unknown Error',
              'Couldn\'t fetch the attendance, please try again',
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))));
    }
  }

  bool _isloading2 = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin:const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.teal[200], borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: _isloading2
                ? CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.find_in_page, size: 60),
                      Text(
                        'Find your Attendance',
                        style: TextStyle(fontSize: 20),
                      )
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
        });
  }
}
