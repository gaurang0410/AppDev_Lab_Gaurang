// This is the main screen of the app. It contains the search bar and the list of cocktails.
import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../services/cocktail_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CocktailService _cocktailService = CocktailService();
  final TextEditingController _searchController = TextEditingController();

  List<Cocktail> _cocktails = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialCocktails();
  }

  Future<void> _loadInitialCocktails() async {
    try {
      final cocktails = await _cocktailService.getRandomCocktails();
      setState(() {
        _cocktails = cocktails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load cocktails. Please check your connection.";
        _isLoading = false;
      });
    }
  }

  Future<void> _searchCocktails(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final cocktails = await _cocktailService.searchCocktails(query);
      setState(() {
        _cocktails = cocktails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to find cocktails. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocktail Finder'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a cocktail...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _searchCocktails,
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    if (_cocktails.isEmpty) {
      return const Center(child: Text('No cocktails found. Try a different search!'));
    }
    return ListView.builder(
      itemCount: _cocktails.length,
      itemBuilder: (context, index) {
        final cocktail = _cocktails[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cocktail.thumbnailUrl),
            ),
            title: Text(cocktail.name),
            onTap: () {
              // Navigate to the detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(cocktail: cocktail),
                ),
              );
            },
          ),
        );
      },
    );
  }
}