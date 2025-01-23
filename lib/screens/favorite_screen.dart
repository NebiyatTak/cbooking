import 'package:flutter/material.dart';
import 'movie_model.dart';

class FavoriteScreen extends StatefulWidget {
  static List<Movie> favoriteMovies =
      []; // Static list to store favorite movies

  static void addFavorite(Movie movie) {
    if (!favoriteMovies.contains(movie)) {
      favoriteMovies.add(movie);
    }
  }

  static void removeFavorite(Movie movie) {
    favoriteMovies.remove(movie);
  }

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FavoriteScreen.favoriteMovies.isEmpty
          ? Center(
              child: Text(
                'No favorites added yet!',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: FavoriteScreen.favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = FavoriteScreen.favoriteMovies[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(movie.image, width: 50, height: 50),
                  ),
                  title: Text(
                    movie.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    movie.genre,
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        FavoriteScreen.removeFavorite(movie);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
