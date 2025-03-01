import 'package:flutter/material.dart';
import 'package:my_app/widgets/results_list.dart';
import 'package:my_app/widgets/res_search_bar.dart';

abstract class BaseResultsScreen<T> extends StatefulWidget {
  final List<T> initialItems;
  final String initialQuery;
  final int? totalResults;

  const BaseResultsScreen({
    super.key,
    required this.initialItems,
    required this.initialQuery,
    this.totalResults,
  });

  @override
  State<BaseResultsScreen<T>> createState();
}

abstract class BaseResultsScreenState<T> extends State<BaseResultsScreen<T>> {
  late TextEditingController searchController;
  bool isLoading = false;
  String? errorMessage;
  late List<T> items;
  int? totalResults;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery);
    items = widget.initialItems;
    totalResults = widget.totalResults ?? items.length;
    if (items.isEmpty && !isLoading) {
      errorMessage = null;
    }
  }

  Future<void> performSearch(String query);
  Widget buildListItem(BuildContext context, T item);
  String get appBarTitle;

  String formatError(dynamic e) {
    if (e.toString().contains('internet')) {
      return 'Please check your internet connection.';
    } else if (e.toString().contains('timed out')) {
      return 'The request took too long. Try again.';
    }
    return 'An error occurred: $e';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  ResultsListState get listState {
    if (isLoading) return ResultsListState.loading;
    if (errorMessage != null) return ResultsListState.error;
    if (items.isEmpty) return ResultsListState.empty;
    return ResultsListState.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E9), // Creamy off-white
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                // ignore: deprecated_member_use
                const Color(0xFFF8E8B0).withOpacity(0.5), // Light gold hint
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Subtle Heading
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  "Search Results",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 2,
                  color: const Color(0xFFD4AF37), // Gold accent
                ),
              ],
            ),
          ),
          ResSearchBar(
            controller: searchController,
            onSearch: () => performSearch(searchController.text),
            isLoading: isLoading,
          ),
          Expanded(
            child: ResultsList<T>(
              state: listState,
              items: items,
              itemBuilder: buildListItem,
              errorMessage: errorMessage,
              query: searchController.text,
              totalResults: totalResults,
            ),
          ),
        ],
      ),
    );
  }
}
