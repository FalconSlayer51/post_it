import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twit_clone/features/auth/bloc/auth_bloc.dart';
import 'package:twit_clone/features/auth/screens/login_screen.dart';
import 'package:twit_clone/main.dart';
import 'package:twit_clone/widgets/helpers.dart';

class EmailAuthScreen extends StatefulWidget {
  static Route getRoute() => MaterialPageRoute(
        builder: (context) => const EmailAuthScreen(),
      );
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  void signUp(
      BuildContext context, String email, String password, String username) {
    BlocProvider.of<AuthBloc>(context).add(
      OnSignUpRequested(email: email, password: password, username: username),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController2 = TextEditingController();
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
            context,
            MyHomeScreen.getRoute(),
            (_) => false,
          );
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
                  height: 35,
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'username',
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
                TextField(
                  controller: passwordController2,
                  decoration: const InputDecoration(
                    labelText: 're-enter your password',
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
                    if (passwordController.text.trim() ==
                        passwordController2.text.trim()) {
                      signUp(
                        context,
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        usernameController.text.trim(),
                      );
                    } else {
                      showSnackbar(
                        context: context,
                        color: Colors.amber,
                        text: 'both passwords must be same',
                      );
                    }
                    emailController.text = usernameController.text =
                        passwordController.text = passwordController2.text = '';
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: const Text(
                    'Already have an account?',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context, LoginScreen.getRoute());
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
