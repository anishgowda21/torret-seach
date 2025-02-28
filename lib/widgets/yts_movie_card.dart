import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:my_app/model/yts_search_result.dart';
import 'package:my_app/widgets/yts_torrent_section.dart';
import 'package:url_launcher/url_launcher.dart';

class YtsMovieCard extends StatefulWidget {
  final Movie movie;

  const YtsMovieCard({required this.movie, super.key});

  @override
  State<YtsMovieCard> createState() => _YtsMovieCardState();
}

class _YtsMovieCardState extends State<YtsMovieCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final hasTorrents = movie.torrents.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias, // Ensures image corners match card
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie header section with image and details
          _buildMovieHeader(movie),

          // Movie information section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title, year and language row
                _buildTitleSection(movie),

                // Expandable description
                if (movie.description.isNotEmpty)
                  _buildDescription(movie.description),

                const SizedBox(height: 16),

                // Action buttons
                _buildActionButtons(movie),
              ],
            ),
          ),

          // Torrents section
          if (hasTorrents) YtsTorrentSection(torrents: movie.torrents),
        ],
      ),
    );
  }

  Widget _buildMovieHeader(Movie movie) {
    return Stack(
      children: [
        // Movie cover image
        SizedBox(
          height: 200,
          width: double.infinity,
          child: _buildCoverImage(movie),
        ),

        // Gradient overlay for better text visibility
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // ignore: deprecated_member_use
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ),

        // IMDb badge in top right corner
        if (movie.imdb.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5C518), // IMDb yellow
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.black, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'IMDb',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCoverImage(Movie movie) {
    if (movie.coverImage.isEmpty) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: Icon(Icons.movie, size: 64, color: Colors.white70),
        ),
      );
    }

    return Image.memory(
      Uri.parse(movie.coverImage).data!.contentAsBytes(),
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Container(
            color: Colors.grey[800],
            child: const Center(
              child: Icon(Icons.broken_image, size: 64, color: Colors.white70),
            ),
          ),
    );
  }

  Widget _buildTitleSection(Movie movie) {
    final title = movie.name.isEmpty ? "Unknown Title" : movie.name;
    final year = movie.year == 0 ? "" : " (${movie.year})";
    final language = _getFullLanguageName(movie.language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title$year",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.language, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              language,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: AnimatedCrossFade(
            firstChild: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
            secondChild: Text(description, style: TextStyle(fontSize: 14)),
            crossFadeState:
                _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_expanded ? 'Show less' : 'Read more'),
              Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Movie movie) {
    return Row(
      children: [
        if (movie.imdb.isNotEmpty)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _launchImdb(movie.imdb);
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('View on IMDb'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _launchImdb(String imdbId) async {
    final url = Uri.parse("https://www.imdb.com/title/$imdbId");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _getFullLanguageName(String code) {
    try {
      return Language.fromIsoCode(code).name;
    } catch (e) {
      return code.toUpperCase();
    }
  }
}
