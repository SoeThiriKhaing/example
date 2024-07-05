import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soe/usermodel.dart';

class AuthStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//to add user to firestore
  Future<void> addUserToFirestore({
    required String userId,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'password': password,
        'role': role,
      });

      // logger.e("Register success");
      //print("Successful user adding to firestore.");
    } catch (error) {
      // logger.e("Register fail $error");
      //print('Error adding user data to Firestore: $error');
      rethrow;
    }
  }

  Future<UserModel?> getUserRole(String? userEmail) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs[0].data();
        return UserModel(email: data['email'], name: '', role: data['role']);
      } else {
        print('User not found in Firestore');
        return null;
      }
    } catch (error) {
      print('Error retrieving user data: $error');
      return null;
    }
  }
}
