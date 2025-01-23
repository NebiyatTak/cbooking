class Movie {
  final String id; // Movie ID (same as the title)
  final String title;
  final String genre;
  final String image;
  final double rating;
  final String description;
  final String duration;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.image,
    required this.rating,
    required this.description,
    required this.duration,
  });

  /// Converts the `Movie` object into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'image': image,
      'rating': rating,
      'description': description,
      'duration': duration,
    };
  }

  /// Creates a `Movie` object from a Firestore Map.
  factory Movie.fromMap(String id, Map<String, dynamic> map) {
    return Movie(
      id: id, // Use the provided ID
      title: map['title'] as String,
      genre: map['genre'] as String,
      image: map['image'] as String,
      rating: (map['rating'] as num).toDouble(), // Ensure it converts to double
      description: map['description'] as String,
      duration: map['duration'] as String,
    );
  }
}
