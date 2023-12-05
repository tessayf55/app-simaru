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
  String _accessToken = '';
  List<Ruangan> _ruangan = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('accessToken');

    if (data != null) {
      setState(() {
        _accessToken = data;
      });
    }
  }

  Future<List<Ruangan>> fetchData() async {
    String dataRes;
    dataRes = await _apiClient.getRuanganData(_accessToken);
    
    List jsonResponse = json.decode(dataRes);
    return jsonResponse.map((data) => Ruangan.fromJson(data)).toList();
   
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ruangan>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: DataTable(
              border: TableBorder.all(width: 1),
              columnSpacing: 30,
              columns: const [
                DataColumn(label: Text('ID'), numeric: true),
                DataColumn(label: Text('Ruangan'), numeric: true),
                DataColumn(label: Text('KAPASITAS')),
              ],
              rows: List.generate(
                snapshot.data!.length,
                (index) {
                  var data = snapshot.data![index];
                  return DataRow(cells: [
                    DataCell(
                      Text(data.id.toString()),
                    ),
                    DataCell(
                      Text(data.nama_ruangan.toString()),
                    ),
                    DataCell(
                      Text(data.kapasitas.toString()),
                    ),
                  ]);
                },
              ).toList(),
              showBottomBorder: true,
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
