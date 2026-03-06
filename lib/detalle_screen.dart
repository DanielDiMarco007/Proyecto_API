import 'package:flutter/material.dart';

class DetalleScreen extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagen;

  /// Constructor compatible with both Spanish and English named parameters.
  ///
  /// Accepts either (titulo, descripcion, imagen) or (title, description, image).
  /// Asserts that each required value is provided in at least one form.
  DetalleScreen({
    super.key,
    String? titulo,
    String? descripcion,
    String? imagen,
    String? title,
    String? description,
    String? image,
  })  : assert(titulo != null || title != null,
            'Debe proporcionar `titulo` o `title`'),
        assert(descripcion != null || description != null,
            'Debe proporcionar `descripcion` o `description`'),
        assert(imagen != null || image != null,
            'Debe proporcionar `imagen` o `image`'),
  titulo = titulo ?? title!,
  descripcion = descripcion ?? description!,
  imagen = imagen ?? image!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Constrain image height to avoid overflow on small screens
            Hero(
              tag: imagen,
              child: SizedBox(
                width: double.infinity,
                height: 260,
                child: Image.network(
                  imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: Colors.grey[900],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                descripcion,
                style: TextStyle(fontSize: 16, color: Colors.grey[300]),
              ),
            ),
        ],
        ),
      ),
    );
  }
}