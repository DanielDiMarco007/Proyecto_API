import 'package:flutter/material.dart';
import 'detalle_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetalleScreen(
        titulo: "Interstellar",
        imagen: "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
        descripcion:
            "Un grupo de astronautas viaja a través de un agujero de gusano cerca de Saturno en busca de un nuevo hogar para la humanidad mientras la Tierra enfrenta una crisis ambiental.",
      ),
    );
  }
}