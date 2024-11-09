import 'package:blog/components/button.dart';
import 'package:blog/components/text_format.dart';
import 'package:blog/components/textfield_styling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'LoginPage';
  final Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();

  final password = TextEditingController();

  signIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      displayErrorMsg(e.code);
    }
  }

  displayErrorMsg(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: PoppinsText(
          textAlign: TextAlign.center,
          text: msg,
          fontWeight: FontWeight.w400,
          fontS: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/blog-ic.json",
              ),
              SizedBox(
                height: 12,
              ),
              CustomTextField(
                labelText: 'Enter your email',
                controller: email,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                labelText: 'Enter your Password',
                controller: password,
                isObscureText: true,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: KButton(
                  label: 'Sign in',
                  onPressed: signIn,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PoppinsText(text: 'Not a member?'),
                  TextButton(
                      onPressed: widget.onTap,
                      child: const PoppinsText(
                        text: 'Register Now!',
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
