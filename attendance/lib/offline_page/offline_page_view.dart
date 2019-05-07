import 'package:attendance/offline_page/offline_page_viewmodel.dart';
import 'package:flutter/material.dart';

/// offline scanning page
class OfflinePageView extends OfflinePageViewModel {

  @override
  void showMessageDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
        AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  
                });
              },
            ),
          ],
        ),
    );
  }

  Widget _buildBody(BuildContext ctxt, int index) =>
    Center(
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: GestureDetector(
          onTap: (){
            
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.blue),
            alignment: const Alignment(0, 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        scanedList[index].arriveTimePart(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      ),
                    ),
                    Flexible(
                      child: Visibility(
                        child: RaisedButton(
                          child: const Text('Leave'),
                          onPressed: (){
                            scanLeave(index);
                          },
                        ),
                        visible: scanedList[index].leave==null,
                      ),
                    ),
                    Flexible(
                      child: Visibility(
                        child: Text(scanedList[index].leaveTimePart()),
                        visible: scanedList[index].leave!=null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: const Text('Delete'),
                      onPressed: ()=>deleteItem(index),
                    ),
                    RaisedButton(
                      child: const Text('Test'),
                      onPressed: testConnection,
                    ),
                    RaisedButton(
                      child: const Text('Register'),
                      onPressed: ()=>registerMe(index),
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: const Text('Offline'),
      ),
      body: ListView.builder(
        itemCount: scanedList.length,
        itemBuilder: _buildBody
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        tooltip: 'Add',
        child: const Icon(Icons.add),
        elevation: 2,
      ),
    );
  
}