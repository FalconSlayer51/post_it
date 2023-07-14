part of 'emil_verification_bloc.dart';

@immutable
abstract class EmilVerificationState {}

class EmilVerificationInitial extends EmilVerificationState {}

class EmailNotVerifiedState extends EmilVerificationState {}

class EmailVerifiedState extends EmilVerificationState {}