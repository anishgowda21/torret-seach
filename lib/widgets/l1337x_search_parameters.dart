// lib/widgets/l1337x_search_parameters.dart

import 'package:flutter/material.dart';
import 'package:my_app/services/l1337x_search_service.dart';

class L1337xSearchParameters extends StatefulWidget {
  final L1337xSearchService service;

  const L1337xSearchParameters({super.key, required this.service});

  @override
  State<L1337xSearchParameters> createState() => _L1337xSearchParametersState();
}

class _L1337xSearchParametersState extends State<L1337xSearchParameters> {
  final TextEditingController _seasonController = TextEditingController();
  final TextEditingController _episodeController = TextEditingController();
  bool _showTvOptions = false;

  @override
  void initState() {
    super.initState();
    _updateTvOptionsVisibility();
  }

  @override
  void dispose() {
    _seasonController.dispose();
    _episodeController.dispose();
    super.dispose();
  }

  void _updateTvOptionsVisibility() {
    setState(() {
      _showTvOptions = widget.service.category == 'TV';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
        children: [
          // Category Dropdown
          Row(
            children: [
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
                        child: DropdownButton<String>(
                          value: widget.service.category,
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
                              widget.service.category = newValue;
                              _updateTvOptionsVisibility();
                            });
                          },
                          items:
                              <String>[
                                'Movies',
                                'TV',
                                'Games',
                                'Music',
                                'Apps',
                                'Documentaries',
                                'Anime',
                                'Other',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
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

          // TV-specific options (Season/Episode)
          if (_showTvOptions)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  // Season Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            'Season',
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
                          child: TextField(
                            controller: _seasonController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Season #',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              widget.service.season =
                                  value.isEmpty ? null : int.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Episode Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            'Episode',
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
                          child: TextField(
                            controller: _episodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Episode #',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              widget.service.episode =
                                  value.isEmpty ? null : int.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Sort & Order
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
                          child: DropdownButton<String>(
                            value: widget.service.sort,
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
                                widget.service.sort = newValue;
                              });
                            },
                            items:
                                <String>[
                                  'time',
                                  'size',
                                  'seeders',
                                  'leechers',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  String displayName =
                                      value.substring(0, 1).toUpperCase() +
                                      value.substring(1);
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(displayName),
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
                            value: widget.service.order,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFD4AF37),
                            ),
                            isExpanded: true,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            borderRadius: BorderRadius.circular(8),
                            onChanged: (String? newValue) {
                              setState(() {
                                widget.service.order = newValue;
                              });
                            },
                            items:
                                <String>[
                                  'desc',
                                  'asc',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  String displayName =
                                      value == 'desc'
                                          ? 'Descending'
                                          : 'Ascending';
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(displayName),
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
