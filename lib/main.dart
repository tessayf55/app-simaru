import 'package:flutter/material.dart';
import 'package:appssimaru/screens/register.dart';

import 'screens/home_page.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMARU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterScreen(),
      //home: const LoginScreen(),
      //home: const HomePage(),
    );
  }
}
