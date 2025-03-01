import 'package:flutter/material.dart';
import 'package:torret_seach/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ResultListHeader extends StatelessWidget {
  final int itemsLength;
  final int totalResults;
  final String query;

  const ResultListHeader({
    super.key,
    required this.itemsLength,
    required this.totalResults,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Use color scheme for container background
    final backgroundColor =
        isDarkMode
            ? Color(0xFF333333) // Dark gray to match 1337x design
            : Theme.of(context).colorScheme.surfaceContainerHighest;

    // Use color scheme for text
    final textColor = Theme.of(
      context,
      // ignore: deprecated_member_use
    ).textTheme.bodyMedium?.color?.withOpacity(0.7);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: backgroundColor,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Results per Page: $itemsLength${totalResults != 0 && totalResults != itemsLength ? ' of $totalResults' : ''}',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          if (query.trim().isNotEmpty)
            Tooltip(
              message: 'Query: "${query.trim()}"',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 16, color: textColor),
                  SizedBox(width: 4),
                  Text(
                    _truncateText(query.trim(), 20),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
