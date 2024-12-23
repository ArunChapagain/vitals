import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/widgets/my_button.dart';
import 'package:vitals/widgets/my_text_field.dart';
import 'package:vitals/widgets/squre_tile.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
//text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

// sign user in method
  void signUp() async {
    FocusScope.of(context).unfocus();

    final provider = Provider.of<ProviderAuth>(context, listen: false);
    final error = await provider.registerWithEmail(
      usernameController.text,
      passwordController.text,
      confirmPasswordController.text,
    );

    // if (!mounted) return;
    // Navigator.pop(context);

    if (error != null) {
      wrongCredentialMessage(error);
    }
  }

  void wrongCredentialMessage(String message) {
    final provider = Provider.of<ProviderAuth>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: Text(provider.getErrorMessage(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.grey[800]),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  //logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //welcome text
                  Text(
                    'Let\'s Get Started',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //text fields
                  MyTextField(
                    isPasswordTextField: false,
                    hintText: 'Username',
                    controller: usernameController,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextField(
                    isPasswordTextField: true,
                    hintText: 'Password',
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //confirm password
                  MyTextField(
                    isPasswordTextField: true,
                    hintText: 'confirm password',
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //login button
                  MyButton(
                    text: 'Sign Up',
                    ontap: signUp,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //google + apple sign in
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SquareTile(
                      onTap: () {
                        final provider =
                            Provider.of<ProviderAuth>(context, listen: false);
                        provider.signInWithGoogle();
                      },
                      imgUrl: 'assets/images/auth/google.png'),
                  const SizedBox(
                    height: 20,
                  ),
                  //not a member? sign up
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      'Already member?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: widget.onTap,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
