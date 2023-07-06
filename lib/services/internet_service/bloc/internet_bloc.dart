import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? subscription;

  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) =>
        emit(NotConnectedState(message: 'Notconnnected to internet')));
    on<OnConnected>((event, emit) {
      emit(ConnectedState(message: 'Connnected to internet'));
    });

    on<OnNotConnected>((event, emit) {
      emit(NotConnectedState(message: 'interenet disconnected'));
    });

    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        add(OnConnected());
      } else {
        add(OnNotConnected());
      }
    });
  }
}
