import 'package:flutter/material.dart';
import 'package:my_app/widgets/results_list.dart';
import 'package:my_app/widgets/search_bar.dart';

abstract class BaseResultsScreen<T> extends StatefulWidget {
  final List<T> initialItems;
  final String initialQuery;

  const BaseResultsScreen({
    super.key,
    required this.initialItems,
    required this.initialQuery,
  });

  @override
  State<BaseResultsScreen<T>> createState();
}

abstract class BaseResultsScreenState<T> extends State<BaseResultsScreen<T>> {
  late TextEditingController searchController;
  bool isLoading = false;
  String? errorMessage;
  late List<T> items;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery);
    items = widget.initialItems;
    if (items.isEmpty && !isLoading) {
      errorMessage = null; // Ensure no stale error
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
      appBar: AppBar(title: Text(appBarTitle)),
      body: Column(
        children: [
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
            ),
          ),
        ],
      ),
    );
  }
}
