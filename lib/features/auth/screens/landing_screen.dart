import 'package:flutter/material.dart';
import 'package:twit_clone/features/auth/screens/email_auth_screen.dart';

import '../../../widgets/helpers.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Navigator.pushAndRemoveUntil(context, EmailAuthScreen.getRoute(),(_)=>false);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              customButton(
                child: const Text(
                  'Sign in with google',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.black,
                context: context,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
