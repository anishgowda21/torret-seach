import 'package:flutter/material.dart';
import 'package:torret_seach/model/l1337x_search_result.dart';
import 'package:torret_seach/screens/base_results_screen.dart';
import 'package:torret_seach/services/l1337x_search_service.dart';
import 'package:torret_seach/widgets/l1337x_torrent_card.dart';
import 'package:torret_seach/widgets/pagination_control.dart';

class L1337xResultsScreen extends BaseResultsScreen<L1337xTorrentItem> {
  final L1337xSearchResult initialResults;
  final L1337xSearchService service;

  L1337xResultsScreen({
    super.key,
    required this.initialResults,
    required super.initialQuery,
    required this.service,
  }) : super(
         initialItems: initialResults.results,
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
  bool _loadingPage = false;

  @override
  void initState() {
    super.initState();
    final l1337xScreen = widget as L1337xResultsScreen;
    _service = l1337xScreen.service;

    // Store pagination data from initial results
    _currentPage = l1337xScreen.initialResults.pagination.currentPage;
    _totalPages = l1337xScreen.initialResults.pagination.lastPage;

    // Make sure service has the correct current page
    _service.currentPage = _currentPage;
  }

  @override
  String get appBarTitle => '1337x Results';

  @override
  Future<void> performSearch(String query) async {
    _loadPage(1, query);
  }

  @override
  Widget buildListItem(BuildContext context, L1337xTorrentItem item) {
    return L1337xTorrentCard(torrent: item, service: _service);
  }

  @override
  Widget build(BuildContext context) {
    // Get the base widget without modifications
    final Widget baseWidget = super.build(context);

    // Extract the scaffold from the base widget
    if (baseWidget is Scaffold) {
      // Create a new scaffold with our modifications
      return Scaffold(
        appBar: baseWidget.appBar,
        body: Column(
          children: [
            Expanded(child: baseWidget.body ?? Container()),
            // Always show pagination controls if there are results
            if (items.isNotEmpty)
              PaginationControl(
                currentPage: _currentPage,
                // Ensure total pages is at least equal to current page
                totalPages:
                    _totalPages > _currentPage ? _totalPages : _currentPage,
                onPageChanged: (page) => _loadPage(page, searchController.text),
                isLoading: _loadingPage,
              ),
          ],
        ),
      );
    }

    // Fallback to the original widget if it's not a scaffold
    return baseWidget;
  }

  Future<void> _loadPage(int page, String query) async {
    if (_loadingPage) return;

    setState(() {
      _loadingPage = true;
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Perform search with specified page
      final newResults = await _service.search(query, page: page);

      if (mounted) {
        setState(() {
          items = newResults.results;
          _currentPage = newResults.pagination.currentPage;

          // Ensure lastPage is at least equal to currentPage
          // This fixes instances where API returns incorrect lastPage value
          _totalPages = Math.max(
            newResults.pagination.lastPage,
            newResults.pagination.currentPage,
          );

          totalResults = newResults.pagination.perPageResults;
          isLoading = false;
          _loadingPage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = formatError(e);
          isLoading = false;
          _loadingPage = false;
        });
      }
    }
  }
}

// Helper for Math operations (like Math.max)
class Math {
  static int max(int a, int b) => a > b ? a : b;
}
