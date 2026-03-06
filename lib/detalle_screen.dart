import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Professional Detail Screen
class DetalleScreen extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagen;
  final double? rating;
  final String? director;
  final int? anio;

  const DetalleScreen({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    this.rating,
    this.director,
    this.anio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                titulo,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: imagen,
                    child: CachedNetworkImage(
                      imageUrl: imagen,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[900]!,
                        highlightColor: Colors.grey[800]!,
                        child: Container(color: Colors.grey[900]),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[900],
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, size: 56, color: Colors.white54),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0.0, -24.0, 0.0),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: theme.cardColor,
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  titulo,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    if (director != null && director!.isNotEmpty)
                                      Chip(
                                        backgroundColor: Colors.white12,
                                        label: Text(director!, style: TextStyle(color: Colors.grey[100])),
                                      ),
                                    if (anio != null)
                                      Chip(
                                        backgroundColor: Colors.white12,
                                        label: Text(anio.toString(), style: TextStyle(color: Colors.grey[100])),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (rating != null)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RatingBarIndicator(
                                  rating: rating!,
                                  itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                                  itemCount: 5,
                                  itemSize: 22.0,
                                ),
                                const SizedBox(height: 6),
                                Text(rating!.toStringAsFixed(1), style: const TextStyle(color: Colors.amber)),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border),
                            label: const Text('Favorito'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                            label: const Text('Compartir'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(color: Colors.white12),
                      const SizedBox(height: 12),

                      const Text('Sinopsis', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(descripcion, style: TextStyle(color: Colors.grey[300], fontSize: 14), textAlign: TextAlign.justify),
                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Chip(
                            avatar: const Icon(Icons.movie, size: 16, color: Colors.white70),
                            backgroundColor: Colors.white12,
                            label: Text('Duración: —', style: TextStyle(color: Colors.grey[200])),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            avatar: const Icon(Icons.language, size: 16, color: Colors.white70),
                            backgroundColor: Colors.white12,
                            label: Text('Idioma: —', style: TextStyle(color: Colors.grey[200])),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 