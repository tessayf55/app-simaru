import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/home_page.dart';
import 'package:appssimaru/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _fadeInAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.blue.shade300,
      ));

      final res = await _apiClient.login(
        emailController.text,
        passwordController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res != null) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('accessToken', res['accessToken']);
        localStorage.setString('user', json.encode(res['user']));

        // Animasi untuk pindah ke HomePage
        _animationController.reverse().then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Invalid Credential'),
          backgroundColor: Colors.red.shade400,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Form(
        key: _formKey,
        child: Stack(children: [
          FadeTransition(
            opacity: _fadeInAnimation,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.8,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Center(
                            child: Text(
                              "SIMARU",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 13, 71, 161),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              return Validator.validateEmail(value ?? "");
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Colors.blue.shade900,
                              ),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextFormField(
                            obscureText: _showPassword,
                            controller: passwordController,
                            validator: (value) {
                              return Validator.validatePassword(value ?? "");
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Colors.blue.shade900,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                      () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade900,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Masuk",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Buat Akun",
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
