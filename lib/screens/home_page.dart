import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'booking/booking_screen.dart';
import 'home.dart';
import 'ruangan/ruangan_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  int currentPageIndex = 0;
  String token = '';

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _fadeInAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _loadToken();
  }

  _loadToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('accessToken');

    if (data != null) {
      setState(() {
        token = data;
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Master Ruangan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Booking',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: IndexedStack(
          index: currentPageIndex,
          children: const <Widget>[
            HomeScreen(),
            RuanganScreen(),
            BookingScreen(),
          ],
        ),
      ),
    );
  }
}
