import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Function to add a booking for each seat individually
  Future<void> saveBooking({
    required String userId,
    required String movieId,
    required List<String> selectedSeats,
    required String chosenDate,
    required String showtime,
    required int totalPrice,
    required String movieTitle,
  }) async {
    try {
      for (String seat in selectedSeats) {
        print("Attempting to save booking for seat: $seat");
        await _firestore.collection('bookings').add({
          'userId': userId,
          'movieId': movieId,
          'seat': seat,
          'chosenDate': chosenDate,
          'showtime': showtime,
          'totalPrice': totalPrice,
          'movieTitle': movieTitle,
          'bookingTime': FieldValue.serverTimestamp(),
        });
        print("Booking saved successfully for seat: $seat");
      }
    } catch (e) {
      print("Error saving booking: $e");
      throw Exception("Failed to save booking. Please try again.");
    }
  }

  /// Function to fetch booked seats
  Future<List<String>> fetchBookedSeats(
      String movieId, String showtime, String chosenDate) async {
    try {
      print(
          "Fetching booked seats for movieId: $movieId, chosenDate: $chosenDate, showtime: $showtime");
      final snapshot = await _firestore
          .collection('bookings')
          .where('movieId', isEqualTo: movieId)
          .where('chosenDate', isEqualTo: chosenDate)
          .where('showtime', isEqualTo: showtime)
          .get();

      List<String> bookedSeats =
          snapshot.docs.map((doc) => doc['seat'] as String).toList();

      print("Fetched booked seats: $bookedSeats");
      return bookedSeats;
    } catch (e) {
      print("Error fetching booked seats: $e");
      return [];
    }
  }

  /// Function to reserve seats securely using a Firestore transaction
  Future<void> reserveSeats({
    required String userId,
    required String movieId,
    required List<String> selectedSeats,
    required String chosenDate,
    required String showtime,
    required int totalPrice,
  }) async {
    try {
      print("Starting transaction to reserve seats.");
      await _firestore.runTransaction((transaction) async {
        final snapshot = await _firestore
            .collection('bookings')
            .where('movieId', isEqualTo: movieId)
            .where('chosenDate', isEqualTo: chosenDate)
            .where('showtime', isEqualTo: showtime)
            .get();

        List<String> bookedSeats =
            snapshot.docs.map((doc) => doc['seat'] as String).toList();

        print("Currently booked seats: $bookedSeats");

        for (var seat in selectedSeats) {
          if (bookedSeats.contains(seat)) {
            throw Exception("Seat $seat is already booked.");
          }

          transaction.set(
            _firestore.collection('bookings').doc(),
            {
              'userId': userId,
              'movieId': movieId,
              'seat': seat,
              'chosenDate': chosenDate,
              'showtime': showtime,
              'totalPrice': totalPrice,
              'bookingTime': FieldValue.serverTimestamp(),
            },
          );

          print("Seat reserved in transaction: $seat");
        }
      });

      print("All seats reserved successfully.");
    } catch (e) {
      print("Error reserving seats: $e");
      throw Exception("Failed to reserve seats. Please try again.");
    }
  }

  /// Function to fetch booking history
  Future<List<Booking>> getBookingHistory(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return Booking(
        movieId: doc['movieId'],
        movieTitle: doc['movieTitle'],
        userId: doc['userId'],
        selectedDate: doc['chosenDate'],
        selectedShowtime: doc['showtime'],
        selectedSeats: List<String>.from(
            doc['seat'] is String ? [doc['seat']] : doc['seat']),
        totalPrice: doc['totalPrice'],
      );
    }).toList();
  }
}

class Booking {
  final String movieId;
  final String movieTitle;
  final String userId;
  final String selectedDate;
  final String selectedShowtime;
  final List<String> selectedSeats;
  final int totalPrice;

  Booking({
    required this.movieId,
    required this.movieTitle,
    required this.userId,
    required this.selectedDate,
    required this.selectedShowtime,
    required this.selectedSeats,
    required this.totalPrice,
  });
}
