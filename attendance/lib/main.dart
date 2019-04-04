import 'package:flutter/material.dart';

import './AttendanceDatailsPage/attendance_details_page.dart';
import './ProfilePage/profile_page.dart';
import './homePage/home_page.dart';
import './loginPage/login_page.dart';
import './offline_page/offlinine_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final Widget myHome = LoginPage();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Attendance',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: myHome,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginPage(),
        '/home': (BuildContext context) => new HomePage(),
        '/details': (BuildContext context) => new AttendanceDetailsPage(),
        '/offline': (BuildContext context) => new OfflinePage(),
        '/profile': (BuildContext context) => new ProfilePage()
      },
    );
  }
}
