import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:attendance/authentication_bloc/bloc.dart';
import 'package:attendance/user_repository.dart';

/// Bloc Responsible for managing the Authentication State of the Application
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// Constructor
  AuthenticationBloc({@required this.userRepository});

  /// UserRepository instance
  final UserRepository userRepository;

  @override
  AuthenticationState get initialState => Unauthenticated();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield await userRepository.isSignedIn() == true
          ? Authenticated()
          : Unauthenticated();
    }
  }
}
