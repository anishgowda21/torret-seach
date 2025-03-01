import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/model/l1337x_torrent_detail.dart';
import 'package:my_app/services/l1337x_search_service.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E9),
      appBar: AppBar(
        title: Text(
          'Torrent Details',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                // ignore: deprecated_member_use
                const Color(0xFFF8E8B0).withOpacity(0.5), // Light gold hint
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
              _buildTorrentHeaderCard(torrent),

              const SizedBox(height: 16),

              // Torrent metadata card
              _buildMetadataCard(torrent),

              const SizedBox(height: 16),

              // Magnet link card
              _buildMagnetCard(torrent),

              const SizedBox(height: 16),

              // Files card (if available)
              if (torrent.files.isNotEmpty) _buildFilesCard(torrent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTorrentHeaderCard(L1337xTorrentDetail torrent) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey[800]!, Colors.grey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                    // ignore: deprecated_member_use
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
                    // ignore: deprecated_member_use
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
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    torrent.category,
                    style: const TextStyle(
                      color: Colors.white,
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

  Widget _buildMetadataCard(L1337xTorrentDetail torrent) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Size', torrent.size),
            _buildInfoRow('Upload Date', torrent.uploadDate),
            _buildInfoRow('Language', torrent.language),
            _buildInfoRow('Type', torrent.type),
            _buildInfoRow('Uploader', torrent.uploader),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildMagnetCard(L1337xTorrentDetail torrent) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Magnet Link',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(torrent.magnet),
                  icon: const Icon(
                    Icons.copy,
                    size: 16,
                    color: Color(0xFFD4AF37),
                  ),
                  label: const Text(
                    'Copy',
                    style: TextStyle(color: Color(0xFFD4AF37)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                torrent.magnet,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
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
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
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

  Widget _buildFilesCard(L1337xTorrentDetail torrent) {
    return Card(
      elevation: 2,
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
                  const Icon(Icons.folder, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 8),
                  Text(
                    'Files (${torrent.files.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _showFiles
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),

          // Files list (collapsible)
          if (_showFiles)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
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
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      file.size,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
