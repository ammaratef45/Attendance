import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance/anim/fade_in.dart';
import 'package:attendance/user_repository.dart';
import 'package:attendance/authentication_bloc/bloc.dart';
import 'package:attendance/loginPage/bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// LoginPage Widget
class LoginPage extends StatefulWidget {
  /// Constructor
  const LoginPage({Key key, this.userRepository}) : super(key: key);

  /// UserRepository instance
  final UserRepository userRepository;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(userRepository: widget.userRepository);
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginEvent, LoginState>(
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state is LoginFailure) {
          Fluttertoast.showToast(
            msg: 'Failed to login',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
          );
        }
        if (state is LoginSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeIn(
                          child: Text(
                            'Welcome,',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          delay: 1000,
                        ),
                        FadeIn(
                          child: Container(
                            child: Text(
                              "Let's get you in..",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 35),
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
                        padding: const EdgeInsets.only(
                          top: 3,
                          bottom: 3,
                          left: 6,
                        ),
                        color: const Color(0xFFFFFFFF),
                        onPressed: () {
                          _loginBloc.dispatch(LoginPressed());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/g-logo.png',
                              fit: BoxFit.fill,
                              height: 40,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 10,
                              ),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        'Having troubles?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: OutlineButton(
                        child: const Text('Go offline'),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/offline'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
