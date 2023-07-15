import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twit_clone/features/auth/repositories/auth_repo.dart';
import 'package:twit_clone/widgets/helpers.dart';

class EmailVerificationSceeen extends StatefulWidget {
  final AuthRepository authRepository;
  const EmailVerificationSceeen({super.key, required this.authRepository});

  static Route getRoute({required AuthRepository authRepository}) => MaterialPageRoute(builder: (context) => EmailVerificationSceeen(authRepository: authRepository),);

  @override
  State<EmailVerificationSceeen> createState() => _EmailVerificationSceeenState();
}

class _EmailVerificationSceeenState extends State<EmailVerificationSceeen> {

 late Timer _timer;
  bool isVerificationSent = false;

  @override
  void initState() {
    // TODO: implement initState
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Navigator.pop(context, true);
        setState(() {});
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 140,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Your email is not verified'),
              const SizedBox(
                height: 20,
              ),
              customButton(
                context: context,
                child: const Text(
                  'verify here',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () {
                  widget.authRepository.sendEmailVerification();
                  showSnackbar(context: context, color: Colors.green, text: 'a verification code sent to your email',);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
