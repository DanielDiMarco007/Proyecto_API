class Movie {

  final String title;
  final int year;
  final String posterUrl;
  final String rating;
  final String shortSpoiler;
  final String longSpoiler;

  Movie({
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.rating,
    required this.shortSpoiler,
    required this.longSpoiler,
  });

  /// Convierte JSON en objeto Movie
  factory Movie.fromJson(Map<String, dynamic> json) {

    return Movie(
      title: json["title"],
      year: json["year"],
      posterUrl: json["poster_url"],
      rating: json["imdb rating"],
      shortSpoiler: json["spoilers"]["short_version"],
      longSpoiler: json["spoilers"]["long_version"],
    );
  }
}