import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Sample movie data
  final List<Movie> movies = List.generate(16, (index) {
    return Movie(
      title: 'Movie ${index + 1}',
      genre: 'Genre ${index % 4 + 1}', // Example genres
      imagePath: 'assets/images/movie${index + 1}.jpg',
      reviews: [
        Review(
          username: 'User1',
          profileImage: 'assets/images/profile.jpg',
          date: '2024-12-28',
          comment: 'Great movie! Highly recommend it.',
          rating: 5, // Example rating
        ),
        Review(
          username: 'User2',
          profileImage: 'assets/images/profile.jpg',
          date: '2024-12-27',
          comment: 'Not my cup of tea, but the cinematography was beautiful.',
          rating: 3, // Example rating
        ),
        Review(
          username: 'User3',
          profileImage: 'assets/images/profile.jpg',
          date: '2024-12-26',
          comment: 'An amazing experience, loved the performances!',
          rating: 4, // Example rating
        ),
        Review(
          username: 'User4',
          profileImage: 'assets/images/profile.jpg',
          date: '2024-12-25',
          comment: 'Could have been better, but overall enjoyable.',
          rating: 3, // Example rating
        ),
      ],
    );
  });

  // Text controller for review input
  final TextEditingController _reviewController = TextEditingController();

  // Track user's rating
  int _userRating = 0; // User's rating for the current review

  // Function to add a review
  void _addReview(int movieIndex) {
    if (_reviewController.text.isNotEmpty) {
      setState(() {
        movies[movieIndex].reviews.add(Review(
              username: 'Current User', // Replace with actual user data
              profileImage:
                  'assets/images/profile.jpg', // Use user's profile image
              date: DateTime.now()
                  .toIso8601String()
                  .split('T')[0], // Current date
              comment: _reviewController.text,
              rating: _userRating, // Use the selected rating
            ));
        _reviewController.clear(); // Clear the input field
        _userRating = 0; // Reset user rating
      });
    }
  }

  // Track visibility of previous reviews
  final List<bool> _showReviews = List.generate(16, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black54, // Dark background
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              color: Colors.grey[800], // Darker card background
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Title and Genre
                    Row(
                      children: [
                        Image.asset(
                          movies[index].imagePath,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movies[index].title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // White text
                              ),
                            ),
                            Text(
                              movies[index].genre,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[300], // Lighter text color
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Button to show/hide previous reviews
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showReviews[index] = !_showReviews[index];
                        });
                      },
                      child: Text(
                        _showReviews[index]
                            ? 'Hide Previous Reviews'
                            : 'Show Previous Reviews',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                    // Display Previous Reviews if visible
                    if (_showReviews[index]) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: movies[index]
                            .reviews
                            .map((review) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage(review.profileImage),
                                        radius: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review.username,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            // Display the rating for each review
                                            Row(
                                              children:
                                                  List.generate(5, (starIndex) {
                                                return Icon(
                                                  starIndex < review.rating
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16,
                                                );
                                              }),
                                            ),
                                            Text(
                                              review.comment,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors
                                                      .white), // White text
                                            ),
                                            Text(
                                              review.date,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[
                                                      400]), // Light grey date
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 10),
                    ],

                    // Input field for new review
                    TextField(
                      controller: _reviewController,
                      decoration: InputDecoration(
                        labelText: 'Add a review...',
                        border: OutlineInputBorder(),
                        labelStyle:
                            TextStyle(color: Colors.white), // White label
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.amber), // Amber focused border
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // White text
                    ),
                    SizedBox(height: 8),

                    // Rating section for the current user
                    Text(
                      'Rate this movie:',
                      style: TextStyle(color: Colors.white), // White text
                    ),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _userRating =
                                  starIndex + 1; // Set the user's rating
                            });
                          },
                          child: Icon(
                            starIndex < _userRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: () => _addReview(index),
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Review class to hold review data
class Review {
  final String username;
  final String profileImage;
  final String date;
  final String comment;
  final int rating; // User's rating for the review

  Review({
    required this.username,
    required this.profileImage,
    required this.date,
    required this.comment,
    required this.rating,
  });
}

// Movie class to hold movie data
class Movie {
  final String title;
  final String genre;
  final String imagePath;
  final List<Review> reviews;
  int? userRating; // User's rating for the movie

  Movie({
    required this.title,
    required this.genre,
    required this.imagePath,
    required this.reviews,
    this.userRating,
  });
}
