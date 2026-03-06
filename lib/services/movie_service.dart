import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  // API de TMDB - Reemplaza con tu API key si quieres usar la API real
  static const String TMDB_API_KEY = "TU_TMDB_API_KEY_AQUI";
  static const String TMDB_BASE_URL =
      "https://api.themoviedb.org/3/movie/popular";

  /// Obtiene películas desde la API o usa datos locales si falla
  Future<List<Movie>> getMovies() async {
    try {
      // Intenta primero con la API real
      if (TMDB_API_KEY != "TU_TMDB_API_KEY_AQUI") {
        return await _getMoviesFromAPI();
      }
    } catch (e) {
      print("Error al obtener películas de la API: $e");
    }
    // Si falla o no hay key, devuelve películas locales
    return _getLocalMovies();
  }

  /// Obtiene películas desde TMDB API
  Future<List<Movie>> _getMoviesFromAPI() async {
    final response = await http.get(
      Uri.parse("$TMDB_BASE_URL?api_key=$TMDB_API_KEY&language=es-ES"),
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'] ?? [];

      return results.map((movie) {
        return Movie(
          title: movie['title'] ?? 'Sin título',
          year: int.tryParse(
                  (movie['release_date'] ?? '').split('-').first.toString()) ??
              0,
          rating: (movie['vote_average'] ?? 0.0).toString(),
          posterUrl: movie['poster_path'] != null
              ? "https://image.tmdb.org/t/p/w500${movie['poster_path']}"
              : "",
          shortSpoiler: movie['overview'] ?? 'Sin descripción',
          longSpoiler: movie['overview'] ?? 'Sin descripción',
        );
      }).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  /// Devuelve películas locales como fallback
  List<Movie> _getLocalMovies() {
    return [
      Movie(
        title: "Interstellar",
        year: 2014,
        rating: "4.7",
        posterUrl:
            "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
        shortSpoiler:
            "Un grupo de astronautas viaja a través de un agujero de gusano en busca de un nuevo hogar para la humanidad.",
        longSpoiler:
            "Un encuentro con anomalías espaciales lleva a un grupo de astronautas a viajar a través de un agujero de gusano en busca de un nuevo planeta habitable para la humanidad. Una epopeya de ciencia ficción de Christopher Nolan que explora el amor, el tiempo y el sacrificio.",
      ),
      Movie(
        title: "Inception",
        year: 2010,
        rating: "4.6",
        posterUrl:
            "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
        shortSpoiler:
            "Un ladrón roba secretos corporativos entrando en los sueños de las personas.",
        longSpoiler:
            "Un especialista en robo de secretos corporativos recibe la oportunidad de obtener su vida de vuelta con la realización de una tarea imposible: la 'incepción', plantar una idea en la mente de alguien en lugar de robar una. Una obra maestra del cine que desafía la realidad.",
      ),
      Movie(
        title: "The Dark Knight",
        year: 2008,
        rating: "4.9",
        posterUrl:
            "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        shortSpoiler:
            "Batman enfrenta al Joker, un criminal que quiere sembrar el caos en Gotham.",
        longSpoiler:
            "Cuando el Joker, un criminal sin escrúpulos que causa caos y destrucción en la ciudad de Gotham, aparece en escena, Batman debe aceptar uno de los mayores desafíos psicológicos y físicos para luchar contra la injusticia.",
      ),
      Movie(
        title: "The Matrix",
        year: 1999,
        rating: "4.8",
        posterUrl:
            "https://image.tmdb.org/t/p/w500/vgpXmVaVyUL7IvWtW8k5aIso2KA.jpg",
        shortSpoiler:
            "Un hacker descubre la verdad sobre su realidad y la guerra contra máquinas que controlan su mundo.",
        longSpoiler:
            "Un programador de computadoras descubre que la realidad en la que vive es en realidad una simulación creada por máquinas inteligentes para distraer a los humanos mientras estos son utilizados como fuente de energía.",
      ),
      Movie(
        title: "Pulp Fiction",
        year: 1994,
        rating: "4.5",
        posterUrl:
            "https://image.tmdb.org/t/p/w500/plnlrtBUUqjSRowBQwLSineQsdG.jpg",
        shortSpoiler:
            "Historias entrelazadas de criminales, boxeadores y gángsters en Los Ángeles.",
        longSpoiler:
            "Una colección de historias de crímenes no lineales que se entrecruzan en Los Ángeles. Quentin Tarantino presenta diálogos memorables, violencia estilizada y personajes icónicos.",
      ),
    ];
  }
}