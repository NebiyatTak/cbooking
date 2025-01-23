import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movies_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/review_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CinemaBookingApp());
}

class CinemaBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema Booking App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Background set to black
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => BottomNavigationScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    MoviesScreen(),
    FavoriteScreen(),
    ReviewScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getAppBarTitle(),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor:
            Colors.black, // Explicitly sets the background to black
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _getAppBarTitle() {
    if (_selectedIndex == 0) {
      return _buildHalfYellowTitle('CBo', 'o', 'king');
    }

    switch (_selectedIndex) {
      case 1:
        return _buildHalfYellowTitle('Mo', 'vie', 's');
      case 2:
        return _buildHalfYellowTitle('Fa', 'vorites', '');
      case 3:
        return _buildHalfYellowTitle('Re', 'views', '');
      case 4:
        return _buildHalfYellowTitle('Pro', 'file', '');
      default:
        return Text('');
    }
  }

  Widget _buildHalfYellowTitle(String part1, String part2, String part3) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          part1,
          style: TextStyle(
            fontSize: 26, // Updated font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          part2,
          style: TextStyle(
            fontSize: 26, // Updated font size
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700), // Yellow color
          ),
        ),
        Text(
          part3,
          style: TextStyle(
            fontSize: 26, // Updated font size
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700), // Yellow color
          ),
        ),
      ],
    );
  }
}
