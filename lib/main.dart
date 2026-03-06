import 'package:flutter/material.dart';
import 'detalle_screen.dart';

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
        // Set a true black background
        scaffoldBackgroundColor: Colors.black,
        // Slightly lighter cards to stand out over black
        cardColor: const Color(0xFF1E1E1E),
        // AppBar matches the black background but with subtle elevation
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 1,
          centerTitle: true,
        ),
        // Accent color for controls
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: Colors.tealAccent,
            ),
        // Text theme: ensure bodies are white by default
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const HomeScreen(),
    );
  }
}

class Pelicula {
  final String titulo;
  final String descripcion;
  final String imagen;

  Pelicula({
    required this.titulo,
    required this.descripcion,
    required this.imagen,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Full data set
  late final List<Pelicula> _allPeliculas;
  // Filtered according to search
  late List<Pelicula> _filteredPeliculas;
  final TextEditingController _searchController = TextEditingController();
  bool _isGrid = false;

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
      ),
      Pelicula(
        titulo: "Inception",
        descripcion:
            "Un ladrón roba secretos corporativos entrando en los sueños de las personas.",
        imagen:
            "https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
      ),
      Pelicula(
        titulo: "The Dark Knight",
        descripcion:
            "Batman enfrenta al Joker, un criminal que quiere sembrar el caos en Gotham.",
        imagen:
            "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
      ),
    ];

    _filteredPeliculas = List.of(_allPeliculas);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredPeliculas = List.of(_allPeliculas);
      } else {
        _filteredPeliculas = _allPeliculas
            .where((p) =>
                p.titulo.toLowerCase().contains(q) ||
                p.descripcion.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  Future<void> _onRefresh() async {
    // Simulate refresh - in real app you'd re-fetch remote data
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      // For demo, we simply reverse the list briefly to show change
      _allPeliculas.shuffle();
      _filteredPeliculas = List.of(_allPeliculas);
      _searchController.clear();
    });
  }

  void _toggleView() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Películas"),
        actions: [
          IconButton(
            tooltip: _isGrid ? 'Ver como lista' : 'Ver como cuadrícula',
            onPressed: _toggleView,
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar películas...'.toLowerCase(),
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (!isWide)
                    IconButton(
                      onPressed: _onRefresh,
                      icon: const Icon(Icons.refresh),
                      color: Colors.white70,
                    ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isGrid || isWide
                    ? GridView.builder(
                        key: const ValueKey('grid'),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        itemCount: _filteredPeliculas.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final pelicula = _filteredPeliculas[index];
                          return _buildListTile(context, pelicula);
                        },
                      ),
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
      color: Theme.of(context).cardColor,
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
            ),
          ),
        ),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Hero(
                tag: pelicula.imagen,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    pelicula.imagen,
                    width: 120,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      width: 120,
                      color: Colors.grey[900],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pelicula.titulo,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pelicula.descripcion,
                        style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
      color: Theme.of(context).cardColor,
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
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Make image take the available vertical space first
            Expanded(
              child: Hero(
                tag: pelicula.imagen,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    pelicula.imagen,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: Colors.grey[900],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ),
            // Title + description in a fixed-height area to avoid overflow
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pelicula.titulo,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pelicula.descripcion,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}