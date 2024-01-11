import 'package:flutter/material.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/login_screen.dart';
import 'package:appssimaru/utils/validator.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "register_screen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;
  bool _isProcessing = false;

  Future<void> registerUsers() async {
    if (_isProcessing) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.blue.shade300,
      ));

      Map<String, dynamic> userData = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "password_confirmation": passwordConfirmController.text,
        "role": "user",
      };

      try {
        dynamic res = await _apiClient.registerUser(userData);

        _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

        if (res['ErrorCode'] == null) {
          // Pindah ke halaman LoginScreen setelah registrasi berhasil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
            content: Text('Error: ${res['Message']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      } catch (error) {
        print('Error during registration: $error');
        // Handle the error accordingly
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: Colors.blue.shade900,
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
            child: Container(
              width: size.width * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        "Buat Akun Baru",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 13, 71, 161),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    TextFormField(
                      validator: (value) => Validator.validateName(value ?? ""),
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Nama",
                        labelStyle: TextStyle(
                          color: Colors.blue.shade900,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      validator: (value) =>
                          Validator.validateEmail(value ?? ""),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
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
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      obscureText: _showPassword,
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.blue.shade900,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      obscureText: _showPassword,
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      controller: passwordConfirmController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Ulangi Password",
                        labelStyle: TextStyle(
                          color: Colors.blue.shade900,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerUsers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen())),
                        child: const Text(
                          'Sudah punya akun? Masuk',
                          style: TextStyle(
                            color: Color.fromARGB(255, 13, 71, 161),
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
    );
  }
}
