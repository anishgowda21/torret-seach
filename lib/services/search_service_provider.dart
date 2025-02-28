import 'package:flutter/material.dart';
import 'package:my_app/services/search_service.dart';
import 'package:my_app/services/yts_search_service.dart';

class SearchServiceProvider extends ChangeNotifier {
  static final SearchServiceProvider _instance =
      SearchServiceProvider._internal();

  factory SearchServiceProvider() {
    return _instance;
  }

  SearchServiceProvider._internal() {
    _initializeServices();
  }

  final List<SearchService> _services = [];

  SearchService? _currentService;

  List<SearchService> get availableServices => _services;

  SearchService get currentService {
    if (_currentService == null) {
      if (_services.isNotEmpty) {
        _currentService = _services.first;
      } else {
        throw Exception("No search services available");
      }
    }
    return _currentService!;
  }

  set currentService(SearchService service) {
    if (!_services.contains(service)) {
      throw Exception("Service not registered");
    }
    _currentService = service;
    notifyListeners();
  }

  void _initializeServices() {
    _services.add(YtsSearchService());

    if (_services.isNotEmpty) {
      _currentService = _services.first;
    }
  }

  SearchService? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.serviceId == id);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, bool>> checkAvailability() async {
    final Map<String, bool> availabilityMap = {};

    for (var service in _services) {
      final isAvailable = await service.isAvailable();
      availabilityMap[service.serviceId] = isAvailable;
    }

    return availabilityMap;
  }
}
