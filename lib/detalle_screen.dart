import 'package:flutter/material.dart';

class DetalleScreen extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  const DetalleScreen({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// POSTER CON GRADIENTE
            Stack(
              children: [

                Image.network(
                  image,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),

                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// INFORMACIÓN DE LA PELÍCULA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [

                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 5),
                  Text(
                    "8.6",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(width: 20),

                  Icon(Icons.calendar_today, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "2014",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(width: 20),

                  Icon(Icons.access_time, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    "2h 49m",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// DESCRIPCIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// BOTÓN VER TRAILER
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "Ver Trailer",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}