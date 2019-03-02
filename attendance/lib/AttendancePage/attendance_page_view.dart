import './attendance_page_viewmodel.dart';
import 'package:flutter/material.dart';

class AttendancePageView extends AttendancePageViewModel{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: (){
                    
                  },
                  child: const Text('START CAMERA SCAN')
              ),
            ),
          ],
        ),
      ),
    );
  }
}