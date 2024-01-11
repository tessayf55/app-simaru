import 'package:flutter/material.dart';
import 'package:appssimaru/core/api_client.dart';
import 'package:appssimaru/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();
  String accessToken = '';
  late Size size; // Tambahkan deklarasi variabel size

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
        accessToken = data;
      });
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final userRes = await _apiClient.getUserProfileData(accessToken);
      return userRes;
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.logout(accessToken);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      debugPrint("Error during logout: $e");
      throw e;
    }
  }

  Widget _buildLoadingScreen() {
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.blueGrey,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.redAccent, // Theme color for errors
      child: const Center(
        child: Text(
          "Error fetching data",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHomeScreen(Map<String, dynamic> userData) {
    String name = userData['user']['name'];
    String email = userData['user']['email'];

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.blue,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 10),
              _buildUserInfo(name, email),
              const SizedBox(height: 20),
              _buildProfileDetailsContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.all(5),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            width: 1,
            color: Colors.green.shade100,
          ),
        ),
        child: Container(
          height: 100,
          width: 100,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Image(
            image: AssetImage('assets/image.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(String name, String email) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            email,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsContainer() {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'PROFILE DETAILS',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size; // Inisialisasi size di sini
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: FutureBuilder<Map<String, dynamic>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            } else if (snapshot.hasError) {
              return _buildErrorScreen();
            } else if (snapshot.hasData) {
              return _buildHomeScreen(snapshot.data!);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
