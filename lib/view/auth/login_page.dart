import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals/provider/provider_auth.dart';
import 'package:vitals/widgets/my_button.dart';
import 'package:vitals/widgets/my_text_field.dart';
import 'package:vitals/widgets/squre_tile.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//text editing controllers
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  void displayCircularProgress() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.blue[300]!,
        ),
      ),
    );
  }

// sign user in method
  void signIn(BuildContext context) async {
    FocusScope.of(context).unfocus();
    displayCircularProgress();

    final provider = Provider.of<ProviderAuth>(context, listen: false);
    final error = await provider.signInWithEmail(
      usernameController.text,
      passwordController.text,
    );

    if (!mounted) return;
    Navigator.pop(context);

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
                    'Welcome Back',
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
                  //forgot password
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //login button
                  MyButton(
                    text: 'Sign In',
                    ontap: () {
                      signIn(context);
                    },
                  ),
                  const SizedBox(
                    height: 30,
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
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SquareTile(
                      onTap: () {
                        displayCircularProgress();
                        final provider =
                            Provider.of<ProviderAuth>(context, listen: false);
                        provider.signInWithGoogle();
                        Navigator.pop(context);
                      },
                      imgUrl: 'assets/images/auth/google.png'),
                  //not a member? sign up
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: widget.onTap,
                      child: const Text(
                        'Sign Up',
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
