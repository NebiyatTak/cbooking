import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:firebase_auth/firebase_auth.dart';
import 'movie_details_page.dart';
import 'movie_model.dart';

class HomeScreen extends StatelessWidget {
  // Sample movie data using the Movie model
  final List<Movie> movies = [
    Movie(
      id: '1',
      title: 'Forever My Girl',
      genre: 'Action, Adventure, Sci-Fi',
      image: 'assets/images/movie1.jpg',
      rating: 4.8,
      description:
          '''The movie opens outside a small community church in Saint Augustine, Louisiana. A woman is urging the guests to go inside the church because the wedding is about to start. A couple of people make comments to her about hearing Liam singing on the radio. The woman agrees that it's wonderful, but right now they are going to see him marry her daughter.''',
      duration: '2h 29m',
    ),
    Movie(
      id: '2',
      title: 'Mufasa',
      genre: 'Comedy',
      image: 'assets/images/movie2.jpg',
      rating: 4.2,
      description: 'A hilarious comedy about friendship and love.',
      duration: '1h 45m',
    ),
    Movie(
      id: '3',
      title: 'Carry On',
      genre: 'Action, Thriller',
      image: 'assets/images/movie3.jpg',
      rating: 4.8,
      description:
          'An airport security officer races to outsmart a mysterious traveler forcing him to let a dangerous item slip onto a Christmas Eve flight.',
      duration: '2h 5m',
    ),
    Movie(
      id: '4',
      title: 'The Substance',
      genre: 'Drama',
      image: 'assets/images/movie4.jpg',
      rating: 4.7,
      description: 'A gripping drama about family and betrayal.',
      duration: '1h 50m',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${user?.displayName ?? 'User'} 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Welcome back",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  contentPadding: EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  // Implement search functionality here
                },
              ),
            ),
            // Now Playing Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Now Playing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to "See all" page
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            // Carousel Slider
            carousel.CarouselSlider.builder(
              itemCount: movies.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(
                          movie: movies[index],
                          userId: '', // Pass the movie object
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            movies[index].image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 400,
                          ),
                        ),
                        Positioned(
                          bottom: 12.0,
                          left: 16.0,
                          right: 16.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movies[index].title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                movies[index].genre,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                movies[index].duration,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14.0,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    movies[index].rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    ' (1,222)', // Sample vote count
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              options: carousel.CarouselOptions(
                height: 400,
                autoPlay: true,
                viewportFraction: 0.85,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
