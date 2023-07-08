import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twit_clone/repositories/auth_repo.dart';
import 'dart:developer';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final BuildContext context;
  StreamSubscription? authSubscriotion;

  AuthBloc({required this.authRepository, required this.context})
      : super(UnAuthenticatedState()) {
    on<OnSignUpRequested>(
      (event, emit) => handleSignUpEvent(event, emit),
    );

    on<OnUserSignedIn>((event, emit) {
      emit(AuthenticatedState());
    });

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event!.uid.isNotEmpty) {
        add(OnUserSignedIn());
      } else {
        add(OnUserNotSignedIn());
      }
    });
  }

  void handleSignUpEvent(
    OnSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingState());
    // ignore: use_build_context_synchronously
    await authRepository
        .signUp(
      context: context,
      email: event.email,
      password: event.password,
    )
        .then((value) {
      emit(AuthenticatedState());
    }).catchError((e) {
      log(e.toString());
      emit(UnAuthenticatedState());
      emit(AuthFailedState(errorMessage: e.toString()));
      log('all un authenticated states emitted');
    });
  }
}
