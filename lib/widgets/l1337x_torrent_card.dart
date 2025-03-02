import 'package:flutter/material.dart';
import 'package:torret_seach/model/l1337x_search_result.dart';
import 'package:torret_seach/providers/theme_provider.dart';
import 'package:torret_seach/screens/l1337x_detail_screen.dart';
import 'package:torret_seach/services/l1337x_search_service.dart';
import 'package:torret_seach/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Get theme colors
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final secondaryTextColor = Theme.of(
      context,
      // ignore: deprecated_member_use
    ).textTheme.bodyMedium?.color?.withOpacity(0.7);
    final cardColor =
        isDarkMode
            ? Color.fromARGB(
              255,
              40,
              35,
              30,
            ) // Darker creamy color for dark mode
            : Color.fromARGB(255, 243, 229, 215); // Original creamy color
    final primaryColor = Theme.of(context).primaryColor;
    final buttonBackgroundColor =
        isDarkMode ? Color.fromARGB(255, 50, 50, 50) : Colors.grey[50];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      color: cardColor,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
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
                                color: secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.torrent.size,
                                style: TextStyle(color: secondaryTextColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.torrent.date,
                                style: TextStyle(color: secondaryTextColor),
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
            color: buttonBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: _viewDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
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
    // Show improved loading dialog
    if (!mounted) return;
    LoadingDialog.show(context, message: 'Fetching torrent details');

    try {
      // Fetch torrent details
      final details = await widget.service.getDetails(widget.torrent.link);

      // Check if widget is still in the tree
      if (!mounted) return;

      // Remove loading dialog
      LoadingDialog.hide(context);

      // Check again after hiding dialog
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

      // Remove loading dialog
      LoadingDialog.hide(context);

      // Show error dialog
      if (!mounted) return;
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
