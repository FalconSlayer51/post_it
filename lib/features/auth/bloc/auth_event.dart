part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnSignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const OnSignUpRequested({
    required this.username,
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [email, password];
}

class OnLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const OnLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class OnLogOutRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class OnUserSignedIn extends AuthEvent {
  @override
  List<Object> get props => [];
}

class OnUserNotSignedIn extends AuthEvent {
  @override
  List<Object> get props => [];
}

class OnUserVerified extends AuthEvent {
  @override
  List<Object> get props => [];
}

class OnUserNotVerified extends AuthEvent {
  @override
  List<Object> get props => [];
}
