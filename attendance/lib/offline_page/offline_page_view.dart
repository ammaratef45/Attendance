import 'package:flutter/material.dart';
import './offline_page_viewmodel.dart';

class OfflinePageView extends OfflinePageViewModel {

  @override
  showMessageDialog(String title, String message) {
    showDialog(
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
          onTap: (){
            
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.blue),
            alignment: Alignment(0, 0),
            child: Row(
              children: <Widget>[
                Text(
                  scanedList[index].toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                  ),
                ),
                RaisedButton(
                  child: Text("Leave"),
                  onPressed: null,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.0),
                ),
                RaisedButton(
                  child: Text("Done"),
                  onPressed: null,
                ),
              ],
            )
          ),
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
        itemBuilder: (BuildContext ctxt, int index) => buildBody(ctxt, index)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        tooltip: 'Add',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }
  
}