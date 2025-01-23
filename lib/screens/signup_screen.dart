import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import your AuthService class

class SignUpScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey, // Add the key here
      backgroundColor: const Color(0xFF000000), // Black background
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Username Input
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.person, color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Password Input
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              // Confirm Password Input
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),
              // Sign Up Button
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  // Input validation
                  if (username.isEmpty) {
                    _showErrorDialog(context, 'Username cannot be empty.');
                    return;
                  }
                  if (email.isEmpty) {
                    _showErrorDialog(context, 'Email cannot be empty.');
                    return;
                  }
                  if (!RegExp(
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$')
                      .hasMatch(password)) {
                    _showErrorDialog(
                      context,
                      'Password must be at least 8 characters long, '
                      'include an uppercase letter, a lowercase letter, '
                      'a number, and a special character.',
                    );
                    return;
                  }
                  if (password != confirmPassword) {
                    _showErrorDialog(context, 'Passwords do not match.');
                    return;
                  }

                  try {
                    // Sign up with AuthService
                    User? user = await AuthService().signUp(
                      username,
                      email,
                      password,
                    );

                    if (user != null) {
                      print(
                          "User signed up successfully. Username: ${user.displayName}");
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else {
                      _showErrorDialog(context, 'Sign up failed.');
                    }
                  } catch (e) {
                    _showErrorDialog(context, 'An unknown error occurred.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700), // Gold
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 50.0),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF000000),
        title: const Text(
          "Error",
          style: TextStyle(color: Color(0xFFFFD700)),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }
}
