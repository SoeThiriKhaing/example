import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soe/auth/auth_firebase.dart';
import 'package:soe/auth/firestore.dart';
import 'package:soe/employer/home.dart';
import 'package:soe/job/register.dart';
import 'package:soe/sharepreference.dart';

class LoginForm extends StatefulWidget {
  static const Color navyColor = Color(0xFF000080);

  const LoginForm({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<User?> _signInWithEmailPassword(String email,String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );
  //     await _saveUserData(userCredential.user);
  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     print('Error: ${e.message}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to sign in: ${e.message}')),
  //     );
  //     return null;
  //   }
  // }

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      print('Password reset email sent');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to send password reset email: ${e.message}')),
      );
    }
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google sign in was canceled');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign in was canceled')),
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google authentication failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google authentication failed')),
        );
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await _saveUserData(userCredential.user);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: ${e.message}')),
      );
      return null;
    }
  }

  Future<User?> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken == null) {
          print('Facebook access token is null');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Facebook access token is null')),
          );
          return null;
        }

        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        await _saveUserData(userCredential.user);
        return userCredential.user;
      } else {
        print('Facebook login failed: ${result.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook login failed: ${result.message}')),
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to sign in with Facebook: ${e.message}')),
      );
      return null;
    }
  }

  Future<void> _login() async {
    try {
      print(
          "Login Email is ${_emailController.text} & password is ${_passwordController.text.toString()} ");
      await Auth()
          .signInWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString(),
      )
          .then((_) async {
        var loginUser =
            await AuthStore().getUserRole(_emailController.text.toString());

        if (loginUser != null) {
          var userRole = loginUser.role;

          SharePreferenceData().setRole(userRole);

          if (userRole == "Employer") {
            print("User role value is $userRole  and go to Employeer Page");

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmployerHome()),
            );
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmployerHome()));
          }
          print("Go to jobseeker page");
        }
        return null;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveUserData(User? user) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {'email': user.email, 'password': user.updatePassword("123445")});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LoginForm.navyColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: RegisterForm.navyColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (_emailController.text.isNotEmpty) {
                          await _resetPassword();
                        } else {
                          print('Please enter your email to reset password');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please enter your email to reset password')),
                          );
                        }
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: RegisterForm.navyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: RegisterForm.navyColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: screenWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: RegisterForm.navyColor),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text(
                        'SignIn',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text("Or",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: screenWidth,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        User? user = await _signInWithGoogle();
                        if (user != null) {
                          print(
                              'Successfully signed in with Google: ${user.email}');
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Color.fromARGB(255, 169, 21, 10),
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(color: RegisterForm.navyColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: screenWidth,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        User? user = await _signInWithFacebook();
                        if (user != null) {
                          print(
                              'Successfully signed in with Facebook: ${user.email}');
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                      label: const Text(
                        'Continue with Facebook',
                        style: TextStyle(color: RegisterForm.navyColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
