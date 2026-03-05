




import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  /// Trae todas las películas desde la API
  Future<List<Movie>> getMovies() async {
    final response = await http.get(Uri.parse("https://rottentomato.p.rapidapi.com/get-spoilers-for-movie?spoiler_id=grudge-match")); // pon tu URL real

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar películas');
    }
  }
}