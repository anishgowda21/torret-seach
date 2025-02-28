import 'package:flutter/material.dart';
import 'package:my_app/screens/base_results_screen.dart';

abstract class SearchService<T, R> {
  String get serviceName;

  String get serviceId;

  IconData get serviceIcon;

  Future<T> search(String query);

  BaseResultsScreen<R> createResultsScreen({
    required T results,
    required String query,
  });

  Future<bool> isAvailable();

  List<R> getItemsFromResults(T results);

  String? getErrorFromResults(T results);
}
