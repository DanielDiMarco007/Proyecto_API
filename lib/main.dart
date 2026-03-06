import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'detalle_screen.dart';
import 'services/favorites_service.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Películas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 1,
          centerTitle: true,
        ),
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.tealAccent,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class Pelicula {
  final String titulo;
  final String descripcion;
  final String imagen;
  final String director;
  final int anio;
  final double rating;

  Pelicula({
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.director,
    required this.anio,
    required this.rating,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Pelicula> _allPeliculas;
  late List<Pelicula> _filteredPeliculas;
  final TextEditingController _searchController = TextEditingController();
  bool _isGrid = false;
  bool _sortByRating = false;
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();

    _allPeliculas = [
      Pelicula(
        titulo: "Interstellar",
        descripcion:
            "Un grupo de astronautas viaja a través de un agujero de gusano en busca de un nuevo hogar para la humanidad.",
        imagen:
            "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
        director: "Christopher Nolan",
        anio: 2014,
        rating: 4.7,
      ),
      Pelicula(
        titulo: "Inception",
        descripcion:
            "Un ladrón roba secretos corporativos entrando en los sueños de las personas.",
        imagen:
            "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
        director: "Christopher Nolan",
        anio: 2010,
        rating: 4.6,
      ),
      Pelicula(
        titulo: "The Dark Knight",
        descripcion:
            "Batman enfrenta al Joker, un criminal que quiere sembrar el caos en Gotham.",
        imagen:
            "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
        director: "Christopher Nolan",
        anio: 2008,
        rating: 4.9,
      ),
    ];

    _filteredPeliculas = List.of(_allPeliculas);
    _searchController.addListener(_onSearchChanged);
    _loadPreferences();
    // load favorites
    FavoritesService.instance.load();
    FavoritesService.instance.favorites.addListener(_onFavoritesChanged);
  }

  void _onFavoritesChanged() {
    if (_showOnlyFavorites) {
      _applyFilters();
    }
  }

  void _applyFilters() {
    final q = _searchController.text.toLowerCase().trim();
    List<Pelicula> list = List.of(_allPeliculas);
    if (q.isNotEmpty) {
      list = list.where((p) => p.titulo.toLowerCase().contains(q) || p.descripcion.toLowerCase().contains(q)).toList();
    }
    if (_showOnlyFavorites) {
      final favs = FavoritesService.instance.favorites.value;
      list = list.where((p) => favs.contains(p.imagen)).toList();
    }
    if (_sortByRating) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    setState(() {
      _filteredPeliculas = list;
    });
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final val = prefs.getBool('isGrid') ?? false;
      setState(() {
        _isGrid = val;
      });
    } catch (_) {
      // ignore errors and keep default
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _allPeliculas.shuffle();
      _filteredPeliculas = List.of(_allPeliculas);
      _searchController.clear();
    });
  }

  void _toggleView() async {
    setState(() {
      _isGrid = !_isGrid;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isGrid', _isGrid);
    } catch (_) {
      // ignore write errors
    }
  }

  void _toggleSortByRating() {
    setState(() {
      _sortByRating = !_sortByRating;
      if (_sortByRating) {
        _filteredPeliculas.sort((a, b) => b.rating.compareTo(a.rating));
      } else {
        _filteredPeliculas = List.of(_allPeliculas);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final showGrid = _isGrid || isWide;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Películas"),
        actions: [
          IconButton(
            tooltip: _showOnlyFavorites ? 'Mostrar todo' : 'Mostrar favoritos',
            onPressed: () {
              setState(() {
                _showOnlyFavorites = !_showOnlyFavorites;
                _applyFilters();
              });
            },
            icon: Icon(_showOnlyFavorites ? Icons.favorite : Icons.favorite_border, color: _showOnlyFavorites ? Colors.redAccent : Colors.white),
          ),
          IconButton(
            tooltip: _isGrid ? 'Ver como lista' : 'Ver como cuadrícula',
            onPressed: _toggleView,
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleSortByRating,
        icon: Icon(_sortByRating ? Icons.star : Icons.sort),
        label: Text(_sortByRating ? 'Top rated' : 'Ordenar por rating'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar películas...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: showGrid
                  ? GridView.builder(
                      key: const ValueKey('grid'),
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWide ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: _filteredPeliculas.length,
                      itemBuilder: (context, index) {
                        final pelicula = _filteredPeliculas[index];
                        return _buildGridCard(context, pelicula);
                      },
                    )
                  : ListView.separated(
                      key: const ValueKey('list'),
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredPeliculas.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final pelicula = _filteredPeliculas[index];
                        return _buildListTile(context, pelicula);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, Pelicula pelicula) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleScreen(
              titulo: pelicula.titulo,
              imagen: pelicula.imagen,
              descripcion: pelicula.descripcion,
              director: pelicula.director,
              anio: pelicula.anio,
              rating: pelicula.rating,
            ),
          ),
        ),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: pelicula.imagen,
                    child: Semantics(
                      label: '${pelicula.titulo} poster',
                      child: CachedNetworkImage(
                        imageUrl: pelicula.imagen,
                        width: 120,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[900]!,
                          highlightColor: Colors.grey[800]!,
                          child: Container(
                            width: 120,
                            height: double.infinity,
                            color: Colors.grey[900],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 120,
                          color: Colors.grey[900],
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: FavoritesService.instance.favorites,
                      builder: (context, favs, _) {
                        final fav = favs.contains(pelicula.imagen);
                        return GestureDetector(
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await FavoritesService.instance.toggle(pelicula.imagen);
                            if (!mounted) return;
                            messenger.showSnackBar(SnackBar(content: Text(fav ? 'Eliminado de favoritos' : 'Añadido a favoritos')));
                            if (_showOnlyFavorites) _applyFilters();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: fav ? Colors.black54 : Colors.black38, borderRadius: BorderRadius.circular(20)),
                            child: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : Colors.white70, size: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pelicula.titulo,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${pelicula.director} • ${pelicula.anio}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pelicula.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, Pelicula pelicula) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleScreen(
              titulo: pelicula.titulo,
              imagen: pelicula.imagen,
              descripcion: pelicula.descripcion,
              director: pelicula.director,
              anio: pelicula.anio,
              rating: pelicula.rating,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: pelicula.imagen,
                    child: Semantics(
                      label: '${pelicula.titulo} poster',
                      child: CachedNetworkImage(
                        imageUrl: pelicula.imagen,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[900]!,
                          highlightColor: Colors.grey[800]!,
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey[900],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[900],
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: FavoritesService.instance.favorites,
                      builder: (context, favs, _) {
                        final fav = favs.contains(pelicula.imagen);
                        return GestureDetector(
                          onTap: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await FavoritesService.instance.toggle(pelicula.imagen);
                            if (!mounted) return;
                            messenger.showSnackBar(SnackBar(content: Text(fav ? 'Eliminado de favoritos' : 'Añadido a favoritos')));
                            if (_showOnlyFavorites) _applyFilters();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: fav ? Colors.black54 : Colors.black38, borderRadius: BorderRadius.circular(20)),
                            child: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.redAccent : Colors.white70, size: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pelicula.titulo,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RatingBarIndicator(
                            rating: pelicula.rating,
                            itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 12.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(height: 2),
                          Text(pelicula.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.amber, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  Text("${pelicula.director} • ${pelicula.anio}", style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  const SizedBox(height: 4),
                  Text(pelicula.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}