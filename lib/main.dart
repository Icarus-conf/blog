import 'package:blog/auth/auth.dart';
import 'package:blog/auth/login_or_register.dart';
import 'package:blog/firebase_options.dart';
import 'package:blog/pages/login_page.dart';
import 'package:blog/pages/profile_page.dart';
import 'package:blog/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AuthPage.routeName,
      routes: {
        AuthPage.routeName: (context) => const AuthPage(),
        LoginOrRegister.routeName: (context) => const LoginOrRegister(),
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        ProfilePage.routeName: (context) => const ProfilePage(),
      },
    );
  }
}
