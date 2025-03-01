// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ResSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function() onSearch;
  final bool isLoading;

  const ResSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.isLoading = false,
  });

  @override
  State<ResSearchBar> createState() => _ResSearchBarState();
}

class _ResSearchBarState extends State<ResSearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).primaryColor, // Theme-based border
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).shadowColor.withOpacity(isDarkMode ? 0.3 : 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) {
                  widget.onSearch();
                  _focusNode.unfocus();
                },
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors:
                    isDarkMode
                        ? [
                          const Color(0xFFA48929), // Darker gold for dark mode
                          const Color(0xFF7A6621), // Dark gold for dark mode
                        ]
                        : [
                          const Color(0xFFD4AF37), // Gold
                          const Color(0xFFF8E8B0), // Light gold/ivory
                        ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).shadowColor.withOpacity(isDarkMode ? 0.4 : 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                if (widget.controller.text.trim().isNotEmpty) {
                  widget.onSearch();
                  _focusNode.unfocus();
                }
              },
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
              child: Text(
                widget.isLoading ? 'Searching...' : 'Search',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
