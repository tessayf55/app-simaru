import 'package:appssimaru/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:appssimaru/model/ruangan.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/ruangan/ruangan_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RuanganScreen extends StatefulWidget {
  @override
  _RuanganScreenState createState() => _RuanganScreenState();
}

class _RuanganScreenState extends State<RuanganScreen> {
  final ApiClient _apiClient = ApiClient();
  String accessToken = '';
  List<Ruangan> _ruangan = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
    _getRuangan();
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

  _getRuangan() async {
    await _apiClient.getRuanganData(accessToken).then((Ruangan) {
      if (mounted) {
        setState(() {
          _ruangan = Ruangan;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Master Ruangan'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Row(
                children: [
                  Text(
                    'Hello, ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    accessToken,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Ruangans Data",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              Ruangans(),
            ],
          ),
        ),
      ),
    );
  }

  Table Ruangans() {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      ),
      children: [
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              "ID",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              "FULL NAME",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              "OPTION",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ]),
        for (Ruangan ruangan in _ruangan)
          TableRow(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                "${ruangan.nama_ruangan}",
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                "${ruangan.kapasitas}",
              ),
            ),
            TextButton(
              child: Icon(
                Icons.chevron_right,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RuanganDetailScreen(
                              ruangan: ruangan,
                            )));
              },
            ),
          ]),
      ],
    );
  }

  void logout() async {
    var res = await _apiClient.logout(accessToken);
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('accessToken');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
