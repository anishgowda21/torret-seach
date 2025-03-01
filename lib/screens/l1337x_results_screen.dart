import 'package:flutter/material.dart';
import 'package:my_app/model/l1337x_search_result.dart';
import 'package:my_app/screens/base_results_screen.dart';
import 'package:my_app/services/l1337x_search_service.dart';
import 'package:my_app/widgets/l1337x_torrent_card.dart';

class L1337xResultsScreen extends BaseResultsScreen<L1337xTorrentItem> {
  final L1337xSearchResult initialResults;
  final L1337xSearchService service;

  L1337xResultsScreen({
    Key? key,
    required this.initialResults,
    required String initialQuery,
    required this.service,
  }) : super(
         key: key,
         initialItems: initialResults.results,
         initialQuery: initialQuery,
         totalResults: initialResults.pagination.perPageResults,
       );

  @override
  L1337xResultsScreenState createState() => L1337xResultsScreenState();
}

class L1337xResultsScreenState
    extends BaseResultsScreenState<L1337xTorrentItem> {
  late L1337xSearchService _service;
  int _currentPage = 1;
  int _totalPages = 1;
  String? _category;
  String? _sort;
  String? _order;

  @override
  void initState() {
    super.initState();
    final l1337xScreen = widget as L1337xResultsScreen;
    _service = l1337xScreen.service;

    // Store pagination and filter data from initial results
    _currentPage = l1337xScreen.initialResults.pagination.currentPage;
    _totalPages = l1337xScreen.initialResults.pagination.lastPage;
    _category = l1337xScreen.initialResults.filters.category;
    _sort = l1337xScreen.initialResults.filters.sort;
    _order = l1337xScreen.initialResults.filters.order;
  }

  @override
  String get appBarTitle => '1337x Results';

  @override
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Apply any saved filters
      if (_category != null && _category != 'All') {
        _service.category = _category;
      }
      if (_sort != null) {
        _service.sort = _sort;
      }
      if (_order != null) {
        _service.order = _order;
      }

      final newResults = await _service.search(query);

      if (mounted) {
        setState(() {
          items = newResults.results;
          _currentPage = newResults.pagination.currentPage;
          _totalPages = newResults.pagination.lastPage;
          totalResults = newResults.results.length;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = formatError(e);
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget buildListItem(BuildContext context, L1337xTorrentItem item) {
    return L1337xTorrentCard(torrent: item, service: _service);
  }

  @override
  Widget build(BuildContext context) {
    final resultListWidget = super.build(context);

    // If we have multiple pages, add pagination controls
    if (_totalPages > 1) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(child: resultListWidget),
            _buildPaginationControls(),
          ],
        ),
      );
    }

    return resultListWidget;
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page info
          Text(
            'Page $_currentPage of $_totalPages',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),

          // Navigation buttons
          Row(
            children: [
              // Previous page button
              IconButton(
                onPressed: _currentPage > 1 ? _goToPreviousPage : null,
                icon: Icon(Icons.arrow_back_ios, size: 18),
                color: _currentPage > 1 ? const Color(0xFFD4AF37) : Colors.grey,
              ),

              // Next page button
              IconButton(
                onPressed: _currentPage < _totalPages ? _goToNextPage : null,
                icon: Icon(Icons.arrow_forward_ios, size: 18),
                color:
                    _currentPage < _totalPages
                        ? const Color(0xFFD4AF37)
                        : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _loadPage(_currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      _loadPage(_currentPage + 1);
    }
  }

  Future<void> _loadPage(int page) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Apply any saved filters
      if (_category != null && _category != 'All') {
        _service.category = _category;
      }
      if (_sort != null) {
        _service.sort = _sort;
      }
      if (_order != null) {
        _service.order = _order;
      }

      // Add page parameter to the URL
      final query = searchController.text;
      final newResults = await _service.search(query);

      if (mounted) {
        setState(() {
          items = newResults.results;
          _currentPage = newResults.pagination.currentPage;
          _totalPages = newResults.pagination.lastPage;
          totalResults = newResults.pagination.perPageResults;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = formatError(e);
          isLoading = false;
        });
      }
    }
  }
}
