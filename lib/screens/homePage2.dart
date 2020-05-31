import 'package:flutter/material.dart';
import 'package:online_attendance_register/screens/utils/alertDialog.dart';
import './tabs/NotificationsTab.dart';
import './tabs/homeTab.dart';
import './tabs/profilesTab.dart';

class MainHomePage extends StatefulWidget {
  static String routeName = '/mainhome';

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  List<String> appbarTitle = ['Home', 'Notifications', 'Profile'];
  final List<Widget> _children = [
    HomeTab(),
    NotificationTab(),
    ProfileScreen()
  ];
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlerttBox(
                        'About',
                        'Version: 1.0.0',
                        FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Ok'))));
              })
        ],
        title: Text(appbarTitle[_currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                title: const Text('Home'),
                icon: Icon(
                  Icons.check_box_outline_blank,
                  color: _currentIndex == 0 ? Colors.blue : Colors.black,
                )),
            BottomNavigationBarItem(
                title: const Text('Notifications'),
                icon: Icon(
                  Icons.notifications_none,
                  color: _currentIndex == 1 ? Colors.blue : Colors.black,
                )),
            BottomNavigationBarItem(
                title: const Text('Profile'),
                icon: Icon(
                  Icons.person_outline,
                  color: _currentIndex == 2 ? Colors.blue : Colors.black,
                )),
          ]),
    );
  }
}
