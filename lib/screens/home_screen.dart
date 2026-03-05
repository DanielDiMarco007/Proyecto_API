import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de películas"),
      ),
      body: Center(
        child: Text(
          "Aquí aparecerá la API",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}