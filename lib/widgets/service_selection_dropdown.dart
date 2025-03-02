import 'package:flutter/material.dart';
import 'package:torret_seach/services/search_service.dart';
import 'package:torret_seach/services/search_service_provider.dart';

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

    // If there's only one service, show its name
    if (services.length <= 1) {
      return Card(
        elevation: 2,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                currentService.serviceIcon,
                size: 20,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(width: 8),
              Flexible(
                // Use Flexible instead of Expanded for tighter control
                child: Text(
                  currentService.serviceName, // Simplified to just service name
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Otherwise, show dropdown with all available services
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: currentService.serviceId,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onChanged: (String? serviceId) {
              if (serviceId != null) {
                final service = serviceProvider.getServiceById(serviceId);
                if (service != null) {
                  onServiceChanged(service);
                }
              }
            },
            dropdownColor: Theme.of(context).cardColor,
            items:
                services.map<DropdownMenuItem<String>>((SearchService service) {
                  return DropdownMenuItem<String>(
                    value: service.serviceId,
                    child: Row(
                      children: [
                        Icon(
                          service.serviceIcon,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          // Constrain text width
                          child: Text(
                            service.serviceName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
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
