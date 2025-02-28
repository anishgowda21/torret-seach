class CardData {
  final String name;
  final String description;
  final String imdb;
  final String language;
  final int year;
  final String? coverImage;

  CardData({
    required this.name,
    required this.description,
    required this.imdb,
    required this.language,
    required this.year,
    this.coverImage,
  });
}
