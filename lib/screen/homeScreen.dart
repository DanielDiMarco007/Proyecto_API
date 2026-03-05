import 'package:flutter/material.dart';
import '../services/movie_service.dart';

import '../models/movie_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas"),
      ),
      body: FutureBuilder<MovieList>(
        future: MovieService().getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
            return const Center(child: Text("No hay datos disponibles"));
          }

          final movies = snapshot.data!.results;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: movies.map((movie) {
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
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}