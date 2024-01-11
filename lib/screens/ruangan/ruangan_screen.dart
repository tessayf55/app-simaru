import 'package:flutter/material.dart';
import 'package:appssimaru/model/ruangan.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/ruangan/ruangan_add.dart';
import 'package:appssimaru/screens/ruangan/ruangan_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RuanganScreen extends StatefulWidget {
  const RuanganScreen({Key? key}) : super(key: key);

  @override
  RuangansScreenState createState() => RuangansScreenState();
}

class RuangansScreenState extends State<RuanganScreen>
    with SingleTickerProviderStateMixin {
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
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Ruangan'),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RuanganAddScreen(),
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {});
                }
              }),
              icon: Icon(
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
            future: _apiClient.getRuanganData(accessToken),
            builder:
                (BuildContext context, AsyncSnapshot<List<Ruangan>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Terjadi kesalahan: ${snapshot.error.toString()}",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Ruangan>? ruangans = snapshot.data;
                return _buildListView(ruangans!);
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

  Widget _buildListView(List<Ruangan> ruangans) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Ruangan ruangan = ruangans[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
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
                    Text(
                      ruangan.nama_ruangan,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      ruangan.keterangan,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kapasitas : ${ruangan.kapasitas}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(ruangan),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _navigateToEditScreen(ruangan),
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
            ),
          );
        },
        itemCount: ruangans.length,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(Ruangan ruangan) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text(
              "Apakah Anda yakin ingin menghapus ruangan ${ruangan.nama_ruangan}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteRuangan(ruangan);
              },
              child: const Text("Ya"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tidak"),
            ),
          ],
        );
      },
    );
  }

  void _deleteRuangan(Ruangan ruangan) {
    _apiClient.delRuangan(accessToken, ruangan.id).then((isSuccess) {
      if (isSuccess) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Hapus data berhasil"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Hapus data gagal"),
        ));
      }
    });
  }

  void _navigateToEditScreen(Ruangan ruangan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RuanganEditScreen(ruangan: ruangan),
      ),
    ).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }
}
