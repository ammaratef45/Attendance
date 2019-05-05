import 'package:attendance/AttendanceDatailsPage/attendance_details_page_viewmodel.dart';
import 'package:flutter/material.dart';

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
            Text(widget.model.className),
            Text(widget.model.date),
            Text('Arrived: ${widget.model.arriveDate}'),
            Visibility(
              child: Text('Leaved: ${widget.model.leaveDate}'),
              visible: widget.model.isLeaved(),
            ),
            Visibility(
              child: RaisedButton(
                child: const Text('Scan For Leaving'),
                onPressed: scan,
              ),
              visible: !widget.model.isLeaved(),
            ),
          ],
        ),
      ),
    );

}
