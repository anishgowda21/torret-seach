// ignore_for_file: unnecessary_getters_setters

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/l1337x_search_result.dart';
import 'package:my_app/model/l1337x_torrent_detail.dart';
import 'package:my_app/screens/base_results_screen.dart';
import 'package:my_app/screens/l1337x_results_screen.dart';
import 'package:my_app/services/search_service.dart';
import 'package:my_app/utils/cache_manager.dart';

class L1337xSearchService
    implements SearchService<L1337xSearchResult, L1337xTorrentItem> {
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final Duration timeout = Duration(seconds: 10);
  final CacheManager _cacheManager = CacheManager();

  String? _category;
  String? _sort;
  String? _order = 'desc';
  int _currentPage = 1;

  String? get category => _category;
  set category(String? value) => _category = value;

  String? get sort => _sort;
  set sort(String? value) => _sort = value;

  String? get order => _order;
  set order(String? value) => _order = value;

  int get currentPage => _currentPage;
  set currentPage(int value) => _currentPage = value;

  void resetSearchParameters() {
    _category = null;
    _sort = null;
    _order = 'desc';
    _currentPage = 1;
  }

  @override
  String get serviceName => '1337x Torrents';

  @override
  String get serviceId => 'l1337x';

  @override
  IconData get serviceIcon => Icons.download_outlined;

  @override
  Future<L1337xSearchResult> search(String query, {int? page}) async {
    try {
      final currentPage = page ?? _currentPage;

      final cachedResult = _cacheManager.getCachedSearchResults(
        query,
        _category,
        _sort,
        _order,
        currentPage,
      );

      if (cachedResult != null) {
        print("Using cached results for: $query (page $currentPage)");
        return cachedResult as L1337xSearchResult;
      }

      // No cache hit, perform network request
      final encodedQuery = Uri.encodeComponent(query);
      String url = '$baseUrl/1337x/search?query=$encodedQuery';

      if (_category != null && _category!.isNotEmpty) {
        url += '&category=${Uri.encodeComponent(_category!)}';
      }

      if (_sort != null && _sort!.isNotEmpty) {
        url += '&sort=$_sort';
      }

      if (_order != null && _order!.isNotEmpty) {
        url += '&order=$_order';
      }

      if (currentPage > 1) {
        url += '&page=$currentPage';
      }

      if (baseUrl.isEmpty) throw Exception("API URL not configured");

      print("Searching URL= ${url}");
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      Map<String, dynamic> responseData;

      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw Exception('Failed to parse response: Invalid JSON format');
      }

      if (response.statusCode == 200) {
        try {
          final searchResponse = L1337xSearchResult.fromJson(responseData);
          _cacheManager.cacheSearchResults(
            query,
            _category,
            _sort,
            _order,
            currentPage,
            searchResponse,
          );

          _currentPage = currentPage;
          return searchResponse;
        } catch (e) {
          throw Exception('Error processing response data: $e');
        }
      } else {
        throw Exception(
          'API request failed with status: ${response.statusCode}',
        );
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

  Future<L1337xTorrentDetail> getDetails(String link) async {
    try {
      final cachedDetail = _cacheManager.getCachedDetails(link);

      if (cachedDetail != null) {
        print("Using cached details for: $link");
        return cachedDetail as L1337xTorrentDetail;
      }

      final encodedLink = Uri.encodeComponent(link);
      final url = '$baseUrl/1337x/details?link=$encodedLink';

      if (baseUrl.isEmpty) throw Exception("API URL not configured");

      final response = await http.get(Uri.parse(url)).timeout(timeout);

      Map<String, dynamic> responseData;

      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw Exception(
          'Failed to parse details response: Invalid JSON format',
        );
      }

      if (response.statusCode == 200) {
        try {
          final detailResponse = L1337xTorrentDetail.fromJson(responseData);
          _cacheManager.cacheDetails(link, detailResponse);

          return detailResponse;
        } catch (e) {
          throw Exception('Error processing details response data: $e');
        }
      } else {
        throw Exception(
          'API details request failed with status: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('Please check your internet connection.');
    } on TimeoutException {
      throw Exception('The request took too long. Try again later');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error in details request: $e');
    }
  }

  @override
  BaseResultsScreen<L1337xTorrentItem> createResultsScreen({
    required L1337xSearchResult results,
    required String query,
  }) {
    return L1337xResultsScreen(
      initialResults: results,
      initialQuery: query,
      service: this,
    );
  }

  @override
  List<L1337xTorrentItem> getItemsFromResults(L1337xSearchResult results) {
    return results.results;
  }

  @override
  String? getErrorFromResults(L1337xSearchResult results) {
    return results.results.isEmpty ? "No results found" : null;
  }

  @override
  Future<bool> isAvailable() async {
    if (baseUrl.isEmpty) return false;

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/1337x'))
          .timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
