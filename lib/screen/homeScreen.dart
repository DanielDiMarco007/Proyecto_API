import 'package:flutter/material.dart'; // Importa Flutter y widgets básicos
import '../services/movie_service.dart';  // Importa el servicio para consumir la API
import '../models/movie.dart';           // Importa el modelo Movie

/// Pantalla principal de la aplicación que muestra la lista de películas.
/// 
/// Esta pantalla:
/// - Consume la API usando MovieService().getMovies()
/// - Maneja estados: cargando, error o sin datos
/// - Muestra cada película en un Card con:
///   - Poster de la película
///   - Título
///   - Año de lanzamiento
///   - Rating con estrella
///   - Short spoiler limitado a 3 líneas
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Constructor de la pantalla

  @override
  Widget build(BuildContext context) {
    // Scaffold crea la estructura base de la pantalla
    return Scaffold(
      // AppBar con el título de la aplicación
      appBar: AppBar(
        title: const Text("Películas"),
      ),

      // Body principal con FutureBuilder
      body: FutureBuilder<List<Movie>>(
        // Llama a la función que obtiene la lista de películas
        future: MovieService().getMovies(),

        // Builder que se ejecuta dependiendo del estado del Future
        builder: (context, snapshot) {
          // Mientras se cargan los datos, mostrar un indicador circular
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si ocurre un error, mostrar mensaje en pantalla
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Si no hay datos o la lista está vacía
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay datos disponibles"));
          }

          // Obtenemos la lista de películas
          final movies = snapshot.data!;

          // ListView.builder crea una lista scrollable eficiente
          return ListView.builder(
            padding: const EdgeInsets.all(16), // Padding alrededor de toda la lista
            itemCount: movies.length,          // Número de elementos en la lista
            itemBuilder: (context, index) {
              // Obtenemos cada película por índice
              final movie = movies[index];

              // Cada película se representa en un Card
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10), // Margen vertical entre tarjetas
                elevation: 5,                                     // Sombra de la tarjeta
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),      // Bordes redondeados
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),           // Padding interno de la tarjeta
                  child: Row(
                    children: [
                      // Poster de la película
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Bordes del poster
                        child: Image.network(
                          movie.posterUrl,                    // URL de la imagen
                          width: 80,                           // Ancho del poster
                          height: 120,                         // Alto del poster
                          fit: BoxFit.cover,                   // Ajusta la imagen al espacio
                          // Si la imagen falla, muestra un icono de película
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey[300],        // Fondo gris
                              child: const Icon(Icons.movie, size: 40),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12), // Espacio entre poster e información

                      // Información textual de la película
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título de la película
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),  // Espacio entre título y año

                            // Año de lanzamiento
                            Text("Año: ${movie.year}"),

                            // Rating de la película con estrella
                            Text("Rating: ${movie.rating} ⭐"),

                            const SizedBox(height: 6), // Espacio antes del short spoiler

                            // Short spoiler limitado a 3 líneas con overflow
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