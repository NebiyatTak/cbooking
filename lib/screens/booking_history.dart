import 'package:cbooking/services/booking_service.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  final String userId;

  BookingHistoryPage({required this.userId});

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late Future<List<Booking>> _bookingHistory;

  @override
  void initState() {
    super.initState();
    _bookingHistory = BookingService().getBookingHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking History"),
        backgroundColor: Color(0xFF000000),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF000000),
      body: FutureBuilder<List<Booking>>(
        future: _bookingHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "An error occurred: ${snapshot.error}",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No bookings found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          List<Booking> bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              Booking booking = bookings[index];
              return _buildBookingCard(booking);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      color: Color(0xFF1C1C1C),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.movieTitle,
              style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text("Date: ${booking.selectedDate}",
                style: TextStyle(color: Colors.white)),
            Text("Time: ${booking.selectedShowtime}",
                style: TextStyle(color: Colors.white)),
            Text("Seats: ${booking.selectedSeats.join(', ')}",
                style: TextStyle(color: Colors.white)),
            Text("Total Amount: ${booking.totalPrice} ETB",
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
