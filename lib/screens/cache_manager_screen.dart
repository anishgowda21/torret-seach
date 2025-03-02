// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/utils/cache_manager.dart';
import 'package:provider/provider.dart';

class CacheManagerScreen extends StatefulWidget {
  const CacheManagerScreen({super.key});

  @override
  State<CacheManagerScreen> createState() => _CacheManagerScreenState();
}

class _CacheManagerScreenState extends State<CacheManagerScreen> {
  late CacheManager _cacheManager;
  Map<String, dynamic> _cacheStats = {};
  bool _isLoadingStats = true;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    _cacheManager = CacheManager();
    _loadCacheStats();
  }

  Future<void> _loadCacheStats() async {
    setState(() {
      _isLoadingStats = true;
    });

    // Get cache statistics
    final stats = _cacheManager.getCacheStats();

    setState(() {
      _cacheStats = stats;
      _isLoadingStats = false;
    });
  }

  Future<void> _clearCache() async {
    setState(() {
      _isClearing = true;
    });

    // Clear all cache
    _cacheManager.clearCache();

    // Reload stats
    await _loadCacheStats();

    setState(() {
      _isClearing = false;
    });

    // Show confirmation snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearExpiredCache() async {
    setState(() {
      _isClearing = true;
    });

    // Clear expired cache
    _cacheManager.clearExpiredCache();

    // Reload stats
    await _loadCacheStats();

    setState(() {
      _isClearing = false;
    });

    // Show confirmation snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expired cache cleared successfully'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF8F1E9),
      appBar: AppBar(
        title: Text(
          'Cache Manager',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [Colors.black, Colors.black]
                      : [
                        Colors.white,
                        const Color(0xFFF8E8B0).withOpacity(0.5),
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Row(
                children: [
                  Text(
                    "Cache Statistics",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 40, height: 2, color: primaryColor),
                ],
              ),
              const SizedBox(height: 16),

              // Cache statistics card
              _buildStatisticsCard(),

              const SizedBox(height: 24),

              // Cache actions card
              _buildActionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child:
          _isLoadingStats
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cache Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total entries
                  _buildStatRow(
                    'Total Entries',
                    _cacheStats['totalEntries']?.toString() ?? '0',
                  ),

                  _buildStatRow(
                    'YTS Query Entires',
                    _cacheStats['ytsQueryEnries']?.toString() ?? '0',
                  ),

                  // 1337x search entries
                  _buildStatRow(
                    '1337x Search Entries',
                    _cacheStats['l1337xSearchEntries']?.toString() ?? '0',
                  ),

                  // 1337x details entries
                  _buildStatRow(
                    '1337x Details Entries',
                    _cacheStats['l1337xDetailsEntries']?.toString() ?? '0',
                  ),

                  // Expired entries
                  _buildStatRow(
                    'Expired Entries',
                    _cacheStats['expiredEntries']?.toString() ?? '0',
                    isHighlighted: true,
                  ),

                  // Active cache size
                  _buildStatRow(
                    'Active Cache Entries',
                    _cacheStats['activeCacheSize']?.toString() ?? '0',
                    isHighlighted: true,
                  ),
                ],
              ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final highlightColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? highlightColor : textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cache Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Clear expired cache
          _buildActionButton(
            icon: Icons.cleaning_services_outlined,
            label: 'Clear Expired Cache',
            onPressed: _isClearing ? null : _clearExpiredCache,
            description: 'Remove only items that have already expired',
          ),

          const SizedBox(height: 16),

          // Clear all cache
          _buildActionButton(
            icon: Icons.delete_outline,
            label: 'Clear All Cache',
            onPressed: _isClearing ? null : _clearCache,
            description: 'Remove all cached items',
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback? onPressed,
    bool isDestructive = false,
  }) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDestructive
                      ? (isDarkMode ? Colors.red.shade900 : Colors.red)
                      : primaryColor,
              foregroundColor:
                  isDestructive
                      ? Colors.white
                      : (isDarkMode ? Colors.black : Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
