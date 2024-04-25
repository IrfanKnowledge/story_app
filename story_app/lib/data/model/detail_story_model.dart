import 'dart:convert';

class DetailStoryWrap {
  final bool error;
  final String message;
  final Story story;

  DetailStoryWrap({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryWrap.fromRawJson(String str) =>
      DetailStoryWrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailStoryWrap.fromJson(Map<String, dynamic> json) {

    return DetailStoryWrap(
      error: json["error"],
      message: json["message"],
      story: Story.fromJson(json["story"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "story": story.toJson(),
    };
  }
}

class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final dynamic lat;
  final dynamic lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory Story.fromRawJson(String str) => Story.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      photoUrl: json["photoUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
      lat: json["lat"],
      lon: json["lon"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "photoUrl": photoUrl,
      "createdAt": createdAt.toIso8601String(),
      "lat": lat,
      "lon": lon,
    };
  }
}
