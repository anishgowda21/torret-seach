class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, CacheEntry> _cache = {};

  static const Duration l1337xSearchCacheDuration = Duration(minutes: 15);
  static const Duration l1337xDetailsCacheDuration = Duration(days: 1);
  static const Duration ytsSearchCacheDuration = Duration(minutes: 30);

  T? get<T>(String key) {
    final entry = _cache[key];

    // Return null if no cache entry exists or if it's expired
    if (entry == null || entry.isExpired) {
      if (entry?.isExpired == true) {
        // Clean up expired entry
        _cache.remove(key);
      }
      return null;
    }

    return entry.value as T;
  }

  void set<T>(String key, T value, Duration duration) {
    _cache[key] = CacheEntry(
      value: value,
      expiryTime: DateTime.now().add(duration),
    );
  }

  /// Caches search results with standard 15-minute expiration
  void cache1337xSearchResults(
    String query,
    String? category,
    String? sort,
    String? order,
    int page,
    dynamic results,
  ) {
    final key = _generate1337xSearchKey(query, category, sort, order, page);
    set(key, results, l1337xSearchCacheDuration);
  }

  /// Gets cached search results if available
  dynamic get1337xCachedSearchResults(
    String query,
    String? category,
    String? sort,
    String? order,
    int page,
  ) {
    final key = _generate1337xSearchKey(query, category, sort, order, page);
    return get(key);
  }

  // Caches torrent details with standard 1-day expiration
  void cache1337xDetails(String link, dynamic details) {
    final key = _generate1337xDetailsKey(link);
    set(key, details, l1337xDetailsCacheDuration);
  }

  /// Gets cached torrent details if available
  dynamic get1337xCachedDetails(String link) {
    final key = _generate1337xDetailsKey(link);
    return get(key);
  }

  void cacheYtsQueryResults(String query, dynamic results) {
    final key = _generateYtsSearchKey(query);
    set(key, results, ytsSearchCacheDuration);
  }

  dynamic getYtsQueryResults(String query) {
    final key = _generateYtsSearchKey(query);
    return get(key);
  }

  String _generate1337xSearchKey(
    String query,
    String? category,
    String? sort,
    String? order,
    int page,
  ) {
    // Normalize query (lowercase + trim)
    final normalizedQuery = query.trim().toLowerCase();

    // Create key parts
    final parts = [
      normalizedQuery,
      category ?? 'all',
      sort ?? 'seeders',
      order ?? 'desc',
      page.toString(),
    ];

    // Join with a delimiter unlikely to appear in actual values
    return 'l1337xsearch:${parts.join("||")}';
  }

  String _generate1337xDetailsKey(String link) {
    return 'l1337xdetails:$link';
  }

  String _generateYtsSearchKey(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    return 'ytsquery:$normalizedQuery';
  }

  void clearCache() {
    _cache.clear();
  }

  void clearExpiredCache() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Returns cache statistics
  Map<String, dynamic> getCacheStats() {
    int totalEntries = _cache.length;
    int l1337xSearchEntries =
        _cache.keys.where((k) => k.startsWith('l1337xsearch:')).length;
    int detailsEntries =
        _cache.keys.where((k) => k.startsWith('l1337xdetails:')).length;
    int expiredEntries = _cache.values.where((entry) => entry.isExpired).length;

    return {
      'totalEntries': totalEntries,
      'l1337xSearchEntries': l1337xSearchEntries,
      'l1337xDetailsEntries': detailsEntries,
      'expiredEntries': expiredEntries,
      'activeCacheSize': totalEntries - expiredEntries,
    };
  }
}

class CacheEntry {
  final dynamic value;
  final DateTime expiryTime;

  CacheEntry({required this.value, required this.expiryTime});

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}
