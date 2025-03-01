// lib/widgets/l1337x_search_parameters.dart

import 'package:flutter/material.dart';
import 'package:my_app/services/l1337x_search_service.dart';
import 'package:my_app/widgets/service_search_parameters.dart';

class L1337xSearchParameters extends ServiceSearchParameters {
  const L1337xSearchParameters({
    super.key,
    required L1337xSearchService super.service,
  });

  @override
  State<L1337xSearchParameters> createState() => _L1337xSearchParametersState();
}

class _L1337xSearchParametersState extends State<L1337xSearchParameters> {
  bool _showAdvancedOptions = false;

  L1337xSearchService get searchService =>
      widget.service as L1337xSearchService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // ignore: deprecated_member_use
            color: const Color(0xFFD4AF37).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Basic Options Row (Category + Advanced Toggle)
          Row(
            children: [
              // Category Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: searchService.category,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFFD4AF37),
                          ),
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          borderRadius: BorderRadius.circular(8),
                          hint: Text('All Categories'),
                          onChanged: (String? newValue) {
                            setState(() {
                              searchService.category = newValue;
                            });
                          },
                          items:
                              <Map<String, String?>>[
                                {'display': 'All Categories', 'value': null},
                                {'display': 'Movies', 'value': 'Movies'},
                                {'display': 'TV', 'value': 'TV'},
                                {'display': 'Games', 'value': 'Games'},
                                {'display': 'Music', 'value': 'Music'},
                                {'display': 'Apps', 'value': 'Apps'},
                                {
                                  'display': 'Documentaries',
                                  'value': 'Documentaries',
                                },
                                {'display': 'Anime', 'value': 'Anime'},
                                {'display': 'Other', 'value': 'Other'},
                              ].map<DropdownMenuItem<String?>>((
                                Map<String, String?> item,
                              ) {
                                return DropdownMenuItem<String?>(
                                  value: item['value'],
                                  child: Text(item['display']!),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // Advanced Options Toggle Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showAdvancedOptions = !_showAdvancedOptions;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(
                            _showAdvancedOptions ? 'Hide' : 'Show',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            _showAdvancedOptions
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 16,
                            color: Color(0xFFD4AF37),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Advanced options (Sort & Order) - Only shown when advanced toggle is on
          if (_showAdvancedOptions)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  // Sort Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            'Sort By',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: searchService.sort,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFFD4AF37),
                              ),
                              isExpanded: true,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              borderRadius: BorderRadius.circular(8),
                              hint: Text('Seeders'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  searchService.sort = newValue;
                                });
                              },
                              items:
                                  <Map<String, String?>>[
                                    {'display': 'Seeders', 'value': null},
                                    {'display': 'Time', 'value': 'time'},
                                    {'display': 'Size', 'value': 'size'},
                                    {
                                      'display': 'Leechers',
                                      'value': 'leechers',
                                    },
                                  ].map<DropdownMenuItem<String?>>((
                                    Map<String, String?> item,
                                  ) {
                                    return DropdownMenuItem<String?>(
                                      value: item['value'],
                                      child: Text(item['display']!),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Order Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            'Order',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: searchService.order,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFFD4AF37),
                              ),
                              isExpanded: true,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (String? newValue) {
                                setState(() {
                                  searchService.order = newValue;
                                });
                              },
                              items:
                                  <Map<String, String>>[
                                    {'display': 'Descending', 'value': 'desc'},
                                    {'display': 'Ascending', 'value': 'asc'},
                                  ].map<DropdownMenuItem<String>>((
                                    Map<String, String> item,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: item['value']!,
                                      child: Text(item['display']!),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
