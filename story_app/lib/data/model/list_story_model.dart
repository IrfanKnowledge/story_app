import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_story_model.freezed.dart';

part 'list_story_model.g.dart';

@freezed
class ListStoryModel with _$ListStoryModel {
  const factory ListStoryModel({
    required final bool error,
    required final String message,
    required final List<ListStory> listStory,
  }) = _ListStoryModel;

  factory ListStoryModel.fromRawJson(String str) =>
      ListStoryModel.fromJson(json.decode(str));

  factory ListStoryModel.fromJson(Map<String, dynamic> json) =>
      _$ListStoryModelFromJson(json);
}

@freezed
class ListStory with _$ListStory {

  const factory ListStory({
    required final String id,
    required final String name,
    required final String description,
    required final String photoUrl,
    required final DateTime createdAt,
    required final double? lat,
    required final double? lon,
  }) = _ListStory ;

  factory ListStory.fromRawJson(String str) =>
      ListStory.fromJson(json.decode(str));

  factory ListStory.fromJson(Map<String, dynamic> json) =>
      _$ListStoryFromJson(json);
}
