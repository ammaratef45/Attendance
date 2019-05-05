import 'package:attendance/AttendanceDatailsPage/attendance_details_page.dart';
import 'package:attendance/ProfilePage/profile_page.dart';
import 'package:attendance/homePage/home_page.dart';
import 'package:attendance/loginPage/login_page.dart';
import 'package:attendance/offline_page/offline_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance/user_repository.dart';
import 'package:attendance/authentication_bloc/bloc.dart';

void main() => runApp(MyApp());

/// The Application class
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository)
      ..dispatch(AppStarted());
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        title: 'Attendance',
        home: _RootPage(userRepository: _userRepository),
        onGenerateRoute: _getRoute,
        routes: <String, WidgetBuilder>{
          '/offline': (BuildContext context) => OfflinePage(),
          '/profile': (BuildContext context) => const ProfilePage()
        },
      ),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/details':
        return _buildRoute(settings, AttendanceDetailsPage(settings.arguments));
    }
    return null;
  }

  MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget builder,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext ctx) => builder,
    );
  }
}

class _RootPage extends StatelessWidget {
  const _RootPage({Key key, this.userRepository}) : super(key: key);

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState state) {
        if (state is Authenticated) {
          return HomePage();
        } else {
          return LoginPage(userRepository: userRepository);
        }
      },
    );
  }
}
