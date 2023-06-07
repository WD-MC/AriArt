import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:ariart/pageAuth/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ariart/pageAuth/services/database.dart';

class AuthenticationService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

 
  AppUser? _userFromFirebaseUser(User? user) {
    return user == null ? null : AppUser(uid: user.uid);
  }

  Stream<AppUser?> get user {
      return _auth.authStateChanges().map(_userFromFirebaseUser);
  }
  

  Future signInWithEmailAndPassword(String email, String password)async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String name, String number, String email, String password)async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
      
      User? user = result.user;
      
      await DatabaseService(uid: user!.uid).saveUser(name, number);

      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signOut()async{
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

}
  
