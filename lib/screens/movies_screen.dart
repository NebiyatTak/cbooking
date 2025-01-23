import 'package:flutter/material.dart';
import 'movie_details_page.dart'; // Import the movie details page
import 'movie_model.dart'; // Import the Movie model

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final List<Movie> nowPlayingMovies = [
    Movie(
      id: 'forever_my_girl',
      title: 'Forever My Girl',
      genre: 'Fantasy',
      image: 'assets/images/movie1.jpg',
      rating: 4.5,
      description:
          'In a world shrouded in darkness, a young hero embarks on a quest to find the mythical source of light that can save humanity from eternal night.',
      duration: '120 min',
    ),
    Movie(
      id: 'mufasa',
      title: 'Mufasa: The Lion King (2024)',
      genre: 'Sci-Fi',
      image: 'assets/images/movie2.jpg',
      rating: 4.2,
      description:
          'A cub lost and alone meets a sympathetic lion named Taka, the heir to a royal bloodline. The chance meeting sets in motion an expansive journey.',
      duration: '115 min',
    ),
    Movie(
      id: 'eternals',
      title: 'Eternals',
      genre: 'Action',
      image: 'assets/images/movie3.jpg',
      rating: 4.1,
      description:
          'The Eternals, a race of immortal beings who lived on Earth for thousands of years, reunite to battle the evil Deviants.',
      duration: '157 min',
    ),
    Movie(
      id: 'spiderman_no_way_home',
      title: 'Spider-Man: No Way Home',
      genre: 'Action',
      image: 'assets/images/movie4.jpg',
      rating: 4.7,
      description:
          'Peter Parker seeks help from Doctor Strange to restore his secret identity, leading to consequences that force him to confront other universes.',
      duration: '148 min',
    ),
    Movie(
      id: 'dune',
      title: 'Dune',
      genre: 'Sci-Fi',
      image: 'assets/images/movie5.jpg',
      rating: 4.3,
      description:
          'In the far future, a noble family becomes embroiled in a war for control of the most valuable asset in existence, the spice melange.',
      duration: '155 min',
    ),
    Movie(
      id: 'no_time_to_die',
      title: 'No Time to Die',
      genre: 'Action',
      image: 'assets/images/movie6.jpg',
      rating: 4.2,
      description:
          'James Bond has left active service and is enjoying a tranquil life in Jamaica. His peace is short-lived when his old friend Felix Leiter from the CIA shows up asking for help.',
      duration: '163 min',
    ),
    Movie(
      id: 'the_french_dispatch',
      title: 'The French Dispatch',
      genre: 'Comedy',
      image: 'assets/images/movie7.jpg',
      rating: 4.0,
      description:
          'A love letter to journalists, the film brings to life a collection of stories published in the French Dispatch magazine.',
      duration: '108 min',
    ),
    Movie(
      id: 'the_matrix_resurrections',
      title: 'The Matrix Resurrections',
      genre: 'Sci-Fi',
      image: 'assets/images/movie8.jpg',
      rating: 3.9,
      description:
          'Neo is living a peaceful life in San Francisco but is drawn back into the Matrix for a new adventure.',
      duration: '148 min',
    ),
  ];

  final List<Movie> upcomingMovies = [
    Movie(
      id: 'shadows_of_time',
      title: 'Shadows of Time',
      genre: 'Sci-Fi',
      image: 'assets/images/movie9.jpg',
      rating: 4.3,
      description:
          'When a time travel experiment goes wrong, a scientist finds himself in a parallel universe where he must confront his own past mistakes.',
      duration: '110 min',
    ),
    Movie(
      id: 'the_phantom_city',
      title: 'The Phantom City',
      genre: 'Mystery',
      image: 'assets/images/movie10.jpg',
      rating: 4.5,
      description:
          'A journalist investigates the mysterious disappearance of an entire city, uncovering dark secrets that threaten to change history forever.',
      duration: '125 min',
    ),
    Movie(
      id: 'avatar_way_of_water',
      title: 'Avatar: The Way of Water',
      genre: 'Adventure',
      image: 'assets/images/movie11.jpg',
      rating: 4.8,
      description:
          'Jake Sully and Neytiri must protect their family from new threats in this stunning sequel to the blockbuster Avatar.',
      duration: '162 min',
    ),
    Movie(
      id: 'guardians_of_the_galaxy_vol_3',
      title: 'Guardians of the Galaxy Vol. 3',
      genre: 'Action',
      image: 'assets/images/movie12.jpg',
      rating: 4.7,
      description:
          'The Guardians embark on a mission to defend one of their own while facing a powerful new enemy.',
      duration: '150 min',
    ),
    Movie(
      id: 'fast_x',
      title: 'Fast X',
      genre: 'Action',
      image: 'assets/images/movie13.jpg',
      rating: 4.4,
      description:
          'Dom Toretto and his family must face a new threat that brings back old foes.',
      duration: '145 min',
    ),
    Movie(
      id: 'indiana_jones_dial_of_destiny',
      title: 'Indiana Jones and the Dial of Destiny',
      genre: 'Adventure',
      image: 'assets/images/movie14.jpg',
      rating: 4.2,
      description:
          'Indiana Jones embarks on a new adventure that takes him across the globe in pursuit of a legendary artifact.',
      duration: '120 min',
    ),
    Movie(
      id: 'the_marvels',
      title: 'The Marvels',
      genre: 'Action',
      image: 'assets/images/movie15.jpg',
      rating: 4.3,
      description:
          'Captain Marvel, Ms. Marvel, and Monica Rambeau must work together to save the universe.',
      duration: '120 min',
    ),
    Movie(
      id: 'spiderman_across_spiderverse',
      title: 'Spider-Man: Across the Spider-Verse',
      genre: 'Animation',
      image: 'assets/images/movie16.jpg',
      rating: 4.6,
      description:
          'Miles Morales embarks on a multiverse adventure, teaming up with new allies and facing new foes.',
      duration: '140 min',
    ),
  ];

  List<Movie> displayedMovies = [];
  bool showNowPlaying = true;

  @override
  void initState() {
    super.initState();
    displayedMovies = nowPlayingMovies;
  }

  void _toggleCategory(bool isNowPlaying) {
    setState(() {
      showNowPlaying = isNowPlaying;
      displayedMovies = isNowPlaying ? nowPlayingMovies : upcomingMovies;
    });
  }

  void _navigateToDetails(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie, userId: ''),
      ),
    );
  }

  void _searchMovies(String query) {
    setState(() {
      displayedMovies = (showNowPlaying ? nowPlayingMovies : upcomingMovies)
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.black12,
              ),
              style: TextStyle(color: Colors.white), // Set text color to white
              onChanged: _searchMovies,
            ),
          ),

          // Toggle Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: showNowPlaying ? Colors.amber : Colors.grey,
                ),
                onPressed: () => _toggleCategory(true),
                child: Text("Now Playing"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showNowPlaying ? Colors.amber : Colors.grey,
                ),
                onPressed: () => _toggleCategory(false),
                child: Text("Upcoming"),
              ),
            ],
          ),

          // Movie List
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.65,
              ),
              itemCount: displayedMovies.length,
              itemBuilder: (context, index) {
                final movie = displayedMovies[index];
                return GestureDetector(
                  onTap: () => _navigateToDetails(context, movie),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          movie.image,
                          fit: BoxFit.cover,
                          height: double
                              .infinity, // Ensure the image takes full height
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors
                                .black54, // Semi-transparent black background
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Genre: ${movie.genre}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Rating: ${movie.rating}',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
