import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twit_clone/features/auth/repositories/auth_repo.dart';
import 'dart:developer';

import 'package:twit_clone/widgets/helpers.dart';

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

    on<OnLogOutRequested>((event, emit) {
      handleLogOutEvent(event, emit);
    });

    on<OnGoogleAuthResquested>((event, emit) async {
      await handleGoogleAuth(event, emit);
    });

    on<OnUserSignedIn>((event, emit) {
      emit(AuthenticatedState());
    });

    on<OnUserVerified>((event, emit) {
      emit(UserVerifiedState());
    });

    on<OnUserNotVerified>((event, emit) {
      emit(UserNotVerifiedState());
    });

    on<OnLoginRequested>((event, emit) async {
      await handleLogInEvent(event, emit);
    });

    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event!.uid.isNotEmpty) {
        add(OnUserSignedIn());
      } else {
        add(OnUserNotSignedIn());
      }
    });
  }

  void handleLogOutEvent(
    OnLogOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.logOut();

      emit(UnAuthenticatedState());
    } catch (e) {
      emit(AuthenticatedState());
    }
  }

  Future<void> handleLogInEvent(
    OnLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingState());
    await authRepository
        .loginWithEmailandPassword(
      email: event.email,
      password: event.password,
      context: context,
    )
        .then((value) {
      emit(AuthenticatedState());
    }).catchError((e) {
      log(e.toString());
      try {
        emit(LoginFailedState(errorMessage: e.toString()));
      } catch (e) {
        log("${e.toString()} from catch of emitter");
      }
      log("all are emmitted");
    });
  }

  Future<void> handleGoogleAuth(
    OnGoogleAuthResquested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingState());

    await authRepository
        .signInWithGoogle()
        .then(
          (_) => emit(AuthenticatedState()),
        )
        .catchError(
      (e) {
        log(e.toString());
        emit(UnAuthenticatedState());
        try {
          emit(LoginFailedState(errorMessage: e.toString()));
        } catch (e) {
          log(e.toString() + "from the emitter");
        }
        log('all un authenticated states emitted');
      },
    );
  }

  void handleSignUpEvent(
    OnSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingState());
    // ignore: use_build_context_synchronously
    await authRepository
        .signUp(
      username: event.username,
      context: context,
      email: event.email,
      password: event.password,
    )
        .then((value) {
      emit(AuthenticatedState());
    }).catchError((e) {
      log(e.toString());
      emit(AuthFailedState(errorMessage: e.toString()));
      log('all un authenticated states emitted');
    });
  }
}
