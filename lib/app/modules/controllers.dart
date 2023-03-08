import 'package:agenda/app/modules/constants/schedule_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:status_alert/status_alert.dart';

login (String emailController, String passwordController) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController,
        password: passwordController
    );
    updateCurrentUser();
    if(emailController== "admin@gmail.com")
      Modular.to.pushNamed('/admin');
    else
      Modular.to.pushNamed('/agenda');

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');

    }
  }
}