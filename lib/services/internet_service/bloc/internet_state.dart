part of 'internet_bloc.dart';

@immutable
abstract class InternetState extends Equatable{}

class InternetInitial extends InternetState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ConnectedState extends InternetState {
  final String message;
  ConnectedState({
    required this.message,
  });
  
  @override
  List<Object?> get props => [];
}

class NotConnectedState extends InternetState {
  final String message;
  NotConnectedState({
    required this.message,
  });
  
  @override
  List<Object?> get props => [];
}
