class L1337xTorrentDetail {
  final String name;
  final String magnet;
  final String category;
  final String type;
  final String language;
  final String uploadDate;
  final String size;
  final String seeds;
  final String leeches;
  final String uploader;
  final List<L1337xFile> files;

  L1337xTorrentDetail({
    required this.name,
    required this.magnet,
    required this.category,
    required this.type,
    required this.language,
    required this.uploadDate,
    required this.size,
    required this.seeds,
    required this.leeches,
    required this.uploader,
    required this.files,
  });

  factory L1337xTorrentDetail.fromJson(Map<String, dynamic> json) {
    return L1337xTorrentDetail(
      name: json['name'] ?? 'Unknown',
      magnet: json['magnet'] ?? 'Not available',
      category: json['category'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      language: json['language'] ?? 'Unknown',
      uploadDate: json['uploadDate'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
      seeds: json['seeds'] ?? '0',
      leeches: json['leeches'] ?? '0',
      uploader: json['uploader'] ?? 'Unknown',
      files:
          json['files'] != null
              ? List<L1337xFile>.from(
                json['files'].map((x) => L1337xFile.fromJson(x)),
              )
              : [],
    );
  }

  // Parse seeds as integer for UI display
  int get seedsCount => int.tryParse(seeds) ?? 0;

  // Parse leeches as integer for UI display
  int get leechesCount => int.tryParse(leeches) ?? 0;
}

class L1337xFile {
  final String name;
  final String size;

  L1337xFile({required this.name, required this.size});

  factory L1337xFile.fromJson(Map<String, dynamic> json) {
    return L1337xFile(
      name: json['name'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
    );
  }
}
