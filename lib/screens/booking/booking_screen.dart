import 'package:flutter/material.dart';
import 'package:appssimaru/model/booking.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking_add.dart';
import 'booking_edit.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  String accessToken = '';
  List<Booking> bookings = [];
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _loadToken();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

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

  Future<List<Booking>> _getBookingData() async {
    try {
      final response = await _apiClient.getBookingData(accessToken);

      if (response.isNotEmpty) {
        return response;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _addBooking(Map<String, dynamic>? data) async {
    try {
      final response = await _apiClient.addBooking(accessToken, data);
      // Handle response if needed
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _deleteBooking(int id, int index) async {
    try {
      final response = await _apiClient.delBooking(accessToken, id);

      if (response) {
        setState(() {
          // Remove the item from the list
          bookings.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Hapus data berhasil"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Hapus data gagal"),
        ));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _updateBooking(Map<String, dynamic>? data, int id) async {
    try {
      final response = await _apiClient.updateBooking(accessToken, data, id);

      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Edit data berhasil"),
        ));

        // Refresh the screen after editing the booking
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Edit data gagal"),
        ));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget _buildListView(List<Booking> bookings) {
    final dateFormat =
        DateFormat('yyyy-MM-dd'); // Format tanggal yang diinginkan
    final timeFormat = DateFormat('HH:mm'); // Format waktu yang diinginkan
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Booking booking = bookings[index];
          return Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8), // Tambahkan jarak di sini
                  Text(
                    "User ID : ${booking.userId}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8), // Tambahkan jarak di sini
                  Text("Ruangan ID : ${booking.ruanganId}"),
                  SizedBox(height: 8), // Tambahkan jarak di sini
                  Text(
                    "Start Booking : ${dateFormat.format(booking.startBook)} ${timeFormat.format(booking.startBook)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Tambahkan jarak di sini
                  Text(
                    "End Booking   : ${dateFormat.format(booking.endBook)} ${timeFormat.format(booking.endBook)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16), // Tambahkan jarak di sini
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Konfirmasi Hapus"),
                                content: Text(
                                  "Apakah Anda yakin ingin menghapus User ID ${booking.userId}?",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("Ya"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteBooking(booking.id, index);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Tidak"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(width: 8), // Tambahkan jarak di sini
                      TextButton(
                        onPressed: () async {
                          final editSuccess = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingEditScreen(
                                booking: booking,
                              ),
                            ),
                          );

                          if (editSuccess == true) {
                            // Jika edit berhasil, perbarui tampilan
                            setState(() {});
                          }
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: bookings.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Booking'),
        backgroundColor: Colors.teal, // Updated color to teal
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingAddScreen(),
                  ),
                );

                // Refresh the screen after adding a new booking
                setState(() {});
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Center(
          child: FutureBuilder(
            future: _getBookingData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Booking>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                bookings = snapshot.data ?? [];
                return _buildListView(bookings);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
