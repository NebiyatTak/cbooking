import 'package:cbooking/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingConfirmationPage extends StatelessWidget {
  final List<String> selectedSeats;
  final String selectedShowtime;
  final int totalPrice;
  final String movieId;
  final String movieTitle;
  final String userId;
  final String selectedDate;

  BookingConfirmationPage({
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.totalPrice,
    required this.movieId,
    required this.movieTitle,
    required this.userId,
    required this.selectedDate,
    required String showtime,
  });

  @override
  Widget build(BuildContext context) {
    List<String> seatNames = selectedSeats;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Confirmation"),
        backgroundColor: Color(0xFF000000),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF000000),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Booking Summary"),
              _buildSummaryRow("Movie Title", movieTitle),
              _buildSummaryRow("Date", selectedDate),
              _buildSummaryRow("Time", selectedShowtime),
              _buildSummaryRow("Seats", seatNames.join(', ')),
              _buildSummaryRow("Total Amount", "${totalPrice} birr"),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Save booking details
                    BookingService bookingService = BookingService();
                    try {
                      await bookingService.saveBooking(
                        userId: userId, // Pass user ID
                        movieId: movieId,
                        selectedSeats: seatNames, // Pass selected seat names
                        chosenDate: selectedDate!, // Include showtime
                        showtime: selectedShowtime,
                        totalPrice: totalPrice,
                        movieTitle: movieId, // Include total price
                      );

                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Color(0xFF000000), // Black background
                          title: Text(
                            "Confirmation",
                            style: TextStyle(color: Color(0xFFFFD700)), // Gold
                          ),
                          content: Text(
                            "Your booking has been confirmed!",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigate to another page or back to the previous page
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(color: Color(0xFFFFD700)),
                              ),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      // Show error dialog if booking fails
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0xFF000000),
                          title: Text(
                            "Error",
                            style: TextStyle(color: Color(0xFFFFD700)),
                          ),
                          content: Text(
                            "Failed to confirm booking: $e",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "OK",
                                style: TextStyle(color: Color(0xFFFFD700)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700), // Gold color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "Confirm Booking",
                    style: TextStyle(
                      color: Color(0xFF000000), // Black text
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xFFFFD700),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF000000),
        title: Text(
          "Booking Confirmed",
          style: TextStyle(color: Color(0xFFFFD700)),
        ),
        content: Text(
          "Your booking has been successfully confirmed!",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to the previous screen
            },
            child: Text(
              "OK",
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }
}
