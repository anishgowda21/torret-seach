import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:torret_seach/providers/theme_provider.dart';
import 'package:torret_seach/utils/error_formatter.dart';
import 'package:torret_seach/widgets/results_list.dart';
import 'package:torret_seach/widgets/res_search_bar.dart';
import 'package:provider/provider.dart';

abstract class BaseResultsScreen<T> extends StatefulWidget {
  final List<T> initialItems;
  final String initialQuery;
  final int? totalResults;

  const BaseResultsScreen({
    super.key,
    required this.initialItems,
    required this.initialQuery,
    this.totalResults,
  });

  @override
  State<BaseResultsScreen<T>> createState();
}

abstract class BaseResultsScreenState<T> extends State<BaseResultsScreen<T>>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  bool isLoading = false;
  String? errorMessage;
  late List<T> items;
  int? totalResults;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.initialQuery);
    items = widget.initialItems;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scrollController.addListener(_scrollListener);

    totalResults = widget.totalResults ?? items.length;
    if (items.isEmpty && !isLoading) {
      errorMessage = null;
    }
  }

  void _scrollListener() {
    final ScrollDirection direction =
        _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _animationController.forward();
    } else if (direction == ScrollDirection.forward) {
      _animationController.reverse();
    }
  }

  Future<void> performSearch(String query);
  Widget buildListItem(BuildContext context, T item);
  String get appBarTitle;

  String formatError(dynamic e) {
    return ErrorFormatter.formatError(e);
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  ResultsListState get listState {
    if (isLoading) return ResultsListState.loading;
    if (errorMessage != null) return ResultsListState.error;
    if (items.isEmpty) return ResultsListState.empty;
    return ResultsListState.data;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    // Use completely black background for dark mode, matching 1337x screens
    final backgroundColor =
        isDarkMode
            ? Colors.black
            : const Color(0xFFF8F1E9); // Original light cream color

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                appBarTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              elevation: 2,
              pinned: true,
              floating: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDarkMode
                            ? [Colors.black, Colors.black]
                            : [
                              Colors.white,
                              // ignore: deprecated_member_use
                              const Color(0xFFF8E8B0).withOpacity(0.5),
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ClipRect(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          children: [
                            Text(
                              "Search Results",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Georgia',
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 2,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      ResSearchBar(
                        controller: searchController,
                        onSearch: () => performSearch(searchController.text),
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: ResultsList<T>(
          state: listState,
          items: items,
          itemBuilder: buildListItem,
          errorMessage: errorMessage,
          query: searchController.text,
          totalResults: totalResults,
        ),
      ),
    );
  }
}
