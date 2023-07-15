part of 'emil_verification_bloc.dart';

@immutable
abstract class EmilVerificationEvent {}

class OnEmailVerified extends EmilVerificationEvent {}

class OnEmailNotVerified extends EmilVerificationEvent {}
