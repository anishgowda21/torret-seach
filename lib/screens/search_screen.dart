import 'package:flutter/material.dart';
import 'package:my_app/screens/yts_results_screen.dart';
import 'package:my_app/services/yts_api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  final YtsApiService _apiService = YtsApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Search")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Movies....",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _performSearch,
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() async {
    if (_isLoading) return;
    String query = _searchController.text;
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchMovies(query);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => YtsResultsScreen(
                  initialResults: results,
                  initialQuery: query,
                ),
          ),
        ).then((_) {
          if (mounted) _searchController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        // Guard ScaffoldMessenger
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
