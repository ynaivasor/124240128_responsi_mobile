import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 0)
class Game extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String thumbnail;
  @HiveField(3)
  final String genre;
  @HiveField(4)
  final String platform;
  @HiveField(5)
  final String publisher;
  @HiveField(6)
  final String developer;
  @HiveField(7)
  final String releaseDate;
  @HiveField(8)
  final String description;
  @HiveField(9)
  final List<String> screenshots;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.description,
    required this.screenshots,
  });

  // factory constructor untuk pembuatan instance Game dari JSON
  factory Game.fromJson(Map<String, dynamic> json) {
    List rawScreenshots = json['screenshots'] ?? [];
    return Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      releaseDate: json['release_date'],
      description: json['description'] ?? '',
      screenshots: rawScreenshots.map((e) => e['image'] as String).toList(),
    );
  }
}
