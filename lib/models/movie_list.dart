import 'movie.dart';

/// Clase que representa la lista de películas devuelta por la API
class MovieList {
  final List<Movie> results;

  MovieList({required this.results});

  factory MovieList.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List;
    final movies = resultsJson.map((e) => Movie.fromJson(e)).toList();
    return MovieList(results: movies);
  }
}