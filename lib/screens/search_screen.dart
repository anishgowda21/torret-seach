// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_app/services/l1337x_search_service.dart';
import 'package:my_app/services/search_service_provider.dart';
import 'package:my_app/widgets/service_search_parameters.dart';
import 'package:my_app/widgets/service_selection_dropdown.dart';
import 'package:my_app/screens/settings_screen.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isLoading = false;
  final SearchServiceProvider _serviceProvider = SearchServiceProvider();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final currentService = _serviceProvider.currentService;
    final serviceParametersWidget = ServiceSearchParameters.forService(
      currentService,
    );
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Check if keyboard is open to adjust positioning
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Use theme-based background
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // App Bar
      appBar:
          isKeyboardOpen
              ? null
              : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Builder(
                  builder:
                      (context) => IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                ),
              ),

      // Drawer / Side Panel
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        themeProvider.isDarkMode
                            ? [
                              const Color(
                                0xFFA48929,
                              ), // Darker gold for dark mode
                              const Color(
                                0xFF7A6621,
                              ), // Dark gold for dark mode
                            ]
                            : [
                              const Color(0xFFD4AF37), // Gold
                              const Color(0xFFF8E8B0), // Light gold/ivory
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.download_outlined,
                      size: 32,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Torret Seach",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Drawer Items
              ListTile(
                leading: Icon(Icons.search, color: const Color(0xFFD4AF37)),
                title: Text(
                  'Search',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: const Color(0xFFD4AF37)),
                title: Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              Divider(),
              // Show available services
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Services',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._serviceProvider.availableServices.map((service) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        leading: Icon(service.serviceIcon),
                        title: Text(service.serviceName),
                        dense: true,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Elegant Heading - only show when keyboard is closed
            if (!isKeyboardOpen)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Torret Seach",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia', // Serif font for class
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 2,
                      color:
                          Theme.of(context).primaryColor, // Theme-based accent
                    ),
                  ],
                ),
              )
            else
              // Smaller padding when keyboard is open
              SizedBox(height: 16),

            // Centered Search UI - takes remaining space with proper alignment
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  // Move content up when keyboard is open
                  padding: EdgeInsets.only(
                    top: isKeyboardOpen ? 0 : screenHeight * 0.05,
                    bottom:
                        isKeyboardOpen
                            ? screenHeight * 0.05
                            : screenHeight * 0.15,
                    left: 16,
                    right: 16,
                  ),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Only as big as content
                        children: [
                          // Smaller, Centered Service Selection Dropdown
                          SizedBox(
                            width: 200, // Smaller width
                            child: ServiceSelectionDropdown(
                              serviceProvider: _serviceProvider,
                              onServiceChanged: (service) {
                                setState(() {
                                  _serviceProvider.currentService = service;
                                  _errorMessage = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Service-specific parameters widget (if available)
                          if (serviceParametersWidget != null)
                            serviceParametersWidget,

                          // Chic TextField
                          Container(
                            width: 300, // Fixed width for compactness
                            margin: const EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    Theme.of(
                                      context,
                                    ).primaryColor, // Theme-based border
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withOpacity(
                                    themeProvider.isDarkMode ? 0.3 : 0.2,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Search ${_serviceProvider.currentService.serviceName}...",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                prefixIcon: Icon(
                                  _serviceProvider.currentService.serviceIcon,
                                  color:
                                      Theme.of(
                                        context,
                                      ).primaryColor, // Theme-based icon
                                ),
                                errorText: _errorMessage,
                                errorStyle: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _performSearch(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Elegant Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors:
                                    themeProvider.isDarkMode
                                        ? [
                                          const Color(
                                            0xFFA48929,
                                          ), // Darker gold for dark mode
                                          const Color(
                                            0xFF7A6621,
                                          ), // Dark gold for dark mode
                                        ]
                                        : [
                                          const Color(0xFFD4AF37), // Gold
                                          const Color(
                                            0xFFF8E8B0,
                                          ), // Light gold/ivory
                                        ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withOpacity(
                                    themeProvider.isDarkMode ? 0.4 : 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _performSearch,
                              icon:
                                  _isLoading
                                      ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                        ),
                                      )
                                      : Icon(
                                        _serviceProvider
                                            .currentService
                                            .serviceIcon,
                                        color:
                                            themeProvider.isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                              label: Text(
                                _isLoading ? 'Searching...' : 'Search',
                                style: TextStyle(
                                  color:
                                      themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Optional: add this to make card move up when keyboard appears
      resizeToAvoidBottomInset: true,
    );
  }

  void _performSearch() async {
    if (_isLoading) return;
    String query = _searchController.text;
    if (query.trim().isEmpty) {
      setState(() {
        _errorMessage = "Please enter a search term";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    _searchFocusNode.unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final service = _serviceProvider.currentService;

      // For 1337x, use the formatted query that includes season/episode
      if (service is L1337xSearchService) {
        final results = await service.search(query);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => service.createResultsScreen(
                    results: results,
                    query: query,
                  ),
            ),
          ).then((_) {
            if (mounted) {
              _searchController.clear();
              service.resetSearchParameters();
            }
          });
        }
      } else {
        // Other services
        final results = await service.search(query);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => service.createResultsScreen(
                    results: results,
                    query: query,
                  ),
            ),
          ).then((_) {
            if (mounted) _searchController.clear();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _formatError(e);
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatError(dynamic e) {
    final message = e.toString();
    if (message.contains('internet')) {
      return 'Please check your internet connection';
    } else if (message.contains('timed out')) {
      return 'The request took too long. Try again';
    }
    return 'Error: ${message.replaceAll('Exception: ', '')}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
