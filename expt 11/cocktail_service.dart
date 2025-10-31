// This file contains all the logic for interacting with TheCocktailDB API.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail.dart';

class CocktailService {
  final String _baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1/';

  // Fetches a list of cocktails based on a search query.
  Future<List<Cocktail>> searchCocktails(String query) async {
    final response = await http.get(Uri.parse('${_baseUrl}search.php?s=$query'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // The API returns {'drinks': null} if no cocktail is found.
      if (data['drinks'] == null) {
        return [];
      }
      final List drinks = data['drinks'];
      return drinks.map((drink) => Cocktail.fromJson(drink)).toList();
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  // Fetches 10 random cocktails to display on the home screen initially.
  Future<List<Cocktail>> getRandomCocktails() async {
    try {
      // Create a list of 10 futures, each fetching one random cocktail.
      List<Future<Cocktail>> futures = List.generate(10, (_) => _fetchSingleRandomCocktail());
      // Wait for all futures to complete.
      final cocktails = await Future.wait(futures);
      return cocktails;
    } catch (e) {
      throw Exception('Failed to load random cocktails: $e');
    }
  }

  // Helper method to fetch a single random cocktail.
  Future<Cocktail> _fetchSingleRandomCocktail() async {
     final response = await http.get(Uri.parse('${_baseUrl}random.php'));
     if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Cocktail.fromJson(data['drinks'][0]);
     } else {
       throw Exception('Failed to load a random cocktail');
     }
  }
}