import 'package:flutter/material.dart';
import 'package:my_app/services/l1337x_search_service.dart';
import 'package:my_app/services/search_service.dart';
import 'package:my_app/widgets/l1337x_search_parameters.dart';

abstract class ServiceSearchParameters extends StatefulWidget {
  final SearchService service;

  const ServiceSearchParameters({super.key, required this.service});

  static Widget? forService(SearchService service) {
    final serviceId = service.serviceId;

    switch (serviceId) {
      case 'l1337x':
        return L1337xSearchParameters(service: service as L1337xSearchService);
      case 'yts':
        return null;
      default:
        return null;
    }
  }
}
