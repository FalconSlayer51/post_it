import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:twit_clone/features/auth/bloc/auth_bloc.dart';
part 'emil_verification_event.dart';
part 'emil_verification_state.dart';

class EmilVerificationBloc
    extends Bloc<EmilVerificationEvent, EmilVerificationState> {
  final auth = FirebaseAuth.instance;
  StreamSubscription? subscription;
  EmilVerificationBloc() : super(EmilVerificationInitial()) {
    on<OnEmailVerified>((event, emit) {
      emit(EmailVerifiedState());
    });
    on<OnEmailNotVerified>((event, emit) {
      emit(EmailNotVerifiedState());
    });

    subscription = auth.authStateChanges().listen((event) {


      if (event!.emailVerified) {
        add(OnEmailVerified());
      } else {
        add(OnEmailNotVerified());
      }
    });
  }
}
