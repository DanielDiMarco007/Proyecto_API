import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'services/favorites_service.dart';

/// Professional Detail Screen
class DetalleScreen extends StatefulWidget {
  final String titulo;
  final String descripcion;
  final String imagen;
  final double? rating;
  final String? director;
  final int? anio;
  final String? trailer;

  const DetalleScreen({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    this.rating,
    this.director,
    this.anio,
    this.trailer,
  });

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  Timer? _pulseTimer;
  double _playScale = 1.0;
  // favorite status is driven by FavoritesService; local bool used only for initial state
  // remove local storage; rely on FavoritesService

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    // Start a simple periodic toggle for a subtle pulse using an implicit AnimatedScale
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      if (!mounted) return;
      setState(() {
        _playScale = (_playScale == 1.0) ? 1.06 : 1.0;
      });
    });
    // start the entrance animation
    _controller.forward();
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: ScaleTransition(
        scale: _opacity,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final url = widget.trailer;
            if (url == null || url.isEmpty) {
              messenger.showSnackBar(const SnackBar(content: Text('No hay trailer disponible')));
              return;
            }
            final uri = Uri.tryParse(url);
            if (uri == null) {
              messenger.showSnackBar(const SnackBar(content: Text('Trailer inválido')));
              return;
            }
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                messenger.showSnackBar(const SnackBar(content: Text('No se puede abrir el trailer')));
              }
            } catch (_) {
              messenger.showSnackBar(const SnackBar(content: Text('Error al intentar abrir el trailer')));
            }
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Ver trailer'),
          backgroundColor: Colors.tealAccent[700],
          foregroundColor: Colors.black,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            expandedHeight: 340,
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                widget.titulo,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.imagen,
                    child: CachedNetworkImage(
                      imageUrl: widget.imagen,
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
                        stops: [0.0, 0.6],
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                  // Play overlay centered on the hero image. Tapping will attempt to open the trailer.
                  FadeTransition(
                    opacity: _opacity,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final url = widget.trailer;
                          if (url == null || url.isEmpty) {
                            messenger.showSnackBar(const SnackBar(content: Text('No hay trailer disponible')));
                            return;
                          }
                          final uri = Uri.tryParse(url);
                          if (uri == null) {
                            messenger.showSnackBar(const SnackBar(content: Text('Trailer inválido')));
                            return;
                          }
                          try {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              messenger.showSnackBar(const SnackBar(content: Text('No se puede abrir el trailer')));
                            }
                          } catch (_) {
                            messenger.showSnackBar(const SnackBar(content: Text('Error al intentar abrir el trailer')));
                          }
                        },
                        child: AnimatedScale(
                          scale: _playScale,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.6 * 255).round()), blurRadius: 12, spreadRadius: 2)],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(Icons.play_arrow, size: 48, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _opacity,
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
                                      widget.titulo,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        if (widget.director != null && widget.director!.isNotEmpty)
                                          Chip(
                                            backgroundColor: Colors.white12,
                                            label: Text(widget.director!, style: TextStyle(color: Colors.grey[100])),
                                          ),
                                        if (widget.anio != null)
                                          Chip(
                                            backgroundColor: Colors.white12,
                                            label: Text(widget.anio.toString(), style: TextStyle(color: Colors.grey[100])),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              if (widget.rating != null)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RatingBarIndicator(
                                      rating: widget.rating!,
                                      itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 22.0,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(widget.rating!.toStringAsFixed(1), style: const TextStyle(color: Colors.amber)),
                                  ],
                                ),
                            ],
                          ),


                          const SizedBox(height: 14),

                          // Large rating + actions row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.rating != null)
                                Container(
                                  width: 92,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white12,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withAlpha((0.4 * 255).round()), blurRadius: 8, offset: const Offset(0, 3)),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RatingBarIndicator(
                                        rating: widget.rating!,
                                        itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                                        itemCount: 5,
                                        itemSize: 14.0,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(widget.rating!.toStringAsFixed(1), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Favorite button with scale animation
                                        ValueListenableBuilder<Set<String>>(
                                          valueListenable: FavoritesService.instance.favorites,
                                          builder: (context, favs, _) {
                                            final fav = favs.contains(widget.imagen);
                                            return TweenAnimationBuilder<double>(
                                              tween: Tween(begin: 1.0, end: fav ? 1.12 : 1.0),
                                              duration: const Duration(milliseconds: 220),
                                              builder: (context, scale, child) => Transform.scale(
                                                scale: scale,
                                                child: child,
                                              ),
                                              child: IconButton(
                                                onPressed: () async {
                                                  await FavoritesService.instance.toggle(widget.imagen);
                                                },
                                                icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : Colors.white70),
                                                tooltip: 'Marcar favorito',
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 6),
                                        IconButton(
                                          onPressed: () {
                                            final text = '${widget.titulo} - ${widget.descripcion}\n\n${widget.imagen}';
                                            Clipboard.setData(ClipboardData(text: text));
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Texto copiado al portapapeles (compartir)')));
                                          },
                                          icon: const Icon(Icons.share, color: Colors.white70),
                                          tooltip: 'Compartir (copiar)',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Director: ${widget.director ?? '—'}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          const Divider(color: Colors.white12),
                          const SizedBox(height: 12),

                          const Text('Sinopsis', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text(widget.descripcion, style: TextStyle(color: Colors.grey[300], fontSize: 14), textAlign: TextAlign.justify),
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
            ),
          ),
        ],
      ),
    );
  }
}
 