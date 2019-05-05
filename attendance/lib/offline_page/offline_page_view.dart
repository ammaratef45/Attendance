import 'package:flutter/material.dart';
import './offline_page_viewmodel.dart';

class OfflinePageView extends OfflinePageViewModel {
  @override
  void showMessageDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildBody(BuildContext ctxt, int index) {
    Widget result = Center(
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: GestureDetector(
          onTap: () {},
          child: Container(
              decoration: BoxDecoration(color: Colors.blue),
              alignment: Alignment(0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          scanedList[index].arriveTimePart(),
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                      Flexible(
                        child: Visibility(
                          child: RaisedButton(
                            child: Text("Leave"),
                            onPressed: () {
                              scanLeave(index);
                            },
                          ),
                          visible: scanedList[index].leave == null,
                        ),
                      ),
                      Flexible(
                        child: Visibility(
                          child: Text(scanedList[index].leaveTimePart()),
                          visible: scanedList[index].leave != null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Delete"),
                        onPressed: () => deleteItem(index),
                      ),
                      RaisedButton(
                        child: Text("Test"),
                        onPressed: testConnection,
                      ),
                      RaisedButton(
                        child: Text("Register"),
                        onPressed: () => registerMe(index),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline"),
      ),
      body: new ListView.builder(
          itemCount: scanedList.length,
          itemBuilder: (BuildContext ctxt, int index) =>
              buildBody(ctxt, index)),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        tooltip: 'Add',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }
}
