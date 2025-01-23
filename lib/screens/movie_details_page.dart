import 'package:flutter/material.dart';
import 'seat_selection_page.dart'; // Import the seat selection page
import 'movie_model.dart'; // Import the Movie model
import 'favorite_screen.dart'; // Import the Favorite screen

class MovieDetailsPage extends StatefulWidget {
  final Movie movie; // Use the Movie model
  final String userId; // Add userId to pass to SeatSelectionPage

  MovieDetailsPage({
    required this.movie,
    required this.userId, // Require userId in the constructor
  });

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  bool showSynopsis = false; // State to toggle synopsis visibility
  bool isFavorite = false; // State to track if the movie is a favorite

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF000000), // Black background for the entire page
      appBar: AppBar(
        title: Text(
          widget.movie.title, // Use the movie title
          style: TextStyle(color: Colors.white), // White text for movie title
        ),
        backgroundColor: Colors.black, // Set AppBar background to black
        iconTheme:
            IconThemeData(color: Colors.white), // Set back icon color to white
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red, // Red heart for favorites
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                if (isFavorite) {
                  FavoriteScreen.addFavorite(widget.movie); // Add to favorites
                } else {
                  FavoriteScreen.removeFavorite(
                      widget.movie); // Remove from favorites
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.movie.image, // Use the movie image
                  fit: BoxFit.cover,
                  height: 250, // Reduced height
                ),
              ),
            ),
            SizedBox(height: 15),

            // Movie Title
            Center(
              child: Text(
                widget.movie.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20, // Slightly smaller font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Movie Information (Genre, Rating, Duration)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.category, color: Colors.amber, size: 20),
                    SizedBox(height: 4),
                    Text(
                      widget.movie.genre,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(height: 4),
                    Text(
                      widget.movie.rating.toStringAsFixed(
                          1), // Convert the rating to a string with one decimal place
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.access_time, color: Colors.amber, size: 20),
                    SizedBox(height: 4),
                    Text(
                      widget.movie.duration,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Synopsis Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSynopsis = !showSynopsis; // Toggle synopsis visibility
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Gold button
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: Size(100, 30), // Smaller button size
                ),
                child: Text(
                  showSynopsis ? 'Hide Synopsis' : 'Show Synopsis',
                  style: TextStyle(
                    color: Colors.black, // Black text for button
                    fontSize: 14, // Smaller font size
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Synopsis Section
            if (showSynopsis)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // Slightly lighter black background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.movie.description, // Use the movie description
                  style: TextStyle(
                    color: Colors.white, // White text for description
                    fontSize: 14, // Smaller font size
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            Spacer(),

            // "Book Now" Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the SeatSelectionPage with movieId and userId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionPage(
                        movieId: widget.movie.title, // Pass the actual movie ID
                        userId: widget.userId, // Pass the actual user ID
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD700), // Gold button
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    color: Colors.black, // Black text for button
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
