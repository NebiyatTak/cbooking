import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart'; // Update with your actual path
import 'booking_history.dart'; // Import BookingHistoryPage

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? currentUser;
  Map<String, dynamic>? userProfile;

  bool isDarkMode = false; // Track dark mode state
  bool _isMounted = true; // To track if the widget is still mounted
  List<String> bookingHistory = ['Booking 1', 'Booking 2', 'Booking 3'];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    _isMounted = false; // Mark the widget as disposed
    super.dispose();
  }

  Future<void> loadUserData() async {
    currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      final profile = await _authService.fetchUserProfile(currentUser!.uid);
      if (_isMounted) {
        setState(() {
          userProfile = profile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Profile Image and Details
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    userProfile?['username'] ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    currentUser?.email ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Booking History Section
            ListTile(
              leading: Icon(Icons.history,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Booking History',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                if (_isMounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingHistoryPage(userId: currentUser?.uid ?? ''),
                    ),
                  );
                }
              },
            ),

            // Change Username Section
            ListTile(
              leading: Icon(Icons.edit,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Change Username',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                changeUsername(context);
              },
            ),

            // Change Password Section
            ListTile(
              leading: Icon(Icons.lock,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Change Password',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                changePassword(context);
              },
            ),

            // Dark/Light Mode Toggle
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Toggle Dark/Light Mode',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                if (_isMounted) {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                }
              },
            ),

            // Logout Section
            ListTile(
              leading: Icon(Icons.logout,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                'Logout',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void changeUsername(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Username'),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: "Enter new username"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newUsername = usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  await _authService.updateUsername(
                      currentUser!.uid, newUsername);
                  if (_isMounted) {
                    setState(() {
                      userProfile?['username'] = newUsername;
                    });
                  }
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Username cannot be empty.")),
                  );
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void changePassword(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: InputDecoration(hintText: "Current Password"),
                obscureText: true,
              ),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(hintText: "New Password"),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(hintText: "Confirm New Password"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String oldPassword = currentPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();

                if (newPassword.isNotEmpty && newPassword == confirmPassword) {
                  try {
                    await _authService.reauthenticateAndChangePassword(
                      currentUser!.email!,
                      oldPassword,
                      newPassword,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Password changed successfully.")),
                    );
                    Navigator.pop(context); // Close the dialog
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match.")),
                  );
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    await _authService.signOut();
    if (_isMounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}