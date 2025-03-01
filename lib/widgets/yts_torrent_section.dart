// lib/widgets/yts_torrent_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/model/yts_search_result.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class YtsTorrentSection extends StatefulWidget {
  final List<Torrent> torrents;
  final Map<String, List<Torrent>> groupedTorrents;

  const YtsTorrentSection({
    required this.torrents,
    required this.groupedTorrents,
    super.key,
  });

  @override
  State<YtsTorrentSection> createState() => _YtsTorrentSectionState();
}

class _YtsTorrentSectionState extends State<YtsTorrentSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _expandedItems = {};

  @override
  void initState() {
    super.initState();

    // Initialize tab controller with the grouped torrent types
    final types = widget.groupedTorrents.keys.toList();
    _tabController = TabController(length: types.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.torrents.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get sorted list of torrent types (keys)
    final types = widget.groupedTorrents.keys.toList();
    if (types.isEmpty) {
      return const SizedBox.shrink();
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Theme colors
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).primaryColor;
    final sectionBgColor = isDarkMode ? Color(0xFF252525) : Colors.white;
    final headerBgColor = isDarkMode ? Color(0xFF303030) : Colors.grey[100];

    return Material(
      color: sectionBgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Download Options header
          Container(
            color: headerBgColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  size: 20,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'Download Options',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: primaryColor,
            unselectedLabelColor:
                isDarkMode ? Colors.grey[400] : Colors.grey[700],
            indicatorColor: primaryColor,
            tabs:
                types.map((type) {
                  final count = widget.groupedTorrents[type]?.length ?? 0;
                  return Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(capitalizeFirstLetter(type)),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),

          // Tab content
          SizedBox(
            height: 300, // Fixed height for tab content
            child: TabBarView(
              controller: _tabController,
              children:
                  types.map((type) {
                    final typeTorrents = widget.groupedTorrents[type] ?? [];
                    return _buildTorrentList(
                      typeTorrents,
                      isDarkMode,
                      primaryColor,
                      textColor,
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTorrentList(
    List<Torrent> torrents,
    bool isDarkMode,
    Color primaryColor,
    Color? textColor,
  ) {
    final cardBgColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final codeBoxColor = isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100]!;
    final codeBoxBorderColor =
        isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final buttonBgColor = isDarkMode ? Color(0xFF303030) : Colors.grey[50]!;

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: torrents.length,
      itemBuilder: (context, index) {
        final torrent = torrents[index];
        final uniqueId = '${torrent.hash}_$index';
        final isExpanded = _expandedItems.contains(uniqueId);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          color: cardBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row (always visible)
              InkWell(
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedItems.remove(uniqueId);
                    } else {
                      _expandedItems.add(uniqueId);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Quality tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getQualityColor(
                            torrent.quality,
                            primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          torrent.quality,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Seeds count
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${torrent.seeds}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 12),

                      // Peers count
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            size: 14,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${torrent.peers}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),

                      // Size (right-aligned)
                      Spacer(),
                      Text(
                        torrent.size,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Expansion indicator
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded content
              if (isExpanded)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: buttonBgColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload date info
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Uploaded: ${torrent.uploadDate}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Magnet Link Box with Copy option
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Magnet Link',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () => _copyToClipboard(
                                      torrent.magnet,
                                      'Magnet link',
                                    ),
                                child: Text(
                                  'Copy',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: codeBoxColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: codeBoxBorderColor),
                            ),
                            child: Text(
                              torrent.magnet,
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[800],
                                fontFamily: 'monospace',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Magnet button - full width
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _openMagnet(torrent.magnet),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor:
                                isDarkMode ? Colors.black : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.download,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text('Download'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getQualityColor(String quality, Color primaryColor) {
    quality = quality.toLowerCase();
    if (quality.contains('720p')) {
      return Colors.blue;
    }
    if (quality.contains('1080p')) {
      return primaryColor;
    }
    if (quality.contains('2160p') || quality.contains('4k')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openMagnet(String magnetLink) async {
    final uri = Uri.parse(magnetLink);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open magnet link: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
