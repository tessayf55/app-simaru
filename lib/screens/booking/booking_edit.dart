import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appssimaru/model/booking.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appssimaru/utils/validator.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class BookingEditScreen extends StatefulWidget {
  final Booking booking;

  BookingEditScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingEditScreen> createState() => _BookingEditScreenState();
}

class _BookingEditScreenState extends State<BookingEditScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController ruanganIdController = TextEditingController();
  TextEditingController startBookController = TextEditingController();
  TextEditingController endBookController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  String accessToken = '';
  int id = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    userIdController.text = widget.booking.userId.toString();
    ruanganIdController.text = widget.booking.ruanganId.toString();
    startBookController.text = widget.booking.startBook.toIso8601String();
    endBookController.text = widget.booking.endBook.toIso8601String();
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

  Future<void> updateBooking() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      Map<String, dynamic> bookingData = {
        "user_id": widget.booking.userId,
        "ruangan_id": widget.booking.ruanganId,
        "start_book": startBookController.text,
        "end_book": endBookController.text,
      };

      final res = await _apiClient.updateBooking(
          accessToken, bookingData, widget.booking.id);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res.statusCode == 200 || res.statusCode == 201) {
        var msg = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg['message'].toString()),
          backgroundColor: Colors.green.shade300,
        ));

        // Sinyalkan ke BookingScreen bahwa edit berhasil
        Navigator.pop(context, true);
      } else if (res.statusCode == 401) {
        // Handle unauthorized access
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
    if (picked != null) {
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

  void _onUserIdChanged(String value) {
    setState(() {
      widget.booking.userId = int.parse(value);
    });
  }

  void _onRuanganIdChanged(String value) {
    setState(() {
      widget.booking.ruanganId = int.parse(value);
    });
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
                          "Edit Booking",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextFormField(
                        validator: (value) =>
                            Validator.validateText(value ?? ""),
                        controller: userIdController,
                        keyboardType: TextInputType.number,
                        onChanged: _onUserIdChanged,
                        decoration: InputDecoration(
                          labelText: "User ID",
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
                        keyboardType: TextInputType.number,
                        onChanged: _onRuanganIdChanged,
                        decoration: InputDecoration(
                          labelText: "Ruangan ID",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      // TextFormField for Start Booking
                      TextFormField(
                        controller: startBookController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Start Book",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          await _selectDate(context, startBookController);
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      // TextFormField for End Booking
                      TextFormField(
                        controller: endBookController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "End Book",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          await _selectDate(context, endBookController);
                        },
                      ),
                      SizedBox(height: size.height * 0.06),
                      // ElevatedButton for Save
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: updateBooking,
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
