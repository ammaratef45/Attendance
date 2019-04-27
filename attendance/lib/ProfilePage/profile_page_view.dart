import 'package:attendance/ProfilePage/profile_page_viewmodel.dart';
import 'package:attendance/backend/user.dart';
import 'package:flutter/material.dart';

///Draw the profile page
class ProfilePageView extends ProfilePageViewModel {
  final GlobalKey<FormState> _key = GlobalKey();
  bool _validate = false;

  ///Draw round shadow around the profile pic
  List<BoxShadow> boxShadows() {
    final List<BoxShadow> shadows = <BoxShadow>[]
      ..add(BoxShadow(blurRadius: 3, color: Colors.black));
    return shadows;
  }

  @override
  Widget build(BuildContext context) {
    final BoxDecoration boxDecoration = BoxDecoration(
        color: Colors.blue,
        image:
        DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
        borderRadius: const BorderRadius.all(Radius.circular(75)),
        boxShadow: boxShadows());
    return Scaffold(
        body: Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.lightBlueAccent.withOpacity(0.5)),
              clipper: ClipPainter(),
            ),
            Container(
              child: IconButton(
                  iconSize: 30,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              margin: const EdgeInsets.only(top: 35, left: 8),
            ),
            Positioned(
                width: 350,
                top: MediaQuery
                    .of(context)
                    .size
                    .height / 5,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 150, height: 150, decoration: boxDecoration),
                    const SizedBox(height: 60),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 30),
                              child: Text(
                                nativeNameController.text.isEmpty
                                    ? 'Native name (Arabic)'
                                    : User
                                    .instance()
                                    .nativeName,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              margin: const EdgeInsets.only(left: 30),
                              child: Text(
                                phoneNumberController.text.isEmpty
                                    ? '+20 ' '1xxxxxxxxxxx'
                                    : '+20   ${User
                                    .instance()
                                    .phone}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(left: 40),
                                height: 30,
                                width: 70,
                                child: OutlineButton(
                                    splashColor: Colors.lightBlueAccent,
                                    borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                                    child: Text(
                                      'Edit',
                                      style:
                                      TextStyle(color: Colors.lightBlueAccent),
                                    ),
                                    onPressed: () =>
                                        popupEditDialog(
                                            nativeNameController,
                                            20,
                                            _InputType.text,
                                            _TextDirection.rtl),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20)))),
                            const SizedBox(height: 25),
                            Container(
                                margin: const EdgeInsets.only(left: 40),
                                height: 30,
                                width: 70,
                                child: OutlineButton(
                                    splashColor: Colors.lightBlueAccent,
                                    borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                                    child: Text(
                                      'Edi',
                                      style:
                                      TextStyle(color: Colors.lightBlueAccent),
                                    ),
                                    onPressed: () =>
                                        popupEditDialog(
                                            phoneNumberController,
                                            11,
                                            _InputType.number,
                                            _TextDirection.ltr),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20)))),
                          ],
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }

  ///Controlling dialog
  void popupEditDialog(TextEditingController controller, int max,
      _InputType type, _TextDirection dir) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Container(
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(top: 10),
                    child: Theme(
                        data: ThemeData(hintColor: Colors.lightBlueAccent),
                        child: Form(
                          key: _key,
                          autovalidate: _validate,
                          child: TextFormField(
                            validator: type == _InputType.number
                                ? _phoneValidator
                                : _nameValidator,
                            controller: controller,
                            onSaved: (String text) {},
                            keyboardType: type == _InputType.number
                                ? TextInputType.number
                                : TextInputType.text,
                            textAlign: dir == _TextDirection.rtl
                                ? TextAlign.right
                                : TextAlign.left,
                            decoration:
                            InputDecoration(border: OutlineInputBorder()),
                          ),
                        )),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 30,
                      width: 70,
                      child: OutlineButton(
                          splashColor: Colors.lightBlueAccent,
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                          onPressed: () => _saveValidData,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))))
                ],
              ),
            )));
  }

  String _nameValidator(String name) {
    try {
      User.instance().rename(name);
      return '';
    } on FormatException catch (message) {
      return message.toString();
    }
  }

  String _phoneValidator(String number) {
    try {
      User.instance().changePhone(number);
      return '';
    } on FormatException catch (message) {
      return message.toString();
    }
  }

  void _saveValidData() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      User.instance().save();
      Navigator.pop(context);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}

enum _InputType { number, text }
enum _TextDirection { rtl, ltr }

///Draw background path
class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height / 1.9)..lineTo(size.width + 125, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
