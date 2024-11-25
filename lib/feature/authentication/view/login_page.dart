import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/widget/login_button.dart';
import 'package:medicine_reminder/core/widget/login_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoginContainer(
              labelText: "Email",
              controller: emailController,
            ),
            SizedBox(
              height: 10,
            ),
            LoginContainer(
              controller: passwordController,
              labelText: "Password",
              isPassword: true,
            ),
            SizedBox(height: 10,),
            LoginButton(onPressed: (){}, text: "LOGIN")
          ],
        ),
      ),
    );
  }
}
