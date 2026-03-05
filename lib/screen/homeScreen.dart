import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie.dart';

/// Pantalla principal que muestra la lista de películas
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
          // Mientras se cargan los datos
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si ocurre un error
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Si no hay datos
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay datos disponibles"));
          }

          final movies = snapshot.data!;

          // Lista scrollable eficiente
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              // Cada película en una tarjeta
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: ListTile(
                  leading: Image.network(
                    movie.posterUrl,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.movie);
                    },
                  ),
                  title: Text(movie.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Año: ${movie.year}"),
                      Text("Rating: ${movie.rating}"),
                      Text(
                        movie.shortSpoiler,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}