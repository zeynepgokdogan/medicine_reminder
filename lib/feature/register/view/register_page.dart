import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/core/widget/custom_button.dart';
import 'package:medicine_reminder/core/widget/custom_textfield.dart';
import 'package:medicine_reminder/feature/login/view/login_page.dart';
import 'package:medicine_reminder/feature/register/viewmodel/register_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Kayıt Ol',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (viewModel.errorMessage != null)
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  CustomTextField(
                      controller: _nameController, hintText: 'İsim'),
                  CustomTextField(
                      controller: _surnameController, hintText: 'Soyisim'),
                  CustomTextField(
                      controller: _emailController, hintText: 'E-posta'),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    obscureText: true,
                  ),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Şifre',
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          onPressed: () async {
                            if (_passwordController.text ==
                                _confirmPasswordController.text) {
                              await viewModel.register(
                                _nameController.text.trim(),
                                _surnameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              if (viewModel.errorMessage == null) {
                                final userId = viewModel.userId;
                                if (userId != null) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Kullanıcı başarıyla oluşturuldu!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Şifreler eşleşmiyor!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          text: "Hesap Oluştur",
                        ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Hesabınız Var Mı? ',
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
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: AppColors.primaryColor,
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
        ),
      ),
    );
  }
}
