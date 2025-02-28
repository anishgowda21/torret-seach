import 'package:flutter/material.dart';
import 'package:my_app/model/yts_search_result.dart';

class YtsTorrentDropdown extends StatelessWidget {
  final List<Torrent> torrents;

  const YtsTorrentDropdown({required this.torrents, super.key});

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (torrents.isEmpty) {
      return const Text(
        "No torrents available",
        style: TextStyle(color: Colors.grey),
      );
    }

    // Group torrents by type
    final groupedTorrents = <String, List<Torrent>>{};
    for (var torrent in torrents) {
      groupedTorrents.putIfAbsent(torrent.type, () => []).add(torrent);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Torrents:", style: TextStyle(fontWeight: FontWeight.bold)),
        ...groupedTorrents.entries.map(
          (entry) => ExpansionTile(
            title: Text(
              "${_capitalizeFirstLetter(entry.key)} (${entry.value.length})",
            ),
            children:
                entry.value
                    .map(
                      (torrent) => ListTile(
                        title: Text(torrent.quality),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seeders: ${torrent.seeds} • Peers: ${torrent.peers}",
                            ),
                            Text("Size: ${torrent.size}"),
                            Text("Uploaded: ${torrent.uploadDate}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                // Logic to copy torrent.hash to clipboard
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Hash copied: ${torrent.hash}",
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.link),
                              onPressed: () {
                                // Logic to copy torrent.magnet to clipboard
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Magnet copied: ${torrent.magnet}",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
