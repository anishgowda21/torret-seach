import 'package:flutter/material.dart';
import 'package:my_app/model/yts_search_result.dart';
import 'package:my_app/screens/base_results_screen.dart';
import 'package:my_app/services/yts_api_service.dart';
import 'package:my_app/widgets/movie_card.dart';

class YtsResultsScreen extends BaseResultsScreen<Movie> {
  final YtsSearchResult initialResults;
  final YtsApiService apiService;

  YtsResultsScreen({
    super.key,
    required this.initialResults,
    required this.apiService,
    required super.initialQuery,
  }) : super(initialItems: initialResults.data);

  @override
  YtsResultsScreenState createState() => YtsResultsScreenState();
}

class YtsResultsScreenState extends BaseResultsScreenState<Movie> {
  static const int maxItems = 50;
  late YtsApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = (widget as YtsResultsScreen).apiService; // Get it from widget
  }

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
      final newResults = await _apiService.searchMovies(query);
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
    return MovieCard(movie: movie);
  }
}
