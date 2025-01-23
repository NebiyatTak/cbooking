import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign up with email, password, and username
  Future<User?> signUp(String username, String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save user information in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'uid': user.uid,
        });

        // Update the FirebaseAuth user's display name
        await user.updateDisplayName(username);
        await user.reload(); // Refresh user instance to apply updates
      }

      return user;
    } catch (e) {
      print("Error in signUp: $e");
      return null;
    }
  }

  /// Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error in signIn: $e");
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Fetch user profile from Firestore
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  /// Update username
  Future<void> updateUsername(String uid, String username) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'username': username});
  }

  /// Reauthenticate the user and change the password
  Future<void> reauthenticateAndChangePassword(
      String email, String oldPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Reauthenticate the user
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        print("Password updated successfully.");
      } else {
        throw Exception("No user is signed in.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        print("The old password is incorrect.");
        throw Exception("The old password is incorrect.");
      } else if (e.code == 'requires-recent-login') {
        print("User needs to log in again to change the password.");
        throw Exception("User needs to log in again to change the password.");
      } else {
        print("Error changing password: ${e.message}");
        throw Exception(e.message ?? "Unknown error occurred.");
      }
    } catch (e) {
      print("Error in reauthenticateAndChangePassword: $e");
      throw Exception("Failed to change password.");
    }
  }
}
