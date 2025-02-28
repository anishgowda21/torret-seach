// search_screen.dart
import 'package:flutter/material.dart';
import 'package:my_app/services/search_service_provider.dart';
import 'package:my_app/widgets/service_selection_dropdown.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isLoading = false;
  final SearchServiceProvider _serviceProvider = SearchServiceProvider();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("T Search")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Service selection dropdown
              ServiceSelectionDropdown(
                serviceProvider: _serviceProvider,
                onServiceChanged: (service) {
                  setState(() {
                    _serviceProvider.currentService = service;
                    // Update hint text when service changes
                    _errorMessage = null;
                  });
                },
              ),
              SizedBox(height: 16),
              // Search input field
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText:
                      "Search ${_serviceProvider.currentService.serviceName}...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(_serviceProvider.currentService.serviceIcon),
                  errorText: _errorMessage,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _performSearch(),
              ),
              SizedBox(height: 16),
              // Search button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _performSearch,
                icon:
                    _isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Icon(_serviceProvider.currentService.serviceIcon),
                label: Text(_isLoading ? 'Searching...' : 'Search'),
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
    if (query.trim().isEmpty) {
      setState(() {
        _errorMessage = "Please enter a search term";
      });
      return;
    }

    // Clear error if any
    setState(() {
      _errorMessage = null;
    });

    // Dismiss keyboard
    _searchFocusNode.unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final service = _serviceProvider.currentService;
      final results = await service.search(query);

      if (mounted) {
        // The service knows how to create the appropriate screen for its results
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    service.createResultsScreen(results: results, query: query),
          ),
        ).then((_) {
          if (mounted) _searchController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _formatError(e);
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatError(dynamic e) {
    final message = e.toString();
    if (message.contains('internet')) {
      return 'Please check your internet connection';
    } else if (message.contains('timed out')) {
      return 'The request took too long. Try again';
    }
    return 'Error: ${message.replaceAll('Exception: ', '')}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
