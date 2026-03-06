import 'package:flutter/material.dart';
import 'detalle_screen.dart';

class HomeDetalleSample extends StatelessWidget {
  final List movies = [
    {
      "title": "Interstellar",
      "image":
          "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
      "description":
          "Un grupo de exploradores viaja a través de un agujero de gusano en el espacio."
    },
    {
      "title": "Inception",
      "image":
          "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
      "description":
          "Un ladrón roba secretos corporativos usando tecnología de sueños."
    },
    {
      "title": "The Matrix",
      "image":
          "https://image.tmdb.org/t/p/w500/aOIuZAjPaRIE6CMzbazvcHuHXDc.jpg",
      "description":
          "Un hacker descubre la verdad sobre su realidad."
    },
  ];

  HomeDetalleSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),

              /// 👇 NAVEGACIÓN A DETALLE
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleScreen(
                      titulo: movie["title"],
                      imagen: movie["image"],
                      descripcion: movie["description"],
                    ),
                  ),
                );
              },

              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        movie["image"],
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        movie["title"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}