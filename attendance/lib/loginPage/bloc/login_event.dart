import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class LoginPressed extends LoginEvent {}
