/// Clase que representa una película dentro de la aplicación.
/// Este modelo se usa para convertir los datos recibidos desde la API
/// (en formato JSON) en un objeto que Flutter puede utilizar.
class Movie {

  /// Título de la película
  final String title;

  /// Año de lanzamiento de la película
  final int year;

  /// URL del póster o imagen de la película
  final String posterUrl;

  /// Calificación de la película (por ejemplo, rating de IMDB)
  final String rating;

  /// Descripción corta de la película
  final String shortSpoiler;

  /// Descripción larga o explicación más detallada
  final String longSpoiler;

  /// Constructor de la clase Movie.
  /// Se utiliza para crear un objeto Movie con todos los datos necesarios.
  Movie({
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.rating,
    required this.shortSpoiler,
    required this.longSpoiler,
  });

  /// Método factory que convierte un JSON en un objeto Movie.
  /// Se usa cuando los datos vienen de una API.
  ///
  /// El JSON recibido debe tener esta estructura aproximada:
  /// {
  ///   "title": "Nombre de la película",
  ///   "year": 2020,
  ///   "poster_url": "https://...",
  ///   "imdb rating": "8.5",
  ///   "spoilers": {
  ///       "short_version": "...",
  ///       "long_version": "..."
  ///   }
  /// }
  factory Movie.fromJson(Map<String, dynamic> json) {

    return Movie(
      /// Obtiene el título de la película desde el JSON
      title: json["title"],

      /// Obtiene el año de lanzamiento
      year: json["year"],

      /// Obtiene la URL del póster
      posterUrl: json["poster_url"],

      /// Obtiene la calificación de IMDB
      rating: json["imdb rating"],

      /// Obtiene la versión corta del spoiler
      shortSpoiler: json["spoilers"]["short_version"],

      /// Obtiene la versión larga del spoiler
      longSpoiler: json["spoilers"]["long_version"],
    );
  }
}