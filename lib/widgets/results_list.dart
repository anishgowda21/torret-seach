import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/widgets/result_list_header.dart';
import 'package:provider/provider.dart';

enum ResultsListState { loading, error, empty, data }

class ResultsList<T> extends StatelessWidget {
  final ResultsListState state;
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final String? errorMessage;
  final String emptyMessage;
  final int? totalResults;
  final String? query;

  const ResultsList({
    super.key,
    required this.state,
    required this.items,
    required this.itemBuilder,
    this.errorMessage,
    this.emptyMessage = 'No results found',
    this.totalResults,
    this.query,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    switch (state) {
      case ResultsListState.loading:
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
            strokeWidth: 2,
          ),
        );
      case ResultsListState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: isDarkMode ? Colors.redAccent.shade200 : Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'Error: $errorMessage',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        );
      case ResultsListState.empty:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        );
      case ResultsListState.data:
        return Column(
          children: [
            ResultListHeader(
              itemsLength: items.length,
              totalResults: totalResults ?? 0,
              query: query ?? "",
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder:
                    (context, index) => itemBuilder(context, items[index]),
              ),
            ),
          ],
        );
    }
  }
}
