class L1337xSearchResult {
  final List<L1337xTorrentItem> results;
  final L1337xPagination pagination;
  final L1337xFilters filters;

  L1337xSearchResult({
    required this.results,
    required this.pagination,
    required this.filters,
  });

  factory L1337xSearchResult.fromJson(Map<String, dynamic> json) {
    return L1337xSearchResult(
      results: List<L1337xTorrentItem>.from(
        json['results'].map((x) => L1337xTorrentItem.fromJson(x)),
      ),
      pagination: L1337xPagination.fromJson(json['pagination']),
      filters: L1337xFilters.fromJson(json['filters']),
    );
  }
}

class L1337xTorrentItem {
  final String name;
  final String link;
  final String seeds;
  final String leeches;
  final String date;
  final String size;

  L1337xTorrentItem({
    required this.name,
    required this.link,
    required this.seeds,
    required this.leeches,
    required this.date,
    required this.size,
  });

  factory L1337xTorrentItem.fromJson(Map<String, dynamic> json) {
    return L1337xTorrentItem(
      name: json['name'] ?? 'Unknown',
      link: json['link'] ?? '',
      seeds: json['seeds'] ?? '0',
      leeches: json['leeches'] ?? '0',
      date: json['date'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
    );
  }

  // Parse seeds as integer for sorting
  int get seedsCount => int.tryParse(seeds) ?? 0;

  // Parse leeches as integer for sorting
  int get leechesCount => int.tryParse(leeches) ?? 0;
}

class L1337xPagination {
  final String query;
  final int currentPage;
  final int lastPage;
  final int perPageResults;

  L1337xPagination({
    required this.query,
    required this.currentPage,
    required this.lastPage,
    required this.perPageResults,
  });

  factory L1337xPagination.fromJson(Map<String, dynamic> json) {
    return L1337xPagination(
      query: json['query'] ?? '',
      currentPage: json['currentPage'] ?? 1,
      lastPage: json['lastPage'] ?? 1,
      perPageResults: json['perPageResults'] ?? 0,
    );
  }
}

class L1337xFilters {
  final String category;
  final String sort;
  final String order;

  L1337xFilters({
    required this.category,
    required this.sort,
    required this.order,
  });

  factory L1337xFilters.fromJson(Map<String, dynamic> json) {
    return L1337xFilters(
      category: json['category'] ?? 'All',
      sort: json['sort'] ?? 'seeders',
      order: json['order'] ?? 'desc',
    );
  }
}
