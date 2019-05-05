import 'package:attendance/AttendancePage/attendance_page_viewmodel.dart';
import 'package:flutter/material.dart';

/// view of attendance page
class AttendancePageView extends AttendancePageViewModel {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {},
                    child: const Text('START CAMERA SCAN')),
              ),
            ],
          ),
        ),
      );
}
