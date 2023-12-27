// import 'package:appssimaru/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:appssimaru/model/ruangan.dart';
import 'package:appssimaru/core/api_client.dart';
// import 'package:appssimaru/screens/ruangan/ruangan_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RuanganScreen extends StatefulWidget {
  @override
  _RuanganScreenState createState() => _RuanganScreenState();
}

class _RuanganScreenState extends State<RuanganScreen> {
  final ApiClient _apiClient = ApiClient();
  List<Ruangan> _ruangan = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var _accessToken = localStorage.getString('accessToken');

    if (_accessToken != null) {
      String dataRes;
      dataRes = await _apiClient.getRuanganData(_accessToken);
      List jsonResponse = json.decode(dataRes);
      return jsonResponse.map((data) => Ruangan.fromJson(data)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _ruangan.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[200],
            child: Center(child: Text('Entry ${_ruangan[index]}')),
          );
        });
  }
}
