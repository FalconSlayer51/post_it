import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twit_clone/features/auth/screens/email_auth_screen.dart';

import '../../../main.dart';
import '../../../widgets/helpers.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Route getRoute() => MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

  void signIn(BuildContext context, String email, String password)  {
    BlocProvider.of<AuthBloc>(context).add(
      OnLoginRequested(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailedState) {
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
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Post.it',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'email@gmail.com',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: '.............',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                customButton(
                  context: context,
                  child: state is LoadingState
                      ? customLoaoder(context)
                      : const Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                  color: Colors.black,
                  onPressed: () {
                    if (passwordController.text.trim().isEmpty) {
                      showSnackbar(
                        context: context,
                        color: Colors.red,
                        text: 'password should not be empty',
                      );
                      return;
                    }
                    signIn(
                      context,
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    emailController.text = passwordController.text = '';
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: const Text(
                    'Don\'t have an account?',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context, EmailAuthScreen.getRoute());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
