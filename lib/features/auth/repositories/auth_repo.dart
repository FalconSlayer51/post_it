import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twit_clone/widgets/helpers.dart';

abstract class IAuthRepo {
  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  });

  Future<void> loginWithEmailandPassword({
    required String email,
    required String password,
    required BuildContext context,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();
}

class AuthRepository implements IAuthRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> logOut() async {
    await Future.wait([auth.signOut()]);
  }

  @override
  Future<void> loginWithEmailandPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(
        context: context,
        color: Colors.red,
        text: e.toString(),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      
      throw Exception(e.toString());
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    try{
      await auth.currentUser!.sendEmailVerification();
    }catch(e){
      log(e.toString());
    }
  }
}
