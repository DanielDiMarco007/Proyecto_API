


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_list.dart';

/// Servicio para obtener películas desde la API
class MovieService {

  /// Método que trae la lista de películas desde la API
  Future<MovieList> getMovies() async {
    // Reemplaza la URL por la de tu API real
    final response = await http.get(Uri.parse(" https://rottentomato.p.rapidapi.com/get-spoilers-for-movie?spoiler_id=grudge-match"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Convierte el JSON en MovieList
      return MovieList.fromJson(data);
    } else {
      // Si falla la petición, lanza excepción
      throw Exception('Error al cargar películas');
    }
  }
}