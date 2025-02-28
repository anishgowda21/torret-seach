import 'package:flutter/material.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Results: $itemsLength${totalResults != 0 && totalResults != itemsLength ? ' of $totalResults' : ''}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (query.isNotEmpty)
            Flexible(
              child: Text(
                'Query: "$query"',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
