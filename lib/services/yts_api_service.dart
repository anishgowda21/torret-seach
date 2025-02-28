import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/model/yts_search_result.dart';

class YtsApiService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';
  final Duration timeout = Duration(seconds: 10);

  Future<YtsSearchResult> searchMovies(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = '$baseUrl/yts?query=$encodedQuery&img=true';
      if (baseUrl == "") throw Exception("No Base URL");
      final response = await http.get(Uri.parse(url)).timeout(timeout);

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        throw Exception('Failed to parse response: Invalid JSON format');
      }

      if (!responseData.containsKey('status')) {
        throw Exception('Invalid API response: Missing status field');
      }

      if (response.statusCode == 200 && responseData['status'] == 'ok') {
        try {
          final searchResponse = YtsSearchResult.fromJson(responseData);

          for (var movie in searchResponse.data) {
            movie.transformTorrents();
          }

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
}
