class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, CacheEntry> _cache = {};

  static const Duration searchCacheDuration = Duration(minutes: 15);
  static const Duration detailsCacheDuration = Duration(days: 1);

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
  void cacheSearchResults(
    String query,
    String? category,
    String? sort,
    String? order,
    int page,
    dynamic results,
  ) {
    final key = _generateSearchKey(query, category, sort, order, page);
    set(key, results, searchCacheDuration);
  }

  /// Gets cached search results if available
  dynamic getCachedSearchResults(
    String query,
    String? category,
    String? sort,
    String? order,
    int page,
  ) {
    final key = _generateSearchKey(query, category, sort, order, page);
    return get(key);
  }

  // Caches torrent details with standard 1-day expiration
  void cacheDetails(String link, dynamic details) {
    final key = _generateDetailsKey(link);
    set(key, details, detailsCacheDuration);
  }

  /// Gets cached torrent details if available
  dynamic getCachedDetails(String link) {
    final key = _generateDetailsKey(link);
    return get(key);
  }

  String _generateSearchKey(
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
    return 'search:${parts.join("||")}';
  }

  String _generateDetailsKey(String link) {
    return 'details:$link';
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
    int searchEntries =
        _cache.keys.where((k) => k.startsWith('search:')).length;
    int detailsEntries =
        _cache.keys.where((k) => k.startsWith('details:')).length;
    int expiredEntries = _cache.values.where((entry) => entry.isExpired).length;

    return {
      'totalEntries': totalEntries,
      'searchEntries': searchEntries,
      'detailsEntries': detailsEntries,
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
