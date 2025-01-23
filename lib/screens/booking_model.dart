class Booking {
  final String userId; // User ID from Firestore
  final String movieId; // Movie ID or title used as the document ID
  final List<String> selectedSeats; // List of selected seat numbers
  final DateTime bookingTime; // Time when the booking was made
  final String chosenDate; // The chosen date for the movie show
  final String showtime; // Showtime for the movie

  Booking({
    required this.userId,
    required this.movieId,
    required this.selectedSeats,
    required this.bookingTime,
    required this.chosenDate,
    required this.showtime,
  });

  /// Converts the `Booking` object into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'movieId': movieId,
      'selectedSeats': selectedSeats,
      'bookingTime': bookingTime.toIso8601String(),
      'chosenDate': chosenDate,
      'showtime': showtime,
    };
  }

  /// Creates a `Booking` object from a Firestore Map.
  factory Booking.fromMap(String id, Map<String, dynamic> map) {
    return Booking(
      userId: map['userId'] as String,
      movieId: map['movieId'] as String,
      selectedSeats: List<String>.from(map['selectedSeats'] ?? []),
      bookingTime: DateTime.parse(map['bookingTime'] as String),
      chosenDate: map['chosenDate'] as String,
      showtime: map['showtime'] as String,
    );
  }
}
