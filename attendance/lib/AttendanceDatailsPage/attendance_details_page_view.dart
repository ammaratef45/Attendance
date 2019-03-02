import 'package:flutter/material.dart';
import './attendance_details_page_viewmodel.dart';

class AttendanceDetailsPageView extends AttendanceDetailsPageViewModel {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0)
            ),
            Text(className),
            Text(session),
            Text(arriveDate),
            Visibility(
              child: Text(leaveDate),
              visible: isLeaved,
            ),
            Visibility(
              child: RaisedButton(
                child: Text("Scan For Leaving"),
                onPressed: scan,
              ),
              visible: !isLeaved,
            ),
          ],
        ),
      ),
    );
  }
}
