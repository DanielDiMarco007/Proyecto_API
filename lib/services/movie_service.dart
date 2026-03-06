/// Importa la librería para convertir datos JSON a objetos Dart
import 'dart:convert';

/// Importa el paquete http para poder hacer peticiones a una API
import 'package:http/http.dart' as http;

/// Importa el modelo Movie que creamos para representar una película
import '../models/movie.dart';

/// Clase encargada de comunicarse con la API y obtener datos de películas
class MovieService {

  /// Método que obtiene la información de una película desde la API
  /// Devuelve un objeto de tipo Movie
  Future<Movie> getMovie() async {

    /// Se crea la URL de la API usando Uri.parse
    final url = Uri.parse(
      "https://rottentomato.p.rapidapi.com/get-spoilers-for-movie?spoiler_id=grudge-match"
    );

    /// Se realiza la petición HTTP GET a la API
    final response = await http.get(
      url,
      headers: {

        /// Host de la API en RapidAPI
        'x-rapidapi-host': 'rottentomato.p.rapidapi.com',

        /// Clave de autenticación para acceder a la API
        'x-rapidapi-key': 'TU_API_KEY'
      },
    );

    /// Verifica si la respuesta del servidor fue exitosa
    if (response.statusCode == 200) {

      /// Convierte el cuerpo de la respuesta (JSON) en un objeto Dart
      final data = json.decode(response.body);

      /// Convierte los datos JSON en un objeto Movie usando el modelo
      return Movie.fromJson(data);

    } else {

      /// Si ocurre un error en la petición se lanza una excepción
      throw Exception("Error cargando datos");

    }
  }
}