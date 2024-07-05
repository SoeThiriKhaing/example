import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:soe/auth/auth_firebase.dart';
import 'package:soe/employer/home.dart';
import 'package:soe/job/register.dart';
import 'package:soe/seeker/home.dart';
import "package:url_launcher/url_launcher.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class RegisterFormUI extends StatefulWidget {
  static const Color navyColor = Color(0xFF000080);
  const RegisterFormUI({super.key});

  @override
  RegisterFormUIState createState() => RegisterFormUIState();
}

class RegisterFormUIState extends State<RegisterFormUI> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeToPrivacyPolicy = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'Job Seeker';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Future<User?> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       return null;
  //     }
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     return userCredential.user;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

//Facebook////////////
  final String facebookUrl = 'https://www.facebook.com';

  Future<void> _launchURL() async {
    if (await canLaunch(facebookUrl)) {
      await launch(facebookUrl);
    } else {
      throw 'Could not launch $facebookUrl';
    }
  }

  void register() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text.trim(),
        'role': selectedRole,
      });

      // Navigate to the appropriate screen based on role
      if (selectedRole == 'Job Seeker') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeekerHome()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployerHome()),
        );
      }
    } catch (e) {
      print(e);
      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: RegisterForm.navyColor))),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: RegisterForm.navyColor)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _agreeToPrivacyPolicy,
                    onChanged: (value) {
                      setState(() {
                        _agreeToPrivacyPolicy = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreeToPrivacyPolicy = !_agreeToPrivacyPolicy;
                      });
                    },
                    child: const Text("I agree to Privacy Policy"),
                  ),
                ],
              ),
           
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedRole,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 32.0,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      items: <String>['Job Seeker', 'Employer']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: screenWidth,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_formKey.currentState!.validate() &&
                                  _agreeToPrivacyPolicy) {
                                print("Email is ${emailController.text}");
                                print(
                                    "Password is ${passwordController.text.toString()}");
                                await Auth().createUserWithEmailAndPassword(
                                    email: emailController.text.toString(),
                                    password:
                                        passwordController.text.toString(),
                                    role: selectedRole);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Registration Successful')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please fill all fields and agree to the privacy policy and consent to the collection and use of my personal as described')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to register: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RegisterForm.navyColor,
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text("Or",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: screenWidth,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // User? user = await _signInWithGoogle();
                            // if (user != null) {
                            //   if (kDebugMode) {
                            //     print("Sign in as ${user.displayName}");
                            //   }
                            // }

                            // // Continue with Google
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
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: screenWidth,
                        child: OutlinedButton.icon(
                          onPressed: _launchURL,
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
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: SizedBox(
                    //     width: screenWidth,
                    //     child: OutlinedButton.icon(
                    //       onPressed: () {
                    //         // Continue with Instagram
                    //       },
                    //       icon: const Icon(
                    //         FontAwesomeIcons.instagram,
                    //         color: Colors.pink,
                    //       ),
                    //       label: const Text(
                    //         'Continue with Instagram',
                    //         style: TextStyle(color: RegisterForm.navyColor),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// signup()  {
//     print(_emailController.text.toString());
//     print(_passwordController.text.toString());
//      Auth().createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
//   }
}
