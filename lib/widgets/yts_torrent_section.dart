import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/model/yts_search_result.dart';

class YtsTorrentSection extends StatefulWidget {
  final List<Torrent> torrents;

  const YtsTorrentSection({required this.torrents, super.key});

  @override
  State<YtsTorrentSection> createState() => _YtsTorrentSectionState();
}

class _YtsTorrentSectionState extends State<YtsTorrentSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, List<Torrent>> _groupedTorrents;
  final Set<String> _expandedItems = {}; // Set to final

  @override
  void initState() {
    super.initState();
    // Group torrents by type
    _groupedTorrents = {};
    for (var torrent in widget.torrents) {
      if (!_groupedTorrents.containsKey(torrent.type)) {
        _groupedTorrents[torrent.type] = [];
      }
      _groupedTorrents[torrent.type]!.add(torrent);
    }

    // Initialize tab controller
    _tabController = TabController(
      length: _groupedTorrents.keys.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.torrents.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get sorted list of torrent types (keys)
    final types = _groupedTorrents.keys.toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(Icons.download, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Download Options',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Tab bar for torrent types
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            tabs:
                types.map((type) {
                  final count = _groupedTorrents[type]?.length ?? 0;
                  return Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(type),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            // ignore: deprecated_member_use
                            ).colorScheme.primary.withOpacity(0.2),
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

          // Tab content - torrent lists
          SizedBox(
            height: 300, // Adjusted height for expanded items
            child: TabBarView(
              controller: _tabController,
              children:
                  types.map((type) {
                    final typeTorrents = _groupedTorrents[type] ?? [];
                    return _buildTorrentList(typeTorrents);
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTorrentList(List<Torrent> torrents) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: torrents.length,
      itemBuilder: (context, index) {
        final torrent = torrents[index];
        final isExpanded = _expandedItems.contains(torrent.hash);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedItems.remove(torrent.hash);
                } else {
                  _expandedItems.add(torrent.hash);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collapsed view (always visible)
                  Row(
                    children: [
                      // Quality tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getQualityColor(torrent.quality),
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
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${torrent.peers}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                        ),
                      ),

                      // Expansion indicator
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                      ),
                    ],
                  ),

                  // Expanded view (only visible when expanded)
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Upload date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Uploaded: ${torrent.uploadDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _copyToClipboard(torrent.hash, 'Hash');
                            },
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy Hash'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _copyToClipboard(torrent.magnet, 'Magnet link');
                            },
                            icon: const Icon(Icons.link, size: 16),
                            label: const Text('Magnet'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getQualityColor(String quality) {
    quality = quality.toLowerCase();
    if (quality.contains('720p')) return Colors.blue;
    if (quality.contains('1080p')) return Colors.purple;
    if (quality.contains('2160p') || quality.contains('4k')) return Colors.red;
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
}
