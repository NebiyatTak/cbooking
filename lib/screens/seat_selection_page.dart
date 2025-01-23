import 'package:flutter/material.dart';
import 'booking_confirmation_page.dart'; // Import your BookingConfirmationPage
import '../services/booking_service.dart'; // Import your BookingService

class SeatSelectionPage extends StatefulWidget {
  final String movieId; // Movie ID passed from the previous page
  final String userId; // User ID for booking

  const SeatSelectionPage({required this.movieId, required this.userId});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final int seatPrice = 15; // Price per seat
  List<List<bool>> seats = List.generate(
      8, (row) => List.generate(12, (col) => false)); // 8 rows, 12 columns
  List<List<bool>> reservedSeats =
      List.generate(8, (row) => List.generate(12, (col) => false));
  String? selectedShowtime;
  String? selectedDate;
  List<String> showtimes = [
    "10:00 AM",
    "01:00 PM",
    "04:00 PM",
    "07:00 PM"
  ]; // Example showtimes
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Reserved seats will be loaded after selecting showtime
  }

  void toggleSeat(int row, int col) {
    if (reservedSeats[row][col]) return; // Disable toggling for reserved seats
    setState(() {
      seats[row][col] = !seats[row][col];
      totalPrice += seats[row][col] ? seatPrice : -seatPrice;
    });
  }

  void selectShowtime(String time) {
    setState(() {
      selectedShowtime = time;
      loadReservedSeats(time); // Load reserved seats for the selected showtime
    });
  }

  void selectDate(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> loadReservedSeats(String showtime) async {
    if (selectedDate == null) {
      print("Error: Selected date is null. Please select a date.");
      return;
    }
    try {
      final bookedSeats = await BookingService().fetchBookedSeats(
        widget.movieId,
        showtime,
        selectedDate!,
      );

      setState(() {
        reservedSeats =
            List.generate(8, (row) => List.generate(12, (col) => false));
        for (var seatName in bookedSeats) {
          if (seatName.isNotEmpty && seatName.length >= 2) {
            int row =
                seatName.codeUnitAt(0) - 65; // Convert letter to row index
            String seatNumberPart = seatName.substring(1);
            int? col = int.tryParse(seatNumberPart) != null
                ? int.parse(seatNumberPart) - 1
                : null;
            if (row >= 0 &&
                row < reservedSeats.length &&
                col != null &&
                col >= 0 &&
                col < reservedSeats[row].length) {
              reservedSeats[row][col] = true;
            } else {
              print("Invalid seat row or column: row=$row, col=$col");
            }
          } else {
            print("Seat name is empty or invalid: $seatName");
          }
        }
      });
    } catch (e) {
      print("Error loading reserved seats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Select Seats"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/screen.jpg',
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Your Seats",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: seats.length * seats[0].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 12,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ seats[0].length;
                  int col = index % seats[0].length;
                  String seatName =
                      '${String.fromCharCode(65 + row)}${col + 1}';

                  return GestureDetector(
                    onTap: () => toggleSeat(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        color: reservedSeats[row][col]
                            ? Colors.grey
                            : seats[row][col]
                                ? Colors.amber
                                : const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Center(
                        child: Text(
                          seatName,
                          style: TextStyle(
                            color: reservedSeats[row][col]
                                ? Colors.white
                                : seats[row][col]
                                    ? Colors.black
                                    : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Available: Light Dark",
                    style: TextStyle(color: Colors.white)),
                Text("Selected: Gold", style: TextStyle(color: Colors.amber)),
                Text("Reserved: Gray", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Date",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String date in [
                        "Dec 25",
                        "Dec 26",
                        "Dec 27",
                        "Dec 28",
                        "Dec 29"
                      ])
                        GestureDetector(
                          onTap: () => selectDate(date),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: selectedDate == date
                                  ? Colors.amber
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              date as String,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Showtime",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String time in showtimes)
                        GestureDetector(
                          onTap: () => selectShowtime(time),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: selectedShowtime == time
                                  ? Colors.amber
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              time,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (totalPrice > 0 &&
                    selectedShowtime != null &&
                    selectedDate != null) {
                  final selectedSeats = <String>[];

                  for (int row = 0; row < seats.length; row++) {
                    for (int col = 0; col < seats[row].length; col++) {
                      if (seats[row][col]) {
                        selectedSeats
                            .add('${String.fromCharCode(65 + row)}${col + 1}');
                      }
                    }
                  }

                  String movieTitle =
                      widget.movieId; // Replace with your actual movie title

                  // BookingService().saveBooking(
                  //   userId: widget.userId,
                  //   movieId: widget.movieId,
                  //   selectedSeats: selectedSeats,
                  //   chosenDate: selectedDate!,
                  //   showtime: selectedShowtime!,
                  //   totalPrice: totalPrice,
                  //   movieTitle: movieTitle, // Pass the movie title here
                  // );

                  if (selectedDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingConfirmationPage(
                          totalPrice: totalPrice,
                          selectedSeats: selectedSeats,
                          selectedDate: selectedDate!, // Use non-null assertion
                          movieId: widget.movieId, // Pass movieId here
                          movieTitle: movieTitle, // Pass movieTitle here
                          userId: widget.userId,
                          selectedShowtime: selectedShowtime!,
                          showtime: selectedShowtime!, // Pass userId here
                        ),
                      ),
                    );
                  } else {
                    // Show an error or prompt the user to select a date
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Please select a date before proceeding.")),
                    );
                  }
                } else {
                  // Show a message if no seats are selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please select at least one seat, date, and showtime.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.amber,
              ),
              child: const Text("Proceed to Booking"),
            ),
            const SizedBox(height: 16),
            Text(
              "Total Price: ${totalPrice.toString()} birr",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
