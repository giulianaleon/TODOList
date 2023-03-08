import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthNotifier with ChangeNotifier{
  User? _user;

  User? get user => _user;

  void setupUser(User? user){
    _user = user;
    notifyListeners();
  }
}