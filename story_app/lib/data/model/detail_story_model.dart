import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_story_model.freezed.dart';

part 'detail_story_model.g.dart';

@freezed
class DetailStoryModel with _$DetailStoryModel {
  const factory DetailStoryModel({
    required final bool error,
    required final String message,
    required final Story story,
  }) = _DetailStoryModel;

  factory DetailStoryModel.fromRawJson(String str) =>
      DetailStoryModel.fromJson(json.decode(str));

  factory DetailStoryModel.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryModelFromJson(json);
}

@freezed
class Story with _$Story {
  const factory Story({
    required final String id,
    required final String name,
    required final String description,
    required final String photoUrl,
    required final DateTime createdAt,
    required final dynamic lat,
    required final dynamic lon,
  }) = _Story;

  factory Story.fromRawJson(String str) => Story.fromJson(json.decode(str));

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
