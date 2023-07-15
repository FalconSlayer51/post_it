part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class UnAuthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthFailedState extends AuthState {
  final String errorMessage;
  
  const AuthFailedState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class AuthenticatedState extends AuthState {
  @override
  List<Object> get props => [];
}

class UserVerifiedState extends AuthState {
  @override
  List<Object> get props => [];
}

class UserNotVerifiedState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginFailedState extends AuthState {

  final String errorMessage;
  
  const LoginFailedState({
    required this.errorMessage,
  });
   @override
  List<Object> get props => [];
}


