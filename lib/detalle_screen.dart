import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetalleScreen extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagen;
  final double? rating;

  /// Constructor compatible with both Spanish and English named parameters.
  ///
  /// Accepts either (titulo, descripcion, imagen) or (title, description, image).
  /// Asserts that each required value is provided in at least one form.
  DetalleScreen({
    super.key,
    String? titulo,
    String? descripcion,
    String? imagen,
    double? rating,
    double? score,
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
  imagen = imagen ?? image!,
  rating = rating ?? score;

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
              child: Semantics(
                label: '$titulo poster',
                child: SizedBox(
                  width: double.infinity,
                  height: 260,
                  child: CachedNetworkImage(
                    imageUrl: imagen,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[900]!,
                      highlightColor: Colors.grey[800]!,
                      child: Container(
                        width: double.infinity,
                        height: 260,
                        color: Colors.grey[900],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
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
            if (rating != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating: rating!,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rating!.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.amber, fontSize: 16),
                    ),
                  ],
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