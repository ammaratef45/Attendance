import 'package:flutter/material.dart';
import './attendance_details_page_viewmodel.dart';

/// view of attendance page
class AttendanceDetailsPageView extends AttendanceDetailsPageViewModel {

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10)
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
                child: const Text('Scan For Leaving'),
                onPressed: scan,
              ),
              visible: !isLeaved,
            ),
          ],
        ),
      ),
    );

}
