import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {

  Future<Movie> getMovie() async {

    final url = Uri.parse(
      "https://rottentomato.p.rapidapi.com/get-spoilers-for-movie?spoiler_id=grudge-match"
    );

    final response = await http.get(
      url,
      headers: {
        'x-rapidapi-host': 'rottentomato.p.rapidapi.com',
        'x-rapidapi-key': 'TU_API_KEY'
      },
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      return Movie.fromJson(data);

    } else {

      throw Exception("Error cargando datos");

    }
  }
}