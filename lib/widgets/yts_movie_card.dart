import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:my_app/model/yts_search_result.dart';
import 'package:my_app/widgets/yts_torrent_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';





class YtsMovieCard extends StatelessWidget {
  final Movie movie;

  const YtsMovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            _buildCoverImage(),
            const SizedBox(height: 8),
            // Title and Year
            _buildTitleAndYear(),
            const SizedBox(height: 4),
            // Language
            _buildLanguage(),
            const SizedBox(height: 8),
            // IMDb Button
            _buildImdbButton(),
            const SizedBox(height: 8),
            // Torrent Dropdown
            YtsTorrentDropdown(torrents: movie.torrents),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    if (movie.coverImage.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.movie, size: 50, color: Colors.grey),
      );
    }
    return Image.memory(
      Uri.parse(movie.coverImage).data!.contentAsBytes(),
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Icon(Icons.error, size: 50, color: Colors.red),
          ),
    );
  }

  Widget _buildTitleAndYear() {
    final title = movie.name.isEmpty ? "Unknown Title" : movie.name;
    final year = movie.year == 0 ? "" : " (${movie.year})";
    return Text(
      "$title$year",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLanguage() {
    final language = _getFullLanguageName(movie.language);
    return Text(
      "Language: $language",
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  Widget _buildImdbButton() {
    if (movie.imdb.isEmpty) {
      return const SizedBox.shrink(); // Hide button if IMDb ID is empty
    }
    return ElevatedButton(
      onPressed: () async {
        final url = Uri.parse("https://www.imdb.com/title/${movie.imdb}");
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: const Text("View on IMDb"),
    );
  }

  String _getFullLanguageName(String code) {
    try {
      return Language.fromIsoCode(code).name;
    } catch (e) {
      return 'Unknown';
    }
  }
}
