import 'package:attendance/homePage/home_page_viewmodel.dart';
import 'package:attendance/model/attend_model.dart';
import 'package:flutter/material.dart';

/// The view of the home page
class HomePageView extends HomePageViewModel {
  /// build the body of the page
  Widget buildBody(
    BuildContext ctxt,
    int index,
    {bool filterForUnLeaved=false}
  ) {
    final AttendModel model = filterForUnLeaved ? uitems[index] : litems[index];
    final Widget result = Center(
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: GestureDetector(
          onTap: () => openDetails(model),
          child: Container(
            decoration: BoxDecoration(color: Colors.blue),
            alignment: const Alignment(0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.className,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  model.date,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result;
  }

  /// get the tabs
  List<Tab> tabs() {
    final List<Tab> tabs = <Tab>[]
    ..add(const Tab(icon: Icon(Icons.access_time)))
    ..add(const Tab(icon: Icon(Icons.all_inclusive)))
    ..add(const Tab(icon: Icon(Icons.add_circle)));
    return tabs;
  }

  /// get the items of the body
  List<Widget> bodyItems() {
    final List<Widget> widgs = <Widget>[]
    ..add(
      ListView.builder(
        itemCount: uitems.length,
        itemBuilder: (BuildContext ctxt, int index) =>
          buildBody(ctxt, index, filterForUnLeaved: true)
      )
    )
    ..add(
      ListView.builder(
        itemCount: litems.length,
        itemBuilder: (BuildContext ctxt, int index) =>
          buildBody(ctxt, index, filterForUnLeaved: false)
      )
    )
    ..add(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('START CAMERA SCAN')),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Text(
                scanResult,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      )
    );
    return widgs;
  }

  @override
  Widget build(BuildContext context) =>
    DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: tabs(),
              ),
              title: const Text('Home'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(name),
                    accountEmail: Text(mail),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_off),
                    title: const Text('Offline scan'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/offline');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/profile');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: const Icon(Icons.arrow_back),
                    title: const Text('Sign out'),
                    onTap: () {
                      Navigator.pop(context);
                      signOut();
                    },
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: bodyItems(),
            )));

}
