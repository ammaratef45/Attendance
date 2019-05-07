import 'package:attendance/anim/fade_in.dart';
import 'package:attendance/loginPage/login_page_viewmodel.dart';
import 'package:flutter/material.dart';

/// view of login page
class LoginPageView extends LoginPageViewModel {
  @override
  Widget build(BuildContext context) =>
    Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: SafeArea(
            child: ListView(
              children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeIn(
                          child: Text(
                            'Welcome,',
                            style: TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                          delay: 1000,
                        ),
                        FadeIn(
                          child: Container(
                            child: Text(
                              "Let's get you in..",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 35),
                            ),
                            padding: const EdgeInsets.only(top: 25),
                          ),
                          delay: 1500,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.only(left: 15, top: 130),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 120),
                      child: Center(
                        child: RaisedButton(
                            padding:
                            const EdgeInsets.only(top: 3, bottom: 3, left: 6),
                            color: const Color(0xFFFFFFFF),
                            onPressed: () =>
                                signInUser()
                                    .then(handleUser),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/g-logo.png',
                                  fit: BoxFit.fill,
                                  height: 40,
                                ),
                                Container(
                                    padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                    child: Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            )),
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'Having troubles?',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: OutlineButton(
                          child: const Text('Go offline'),
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/offline'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  )
                ])
              ],
            )));
}
