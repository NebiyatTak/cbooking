import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id; // Document ID from Firestore
  final String username;
  final String email;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
  });

  // Factory constructor to create a UserProfile from a Firestore document snapshot
  factory UserProfile.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      id: doc.id, // Using Firestore document ID as the user ID
      username: data['username'] ?? 'Unknown', // Default to 'Unknown' if null
      email: data['email'] ?? '',
    );
  }

  // Method to convert UserProfile to a JSON-like map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
