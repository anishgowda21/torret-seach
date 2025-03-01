import 'package:flutter/material.dart';
import 'package:my_app/services/l1337x_search_service.dart';
import 'package:my_app/services/search_service_provider.dart';
import 'package:my_app/widgets/l1337x_search_parameters.dart';
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
    final currentService = _serviceProvider.currentService;
    final bool isL1337xService = currentService.serviceId == 'l1337x';

    return Scaffold(
      // Creamy Background
      backgroundColor: const Color(0xFFF8F1E9),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Torrent Search",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 2,
                    color: const Color(0xFFD4AF37),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Center(
                            child: ServiceSelectionDropdown(
                              serviceProvider: _serviceProvider,
                              onServiceChanged: (service) {
                                setState(() {
                                  _serviceProvider.currentService = service;
                                  _errorMessage = null;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (isL1337xService)
                          L1337xSearchParameters(
                            service: currentService as L1337xSearchService,
                          ),

                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              hintText:
                                  "Search ${_serviceProvider.currentService.serviceName}...",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              prefixIcon: Icon(
                                _serviceProvider.currentService.serviceIcon,
                                color: const Color(0xFFD4AF37), // Gold icon
                              ),
                              errorText: _errorMessage,
                              errorStyle: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _performSearch(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFD4AF37), // Gold
                                const Color(0xFFF8E8B0), // Light gold/ivory
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _performSearch,
                            icon:
                                _isLoading
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black87,
                                            ),
                                      ),
                                    )
                                    : Icon(
                                      _serviceProvider
                                          .currentService
                                          .serviceIcon,
                                      color: Colors.black87,
                                    ),
                            label: Text(
                              _isLoading ? 'Searching...' : 'Search',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

    setState(() {
      _errorMessage = null;
    });

    _searchFocusNode.unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final service = _serviceProvider.currentService;
      final results = await service.search(query);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    service.createResultsScreen(results: results, query: query),
          ),
        ).then((_) {
          if (mounted) {
            _searchController.clear();
            if (service is L1337xSearchService) {
              service.resetSearchParameters();
            }
          }
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
