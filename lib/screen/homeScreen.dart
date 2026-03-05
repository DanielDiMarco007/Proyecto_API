// Importa la librería principal de Flutter para construir interfaces
import 'package:flutter/material.dart';

// Importa el servicio que se encarga de consumir la API de películas
import '../services/movie_service.dart';

// Clase principal de la pantalla de inicio
// StatelessWidget significa que la pantalla no maneja estados internos
class HomeScreen extends StatelessWidget {

  // Constructor constante para optimizar el rendimiento del widget
  const HomeScreen({super.key});

  // Método build: aquí se construye toda la interfaz gráfica
  @override
  Widget build(BuildContext context) {

    // Scaffold es la estructura base de una pantalla en Flutter
    return Scaffold(

      // Barra superior de la aplicación
      appBar: AppBar(
        title: const Text("Películas"),
      ),

      // Body será el contenido principal
      body: const Center(
        child: Text("Cargando películas..."),
      ),
    );
  }
}