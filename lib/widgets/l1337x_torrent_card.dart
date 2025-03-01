import 'package:flutter/material.dart';
import 'package:my_app/model/l1337x_search_result.dart';
import 'package:my_app/screens/l1337x_detail_screen.dart';
import 'package:my_app/services/l1337x_search_service.dart';

class L1337xTorrentCard extends StatefulWidget {
  final L1337xTorrentItem torrent;
  final L1337xSearchService service;

  const L1337xTorrentCard({
    super.key,
    required this.torrent,
    required this.service,
  });

  @override
  State<L1337xTorrentCard> createState() => _L1337xTorrentCardState();
}

class _L1337xTorrentCardState extends State<L1337xTorrentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      color: const Color.fromARGB(255, 243, 229, 215),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Torrent information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Torrent name
                Text(
                  widget.torrent.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Torrent metadata
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sd_storage,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.torrent.size,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.torrent.date,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Seeds and leeches indicators
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.torrent.seeds,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.torrent.leeches,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // View Details button
          Container(
            width: double.infinity,
            color: Colors.grey[50],
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: _viewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _viewDetails() async {
    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Fetch torrent details
      final details = await widget.service.getDetails(widget.torrent.link);

      // Check if widget is still in the tree
      if (!mounted) return;

      // Remove loading indicator
      Navigator.pop(context);

      // Check again after popping the dialog
      if (!mounted) return;

      // Navigate to details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => L1337xDetailScreen(
                torrentDetail: details,
                service: widget.service,
              ),
        ),
      );
    } catch (e) {
      // Check if widget is still in the tree
      if (!mounted) return;

      // Remove loading indicator
      Navigator.pop(context);

      // Check again after popping the dialog
      if (!mounted) return;

      // Show error dialog
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Failed to load torrent details: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}
