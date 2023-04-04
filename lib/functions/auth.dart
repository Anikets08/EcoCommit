import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final _auth = FirebaseAuth.instance;
  static final _storage = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return {
        'status': true,
        'message': 'Successfully logged in',
      };
    } on FirebaseException catch (e) {
      return {
        'status': false,
        'message': e.message,
        "errorCode": e.code,
      };
    }
  }

  Future<Map<String, dynamic>> signUp(
      String email, String password, Map<String, dynamic> info) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await _storage.collection('users').doc(email.trim()).set(info);
      return {
        'status': true,
        'message': 'Successfully logged in',
      };
    } on FirebaseException catch (e) {
      return {
        'status': false,
        'message': e.message,
        "errorCode": e.code,
      };
    }
  }

  Future<Object> signOut() async {
    try {
      await _auth.signOut();
      return {
        'status': true,
        'message': 'Successfully logged out',
      };
    } on FirebaseException catch (e) {
      return {
        'status': false,
        'message': e.message,
        "errorCode": e.code,
      };
    }
  }
}
