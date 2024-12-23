import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class ProviderAuth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<UserCredential?> signInWithGoogle() async {
         try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn(); //begin interactive sign in process


      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication; //obtain the auth details from the request


      final credential = GoogleAuthProvider.credential(  //create a new credential
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //sign in to firebase with the credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Invalid Email';
        case 'wrong-password':
          return 'Invalid Password';
        case 'invalid-email':
          return 'Invalid Email';
        case 'invalid-credential':
          return 'User not found';
        default:
          return 'An error occurred';
      }
    }
  }

  Future<String?> registerWithEmail(
      String email, String password, String confirmPassword) async {
    try {
      if (password != confirmPassword) {
        return 'Passwords do not match';
      }
      await _auth.createUserWithEmailAndPassword(  //create a new user with email and password
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'Password is too weak';
        case 'email-already-in-use':
          return 'Email already exists';
        case 'invalid-email':
          return 'Invalid email';
        default:
          return 'Registration failed';
      }
    }
  }

  String getErrorMessage(String code) {
    switch (code) {
      case 'Invalid Email':
        return 'Please enter a valid email';
      case 'User not found':
        return 'Sign up to create an account';
      case 'Invalid Password':
        return 'Invalid Password';
      case 'Passwords do not match':
        return 'Please make sure your passwords match';
      default:
        return 'An error occurred';
    }
  }

  Future<void> signOut() async {
   try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }
}
