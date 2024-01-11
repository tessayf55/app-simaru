import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/login_screen.dart';
import 'package:appssimaru/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class BookingAddScreen extends StatefulWidget {
  const BookingAddScreen({Key? key}) : super(key: key);

  @override
  State<BookingAddScreen> createState() => _BookingAddScreenState();
}

class _BookingAddScreenState extends State<BookingAddScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController ruanganIdController = TextEditingController();
  TextEditingController? startBookController;
  TextEditingController? endBookController;
  final ApiClient _apiClient = ApiClient();
  String accessToken = '';
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _loadToken();
    startBookController = TextEditingController();
    endBookController = TextEditingController();

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

  Future<void> addBooking() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      Map<String, dynamic> bookingData = {
        "user_id": userIdController.text,
        "ruangan_id": ruanganIdController.text,
        "start_book": startBookController!.text,
        "end_book": endBookController!.text,
      };

      final res = await _apiClient.addBooking(accessToken, bookingData);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res.statusCode == 200 || res.statusCode == 201) {
        var msg = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg['message'].toString()),
          backgroundColor: Colors.green.shade300,
        ));
        Navigator.pop(_scaffoldState.currentState!.context);
      } else if (res.statusCode == 401) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      await _selectTime(context, controller, picked);
    }
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, DateTime selectedDate) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      DateTime selectedDateTime = DateTime(selectedDate.year,
          selectedDate.month, selectedDate.day, picked.hour, picked.minute);
      controller.text = selectedDateTime.toIso8601String();
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
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          "Tambah Booking",
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
                        controller: userIdController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "User ID",
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
                        controller: ruanganIdController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Ruangan ID",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: startBookController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Start Booking",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          await _selectDate(context, startBookController!);
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: endBookController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "End Booking",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          await _selectDate(context, endBookController!);
                        },
                      ),
                      SizedBox(height: size.height * 0.06),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: addBooking,
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
                            "Save",
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
