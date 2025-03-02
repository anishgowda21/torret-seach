import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:torret_seach/model/yts_search_result.dart';
import 'package:torret_seach/screens/base_results_screen.dart';
import 'package:torret_seach/screens/yts_results_screen.dart';
import 'package:torret_seach/services/search_service.dart';
import 'package:torret_seach/utils/api_url_manager.dart';
import 'package:torret_seach/utils/cache_manager.dart';

class YtsSearchService implements SearchService<YtsSearchResult, Movie> {
  Future<String?> get apiUrl async => await ApiUrlManager.getApiUrl();
  final Duration timeout = Duration(seconds: 10);
  final CacheManager _cacheManager = CacheManager();

  @override
  String get serviceName => 'YTS Movies';

  @override
  String get serviceId => 'yts';

  @override
  IconData get serviceIcon => Icons.movie_outlined;

  @override
  void resetSearchParameters() {}

  @override
  Future<YtsSearchResult> search(String query) async {
    try {
      final baseUrl = await apiUrl;
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception("API URL not configured. Please set it in Settings.");
      }

      final cachedResult = _cacheManager.getYtsQueryResults(query);

      if (cachedResult != null) {
        return cachedResult as YtsSearchResult;
      }

      final encodedQuery = Uri.encodeComponent(query);
      final url = '$baseUrl/yts/search?query=$encodedQuery&img=true';
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw Exception('Failed to parse response: Invalid JSON format');
      }

      if (response.statusCode == 200) {
        try {
          final searchResponse = YtsSearchResult.fromJson(responseData);

          // Process movies (e.g., transform torrents)
          for (var movie in searchResponse.data) {
            movie.transformTorrents();
          }

          _cacheManager.cacheYtsQueryResults(query, searchResponse);

          return searchResponse;
        } catch (e) {
          throw Exception('Error processing response data: $e');
        }
      } else {
        if (response.statusCode != 200) {
          throw Exception(
            'API request failed with status: ${response.statusCode}',
          );
        } else {
          throw Exception('API returned error: ${responseData['status']}');
        }
      }
    } on SocketException {
      throw Exception('Please check your internet connection.');
    } on TimeoutException {
      throw Exception('The request took too long. Try again later');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  BaseResultsScreen<Movie> createResultsScreen({
    required YtsSearchResult results,
    required String query,
  }) {
    return YtsResultsScreen(initialResults: results, initialQuery: query);
  }

  @override
  List<Movie> getItemsFromResults(YtsSearchResult results) {
    return results.data;
  }

  @override
  String? getErrorFromResults(YtsSearchResult results) {
    return results.status != 'ok' ? results.status : null;
  }

  @override
  Future<bool> isAvailable() async {
    final baseUrl = await apiUrl;
    if (baseUrl == null || baseUrl.isEmpty) {
      return false;
    }
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/yts'))
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
