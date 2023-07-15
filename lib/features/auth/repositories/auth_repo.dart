import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twit_clone/features/auth/model/user_model.dart';

abstract class IAuthRepo {
  Future<void> signUp({
    required String email,
    required String username,
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

  Future<void> signInWithGoogle();
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
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      throw Exception(e.toString());
    });
  }

  @override
  Future<void> signUp({
    required String email,
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await auth.currentUser!.updateDisplayName(username);
      await auth.currentUser!.updatePhotoURL(
        'https://cdn2.vectorstock.com/i/1000x1000/31/86/person-icon-no-photo-vector-8023186.jpg',
      );

      final user = UserModel(
        uid: auth.currentUser!.uid,
        displayName: auth.currentUser!.displayName!,
        photoUrl: auth.currentUser!.photoURL!,
        email: auth.currentUser!.email!,
      );
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(user.toMap());
    }).catchError((e) {
      throw Exception(e.toString());
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await auth.currentUser!.sendEmailVerification();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      User? user = userCredential.user;

      final userData = UserModel(
        uid: user!.uid,
        displayName: user.displayName!,
        photoUrl: user.photoURL!,
        email: user.email!,
      );

      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(userData.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
