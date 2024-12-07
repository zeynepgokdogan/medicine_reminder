import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/widget/custom_button.dart';
import 'package:medicine_reminder/core/widget/custom_textfield.dart';
import 'package:medicine_reminder/feature/login/service/login_service.dart';
import 'package:medicine_reminder/feature/register/view/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObsecure = true;
  void changeObsecure() {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.1),
    
            
    
              SizedBox(height: size.height * 0.001),
    
              // LOGIN TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Medicine Reminder',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 40,
                            ),
                    textAlign: TextAlign.center,
                  ),
                
                ],
              ),
              SizedBox(height: size.height * 0.04),
    
              CustomTextField(
                  controller: mailController, hintText: 'Enter email'),
    
      
    
              CustomTextField(
                controller: passwordController,
                hintText: 'Enter password',
                obscureText: true,
              ),
    
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // FORGOT PASSWORD SAYFASINA YONLENDIR
                    },
                    child: const  Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color:Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
    
              SizedBox(height: size.height * 0.01),
    
              // LOGIN BUTTON
              CustomButton(
                  onPressed: () {
                    logIn(mailController, passwordController, context);
                  },
                  text: 'Log In'),
    
              SizedBox(height: size.height * 0.02),
    
              // ROW (SIGN UP, LOGIN WITH GOOGLE)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
