import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Películas"),
      ),
      body: const Center(
        child: Text(
          "Aquí aparecerá la lista de películas",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}