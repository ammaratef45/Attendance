import './home_page_viewmodel.dart';
import 'package:flutter/material.dart';
import '../model/attend_model.dart';

class HomePageView extends HomePageViewModel{

  Widget buildBody(BuildContext ctxt, int index, bool filterForUnLeaved) {
    AttendModel model = filterForUnLeaved?uitems[index]:litems[index];
    Widget result = new Center(
      child: new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: new GestureDetector(
          onTap: () => openDetails(model),
          child: new Container(
            decoration: BoxDecoration(color: Colors.blue),
            alignment: Alignment(0, 0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.className,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                  ),
                ),
                Text(
                  model.date,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.access_time)),
                  Tab(icon: Icon(Icons.all_inclusive)),
                  Tab(icon: Icon(Icons.add_circle)),
                ],
          ),
          title: Text("Home"),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: uitems.length,
              itemBuilder: (BuildContext ctxt, int index) => buildBody(ctxt, index, true)
            ),
            ListView.builder(
              itemCount: litems.length,
              itemBuilder: (BuildContext ctxt, int index) => buildBody(ctxt, index, false)
            ),
            Center(
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
                          scan();
                        },
                        child: const Text('START CAMERA SCAN')
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(scanResult, textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}