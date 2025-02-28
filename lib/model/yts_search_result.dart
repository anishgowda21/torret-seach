class YtsSearchResult {
  final String status;
  final int movieCount;
  final String query;
  final List<Movie> data;

  YtsSearchResult({
    required this.status,
    required this.movieCount,
    required this.query,
    required this.data,
  });

  factory YtsSearchResult.fromJson(Map<String, dynamic> json) {
    return YtsSearchResult(
      status: json['status'],
      movieCount: json['movie_count'],
      query: json['query'],
      data: List<Movie>.from(json['data'].map((x) => Movie.fromJson(x))),
    );
  }
}

class Movie {
  final String name;
  final String coverImage;
  final String description;
  final String imdb;
  final int year;
  final String language;
  final List<Torrent> torrents;
  Map<String, List<Torrent>> groupedTorrents = {};

  Movie({
    required this.name,
    required this.coverImage,
    required this.description,
    required this.imdb,
    required this.year,
    required this.language,
    required this.torrents,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'],
      coverImage: json['cover_image'],
      description: json['description'],
      imdb: json['imdb'],
      year: json['year'],
      language: json['language'],
      torrents: List<Torrent>.from(
        json['torrents'].map((x) => Torrent.fromJson(x)),
      ),
    );
  }

  void transformTorrents() {
    for (var torrent in torrents) {
      final type = torrent.type;

      if (groupedTorrents.containsKey(type)) {
        groupedTorrents[type]!.add(torrent);
      } else {
        groupedTorrents[type] = [torrent];
      }
    }
  }
}

class Torrent {
  final String torrentFile;
  final String magnet;
  final String quality;
  final String type;
  final int seeds;
  final int peers;
  final String size;
  final String uploadDate;
  final String hash;

  Torrent({
    required this.torrentFile,
    required this.magnet,
    required this.quality,
    required this.type,
    required this.seeds,
    required this.peers,
    required this.size,
    required this.uploadDate,
    required this.hash,
  });

  factory Torrent.fromJson(Map<String, dynamic> json) {
    return Torrent(
      torrentFile: json['torrent_file'],
      magnet: json['magnet'],
      quality: json['quality'],
      type: json['type'],
      seeds: json['seeds'] ?? 0,
      peers: json['peers'] ?? 0,
      size: json['size'],
      uploadDate: json['upload_date'],
      hash: json['hash'],
    );
  }
}
