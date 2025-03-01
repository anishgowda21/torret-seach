// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:my_app/model/yts_search_result.dart';
import 'package:my_app/providers/theme_provider.dart';
import 'package:my_app/widgets/yts_torrent_section.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class YtsMovieCard extends StatefulWidget {
  final Movie movie;

  const YtsMovieCard({required this.movie, super.key});

  @override
  State<YtsMovieCard> createState() => _YtsMovieCardState();
}

class _YtsMovieCardState extends State<YtsMovieCard> {
  bool _expanded = false;
  bool _showTorrents = false;

  @override
  void initState() {
    super.initState();
    // Process torrents for grouping
    widget.movie.transformTorrents();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final hasTorrents = movie.torrents.isNotEmpty;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Use the consistent gold color from theme instead of purple
    final primaryColor = Theme.of(context).primaryColor; // Gold

    // For dark mode, use dark backgrounds matching 1337x
    final cardColor =
        isDarkMode
            ? Color(0xFF1E1E1E) // Dark card color matching 1337x
            : Color.fromARGB(255, 243, 229, 215); // Original creamy color

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias, // Ensures image corners match card
      elevation: 3,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie header section with image and details - this stays fixed
          _buildMovieHeader(movie),

          // Movie information section
          Container(
            color: isDarkMode ? Color(0xFF272727) : Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title, year and language row
                _buildTitleSection(movie),

                // Expandable description
                if (movie.description.isNotEmpty)
                  _buildDescription(movie.description, primaryColor),

                const SizedBox(height: 16),

                // Action buttons
                _buildActionButtons(movie, primaryColor, isDarkMode),
              ],
            ),
          ),

          // Torrents toggle button (only if has torrents)
          if (hasTorrents)
            InkWell(
              onTap: () {
                setState(() {
                  _showTorrents = !_showTorrents;
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _showTorrents
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: primaryColor, // Golden color instead of purple
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _showTorrents
                          ? 'Hide download options'
                          : 'Show download options',
                      style: TextStyle(
                        color: primaryColor, // Golden color instead of purple
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Torrents section - only visible when toggled
          if (hasTorrents && _showTorrents)
            YtsTorrentSection(
              torrents: movie.torrents,
              groupedTorrents: movie.groupedTorrents,
            ),
        ],
      ),
    );
  }

  Widget _buildMovieHeader(Movie movie) {
    return Stack(
      children: [
        // Movie cover image - precached to avoid flickering
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

    // Explicitly create a separate widget for the image to prevent flickering
    return Image.memory(
      Uri.parse(movie.coverImage).data!.contentAsBytes(),
      fit: BoxFit.cover,
      gaplessPlayback: true, // Prevents flickering during state changes
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

  Widget _buildDescription(String description, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
          secondChild: Text(description, style: TextStyle(fontSize: 14)),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
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
              Text(
                _expanded ? 'Show less' : 'Read more',
                style: TextStyle(color: primaryColor), // Gold instead of purple
              ),
              Icon(
                _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
                color: primaryColor, // Gold instead of purple
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Movie movie, Color primaryColor, bool isDarkMode) {
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
                backgroundColor: primaryColor, // Gold instead of purple
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
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
