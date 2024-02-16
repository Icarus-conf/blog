import 'package:blog/components/button.dart';
import 'package:blog/components/text_format.dart';
import 'package:blog/components/textfield_styling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = 'RegisterPage';
  final Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  final confirmPassword = TextEditingController();

  signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (password.text != confirmPassword.text) {
      Navigator.pop(context);

      displayErrorMsg('Passowrds don\'t match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': username.text,
        'bio': '',
      });

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

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
              CustomTextField(
                labelText: 'Enter your email',
                controller: email,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                labelText: 'Enter your username',
                controller: username,
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
              CustomTextField(
                labelText: 'Confirm your Password',
                controller: confirmPassword,
                isObscureText: true,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: KButton(
                  label: 'Sign Up',
                  onPressed: signUp,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PoppinsText(text: 'Already a member?'),
                  TextButton(
                      onPressed: widget.onTap,
                      child: const PoppinsText(
                        text: 'Login Now!',
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
