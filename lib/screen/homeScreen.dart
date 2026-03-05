import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie.dart';

/// Pantalla principal mostrando la lista de películas con diseño mejorado
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas"),
      ),
      body: FutureBuilder<List<Movie>>(
        future: MovieService().getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay datos disponibles"));
          }

          final movies = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Poster más grande
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.movie, size: 40),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Información de la película
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Año: ${movie.year}"),
                            Text("Rating: ${movie.rating} ⭐"),
                            const SizedBox(height: 6),
                            Text(
                              movie.shortSpoiler,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}