import 'dart:convert';

class ListStoryWrap {
  final bool error;
  final String message;
  final List<ListStory>? listStory;

  ListStoryWrap({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStoryWrap.fromRawJson(String str) =>
      ListStoryWrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListStoryWrap.fromJson(Map<String, dynamic> json) {
    List<ListStory>? listStory;

    if (json.containsKey("listStory")) {
      listStory = List<ListStory>.from(json["listStory"].map((x) => ListStory.fromJson(x)));
    } else {
      listStory = null;
    }

    return ListStoryWrap(
        error: json["error"],
        message: json["message"],
        listStory: listStory,
      );
  }

  Map<String, dynamic> toJson() {
    if (listStory == null) {
      return {
        "error": error,
        "message": message,
      };
    } else {
      return {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory!.map((x) => x.toJson())),
      };
    }
  }
}

class ListStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory ListStory.fromRawJson(String str) =>
      ListStory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListStory.fromJson(Map<String, dynamic> json) => ListStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
