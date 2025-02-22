import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/login_screen.dart';
import 'package:appssimaru/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class RuanganAddScreen extends StatefulWidget {
  const RuanganAddScreen({Key? key}) : super(key: key);

  @override
  State<RuanganAddScreen> createState() => _RuanganAddScreenState();
}

class _RuanganAddScreenState extends State<RuanganAddScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController ruanganController = TextEditingController();
  final TextEditingController kapasitasController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  String accessToken = '';
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _loadToken();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _fadeInAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();
  }

  _loadToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('accessToken');

    if (data != null) {
      setState(() {
        accessToken = data;
      });
    }
  }

  Future<void> addRuangan() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      Map<String, dynamic> ruanganData = {
        "nama_ruangan": ruanganController.text,
        "kapasitas": kapasitasController.text,
        "keterangan": keteranganController.text,
      };

      final res = await _apiClient.addRuangan(accessToken, ruanganData);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res.statusCode == 200 || res.statusCode == 201) {
        var msg = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg['message'].toString()),
          backgroundColor: Colors.green.shade300,
        ));

        // Sinyalkan ke RuanganScreen bahwa penambahan berhasil
        Navigator.pop(_scaffoldState.currentState!.context, true);
      } else if (res.statusCode == 401) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (res.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Error: Internal Server Error 500'),
          backgroundColor: Colors.red.shade300,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res.body.toString()}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.blueGrey[200],
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.85,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          "Tambah Ruangan",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        validator: (value) =>
                            Validator.validateText(value ?? ""),
                        controller: ruanganController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Nama Ruangan",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: kapasitasController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Kapasitas Ruangan",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        validator: (value) =>
                            Validator.validateText(value ?? ""),
                        controller: keteranganController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Keterangan",
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
                          onPressed: addRuangan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
    );
  }
}
