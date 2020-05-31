import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './getPercentage.dart';
import './markGesture.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style:const TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 20,
            ),
            GridView(
              padding:const EdgeInsets.all(10),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                MarkAttendance(),
                PercentageGesture(),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.notifications, size: 60),
                      Text(
                        'Notifications',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:const <Widget>[
                      Icon(Icons.more_horiz, size: 60),
                      Text(
                        'More',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
    );
  }
}
