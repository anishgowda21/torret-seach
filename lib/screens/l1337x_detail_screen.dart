// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/model/l1337x_torrent_detail.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/services/l1337x_search_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class L1337xDetailScreen extends StatefulWidget {
  final L1337xTorrentDetail torrentDetail;
  final L1337xSearchService service;

  const L1337xDetailScreen({
    super.key,
    required this.torrentDetail,
    required this.service,
  });

  @override
  State<L1337xDetailScreen> createState() => _L1337xDetailScreenState();
}

class _L1337xDetailScreenState extends State<L1337xDetailScreen> {
  bool _showFiles = false;

  @override
  Widget build(BuildContext context) {
    final torrent = widget.torrentDetail;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Get theme colors
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).primaryColor;
    final cardBgColor = isDarkMode ? Color(0xFF252525) : Colors.white;

    // Create a darker header gradient for dark mode
    final headerGradient = LinearGradient(
      colors:
          isDarkMode
              ? [Colors.grey[900]!, Colors.black]
              : [Colors.grey[800]!, Colors.grey[900]!],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Torrent Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [const Color(0xFF1A1A1A), const Color(0xFF2C2C2C)]
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
              // Torrent header card
              _buildTorrentHeaderCard(torrent, headerGradient, isDarkMode),

              const SizedBox(height: 16),

              // Torrent metadata card
              _buildMetadataCard(torrent, cardBgColor, textColor, isDarkMode),

              const SizedBox(height: 16),

              // Magnet link card
              _buildMagnetCard(
                torrent,
                cardBgColor,
                primaryColor,
                textColor,
                isDarkMode,
              ),

              const SizedBox(height: 16),

              // Files card (if available)
              if (torrent.files.isNotEmpty)
                _buildFilesCard(
                  torrent,
                  cardBgColor,
                  primaryColor,
                  textColor,
                  isDarkMode,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTorrentHeaderCard(
    L1337xTorrentDetail torrent,
    LinearGradient headerGradient,
    bool isDarkMode,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: headerGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              torrent.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Seeds
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        torrent.seeds,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Leeches
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        torrent.leeches,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Category tag
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    torrent.category,
                    style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(
    L1337xTorrentDetail torrent,
    Color cardBgColor,
    Color? textColor,
    bool isDarkMode,
  ) {
    final labelColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Card(
      elevation: 2,
      color: cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Size', torrent.size, labelColor, textColor),
            _buildInfoRow(
              'Upload Date',
              torrent.uploadDate,
              labelColor,
              textColor,
            ),
            _buildInfoRow('Language', torrent.language, labelColor, textColor),
            _buildInfoRow('Type', torrent.type, labelColor, textColor),
            _buildInfoRow('Uploader', torrent.uploader, labelColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    Color? labelColor,
    Color? textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagnetCard(
    L1337xTorrentDetail torrent,
    Color cardBgColor,
    Color primaryColor,
    Color? textColor,
    bool isDarkMode,
  ) {
    final codeBoxColor = isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100]!;
    final codeBoxBorderColor =
        isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final codeTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[800]!;

    return Card(
      elevation: 2,
      color: cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Magnet Link',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(torrent.magnet),
                  icon: Icon(Icons.copy, size: 16, color: primaryColor),
                  label: Text('Copy', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: codeBoxColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: codeBoxBorderColor),
              ),
              child: Text(
                torrent.magnet,
                style: TextStyle(
                  fontSize: 12,
                  color: codeTextColor,
                  fontFamily: 'monospace',
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openMagnet(torrent.magnet),
                icon: const Icon(Icons.download),
                label: const Text('Download with Magnet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilesCard(
    L1337xTorrentDetail torrent,
    Color cardBgColor,
    Color primaryColor,
    Color? textColor,
    bool isDarkMode,
  ) {
    final listBgColor = isDarkMode ? Colors.grey[900] : Colors.grey[50];

    return Card(
      elevation: 2,
      color: cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header with expand/collapse button
          InkWell(
            onTap: () {
              setState(() {
                _showFiles = !_showFiles;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.folder, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Files (${torrent.files.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _showFiles
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),

          // Files list (collapsible)
          if (_showFiles)
            Container(
              decoration: BoxDecoration(
                color: listBgColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              height: 200, // Fixed height with scrolling
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: torrent.files.length,
                itemBuilder: (context, index) {
                  final file = torrent.files[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      file.name,
                      style: TextStyle(fontSize: 14, color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      file.size,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Magnet link copied to clipboard'),
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
