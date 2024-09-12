import 'package:flutter/material.dart';
import '../../model/cat.dart';

class CatDetail extends StatelessWidget {
  final Cat cat;

  CatDetail({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(child: Text(cat.name)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.transparent, // Color del borde
                  width: 4.0, // Ancho del borde
                ),
              ),
              child: Image.network(
                cat.imageurl != null && cat.imageurl!.isNotEmpty
                    ? cat.imageurl!
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat.description),
                  SizedBox(height: 8.0),
                  Text(
                    'País de origen: ${cat.origin}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Inteligencia: ${cat.intelligence}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Adaptabilidad: ${cat.adaptability}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'ESperanza de vida: ${cat.lifeSpan}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
