import 'package:flutter/material.dart';
import 'package:soe/job/registrationui.dart';

class RegisterForm extends StatelessWidget {
  static const Color navyColor = Color(0xFF000080);
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: navyColor,
        ),
        body: const RegisterFormUI(),
      ),
    );
  }
}
