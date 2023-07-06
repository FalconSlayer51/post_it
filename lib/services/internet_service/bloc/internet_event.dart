part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent {}

class OnConnected extends InternetEvent {}

class OnNotConnected extends InternetEvent {}
