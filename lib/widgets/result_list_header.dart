// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
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
            ? Theme.of(context).cardColor.withOpacity(0.7)
            : Theme.of(context).colorScheme.surfaceContainerHighest;

    // Use color scheme for text
    final textColor = Theme.of(
      context,
    ).textTheme.bodyMedium?.color?.withOpacity(0.7);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: backgroundColor,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Results: $itemsLength${totalResults != 0 && totalResults != itemsLength ? ' of $totalResults' : ''}',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          if (query.isNotEmpty)
            Flexible(
              child: Text(
                'Query: "$query"',
                style: TextStyle(fontStyle: FontStyle.italic, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
