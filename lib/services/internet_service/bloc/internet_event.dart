part of 'internet_bloc.dart';

@immutable
abstract class InternetEvent extends Equatable {}

class OnConnected extends InternetEvent {
  @override
  List<Object?> get props => [];
}

class OnNotConnected extends InternetEvent {
  @override
  List<Object?> get props => [];
}
