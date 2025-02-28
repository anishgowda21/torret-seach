import 'package:flutter/material.dart';
import 'package:my_app/services/search_service.dart';
import 'package:my_app/services/search_service_provider.dart';

class ServiceSelectionDropdown extends StatelessWidget {
  final SearchServiceProvider serviceProvider;
  final Function(SearchService) onServiceChanged;

  const ServiceSelectionDropdown({
    super.key,
    required this.serviceProvider,
    required this.onServiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final services = serviceProvider.availableServices;
    final currentService = serviceProvider.currentService;

    // If there's only one service, just show its name
    if (services.length <= 1) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(currentService.serviceIcon),
              SizedBox(width: 8),
              Text(
                "Searching: ${currentService.serviceName}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    // Otherwise, show dropdown with all available services
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: currentService.serviceId,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? serviceId) {
              if (serviceId != null) {
                final service = serviceProvider.getServiceById(serviceId);
                if (service != null) {
                  onServiceChanged(service);
                }
              }
            },
            items:
                services.map<DropdownMenuItem<String>>((SearchService service) {
                  return DropdownMenuItem<String>(
                    value: service.serviceId,
                    child: Row(
                      children: [
                        Icon(service.serviceIcon),
                        SizedBox(width: 12),
                        Text(
                          service.serviceName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
