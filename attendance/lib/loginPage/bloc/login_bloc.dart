import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:attendance/loginPage/bloc/bloc.dart';
import 'package:attendance/user_repository.dart';

/// Bloc that manages the Login State
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Constructor
  LoginBloc({@required this.userRepository});

  /// Instance of UserRepository
  final UserRepository userRepository;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginPressed) {
      try {
        await userRepository.signInUser();
        yield LoginSuccess();
      } catch (error) {
        print(error);
        yield LoginFailure();
      }
    }
  }
}
