import 'package:attendance/AttendanceDatailsPage/attendance_details_page_view.dart';
import 'package:attendance/backend/attendance.dart';
import 'package:flutter/material.dart';

/// attendance details page
class AttendanceDetailsPage extends StatefulWidget {
  /// constructor
  AttendanceDetailsPage(this._attendance);

  final Attendance _attendance;
  /// get the attendance model.
  Attendance get model => _attendance;

  @override
  AttendanceDetailsPageView createState() => AttendanceDetailsPageView();
}