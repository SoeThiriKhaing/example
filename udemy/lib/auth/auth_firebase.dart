import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soe/auth/firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currenUser => _firebaseAuth.currentUser;

  Stream<User?> get authStageChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print("Sign in error is $error");
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (currenUser != null) {
        AuthStore().addUserToFirestore(
          userId: currenUser!.uid,
          email: email,
          password: password,
          role: role,
        );
      }
    } catch (error) {
      print("Sign up error $error");
      rethrow;
    }
  }

  Future<String> getUserName() async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      final String uid = _firebaseAuth.currentUser!.uid;

      final result = await users.doc(uid).get();

      final Map<String, dynamic>? data = result.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('name')) {
        return data['name'].toString();
      } else {
        throw Exception("Display name not found in Firestore data");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      //  logger.e('Sign out success');
    } catch (e) {
      //logger.e('Sign out error $e');
    }
  }
}
