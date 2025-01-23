import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/movie_model.dart';

class MovieDatabaseService {
  final CollectionReference movieCollection =
      FirebaseFirestore.instance.collection('movies');

  /// Adds a movie to the Firestore collection.
  Future<void> addMovie(Movie movie) async {
    try {
      await movieCollection.doc(movie.id).set(movie.toMap());
      print("Movie added successfully: ${movie.title}");
    } catch (e) {
      print("Error adding movie: $e");
    }
  }

  /// Fetches a list of movies from the Firestore collection.
  Future<List<Movie>> fetchMovies() async {
    try {
      final querySnapshot = await movieCollection.get();
      return querySnapshot.docs
          .map((doc) =>
              Movie.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }
}
