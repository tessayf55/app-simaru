import 'package:flutter/material.dart';
import 'package:appssimaru/model/ruangan.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/ruangan/ruangan_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RuanganDetailScreen extends StatefulWidget {
  Ruangan ruangan;
  RuanganDetailScreen({required this.ruangan});

  @override
  _RuanganDetailScreenState createState() =>
      _RuanganDetailScreenState(this.ruangan);
}

class _RuanganDetailScreenState extends State<RuanganDetailScreen> {
  final ApiClient _apiClient = ApiClient();
  final Ruangan ruangan;
  _RuanganDetailScreenState(this.ruangan);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 182, 182),
      appBar: AppBar(
        title: Text('Detail Ruangan'),
        backgroundColor: Color(0xff151515),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Card(
            elevation: 4.0,
            color: Colors.blue[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${ruangan.id}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${ruangan.nama_ruangan}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "${ruangan.kapasitas}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Date of Birth: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${ruangan.keterangan}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
