import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twit_clone/features/auth/bloc/auth_bloc.dart';
import 'package:twit_clone/features/auth/screens/email_auth_screen.dart';

import '../../../main.dart';
import '../../../widgets/helpers.dart';

class LandingScreen extends StatefulWidget {
  static Route getRoute() => MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );

  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginFailedState) {
          showSnackbar(
            context: context,
            color: Colors.red,
            text: state.errorMessage,
          );
          return;
        }
        if (state is AuthenticatedState) {
          Navigator.pushAndRemoveUntil(
              context, MyHomeScreen.getRoute(), (_) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'See what\'s happening in the world now\nwith post.it',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  const SizedBox(
                    width: 400,
                    child: Text(
                      'by clicking on the below buttons you can sign into the app',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customButton(
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.black,
                    context: context,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context, EmailAuthScreen.getRoute(), (_) => false);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customButton(
                    child: state is LoadingState
                        ? customLoaoder(context)
                        : const Text(
                            'Sign in with google',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    color: Colors.black,
                    context: context,
                    onPressed: state is LoadingState
                        ? () {}
                        : () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(OnGoogleAuthResquested());
                                setState(() {});
                          },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
