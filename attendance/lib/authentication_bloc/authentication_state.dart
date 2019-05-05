import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}
