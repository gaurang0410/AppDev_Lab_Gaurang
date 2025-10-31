// This screen displays the full details of a selected cocktail.
import 'package:flutter/material.dart';
import '../models/cocktail.dart';

class DetailScreen extends StatelessWidget {
  final Cocktail cocktail;

  const DetailScreen({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cocktail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cocktail.thumbnailUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Ingredients Section
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            // Display each ingredient as a bullet point
            for (var ingredient in cocktail.ingredients)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(ingredient, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),

            // Instructions Section
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              cocktail.instructions,
              style: const TextStyle(fontSize: 16, height: 1.5), // Improved line spacing
            ),
          ],
        ),
      ),
    );
  }
}