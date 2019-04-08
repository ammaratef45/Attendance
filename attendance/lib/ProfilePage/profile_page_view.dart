import 'package:attendance/BackEnd/user.dart';
import 'package:attendance/ProfilePage/profile_page_viewmodel.dart';
import 'package:flutter/material.dart';

class ProfilePageView extends ProfilePageViewModel {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.lightBlueAccent.withOpacity(0.5)),
              clipper: ClipPainter(),
            ),
            Container(
              child: IconButton(
                  iconSize: 30.0,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              margin: EdgeInsets.only(top: 35.0, left: 8.0),
            ),
            Positioned(
                width: 350.0,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                                Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 3.0, color: Colors.black)
                            ])),
                    SizedBox(height: 60.0),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 30.0),
                              child: Text(
                                nativeNameController.text.isEmpty
                                    ? "Native name (Arabic)"
                                    : User.instance().nativeName,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Container(
                              margin: EdgeInsets.only(left: 30.0),
                              child: Text(
                                phoneNumberController.text.isEmpty
                                    ? "+20 " + "1xxxxxxxxxxx"
                                    : "+20 " + User.instance().phone,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left: 40.0),
                                height: 30.0,
                                width: 70.0,
                                child: OutlineButton(
                                    splashColor: Colors.lightBlueAccent,
                                    borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                                    child: Text(
                                      "Edit",
                                      style:
                                      TextStyle(color: Colors.lightBlueAccent),
                                    ),
                                    onPressed: () =>
                                        popupEditDialog(
                                            nativeNameController,
                                            20,
                                            InputType.TEXT,
                                            TextDirection.RTL),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0)))),
                            SizedBox(height: 25.0),
                            Container(
                                margin: EdgeInsets.only(left: 40.0),
                                height: 30.0,
                                width: 70.0,
                                child: OutlineButton(
                                    splashColor: Colors.lightBlueAccent,
                                    borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                                    child: Text(
                                      "Edit",
                                      style:
                                      TextStyle(color: Colors.lightBlueAccent),
                                    ),
                                    onPressed: () =>
                                        popupEditDialog(
                                            phoneNumberController,
                                            11,
                                            InputType.NUMBER,
                                            TextDirection.LTR),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0)))),
                          ],
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }

  void popupEditDialog(TextEditingController controller, int max,
      InputType type, TextDirection dir) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Container(
              height: 150.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(top: 10.0),
                    child: Theme(
                      data: ThemeData(hintColor: Colors.lightBlueAccent),
                      child: TextField(
                        controller: controller,
                        onChanged: (text) {
                        },
                        keyboardType: type == InputType.NUMBER
                            ? TextInputType.number
                            : TextInputType.text,
                        textAlign: dir == TextDirection.RTL
                            ? TextAlign.right
                            : TextAlign.left,
                        decoration:
                        InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: 30.0,
                      width: 70.0,
                      child: OutlineButton(
                          splashColor: Colors.lightBlueAccent,
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            User.instance().save();

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))))
                ],
              ),
            )));
  }
}

enum InputType { NUMBER, TEXT }
enum TextDirection { RTL, LTR }

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
