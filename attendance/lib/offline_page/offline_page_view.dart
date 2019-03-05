import 'package:flutter/material.dart';
import './offline_page_viewmodel.dart';

class OfflinePageView extends OfflinePageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline"),
      ),
      body: Text("papapa"),
    );
  }
  
}