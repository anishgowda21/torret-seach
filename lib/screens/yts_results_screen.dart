import 'package:flutter/material.dart';
import 'package:torret_seach/model/yts_search_result.dart';
import 'package:torret_seach/screens/base_results_screen.dart';
import 'package:torret_seach/services/yts_search_service.dart';
import 'package:torret_seach/widgets/yts_movie_card.dart';

class YtsResultsScreen extends BaseResultsScreen<Movie> {
  final YtsSearchResult initialResults;

  YtsResultsScreen({
    super.key,
    required this.initialResults,
    required super.initialQuery,
  }) : super(initialItems: initialResults.data);

  @override
  YtsResultsScreenState createState() => YtsResultsScreenState();
}

class YtsResultsScreenState extends BaseResultsScreenState<Movie> {
  final YtsSearchService _apiService = YtsSearchService();
  static const int maxItems = 50;

  @override
  String get appBarTitle => 'YTS Results';

  @override
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final newResults = await _apiService.search(query);
      if (mounted) {
        setState(() {
          items = newResults.data.take(maxItems).toList();
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
  Widget buildListItem(BuildContext context, Movie movie) {
    return YtsMovieCard(movie: movie);
  }
}
