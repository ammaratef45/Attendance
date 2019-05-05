import 'package:attendance/AttendanceDatailsPage/attendance_details_page.dart';
import 'package:attendance/ProfilePage/profile_page.dart';
import 'package:attendance/homePage/home_page.dart';
import 'package:attendance/loginPage/login_page.dart';
import 'package:attendance/offline_page/offline_page.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

/// The Application class
class MyApp extends StatelessWidget {
  final Widget _myHome = LoginPage();

  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      title: 'Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _myHome,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
        '/details': (BuildContext context) => const AttendanceDetailsPage(),
        '/offline': (BuildContext context) => OfflinePage(),
        '/profile': (BuildContext context) => const ProfilePage()
      },
    );

}
