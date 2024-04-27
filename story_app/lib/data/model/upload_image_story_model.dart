import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_image_story_model.freezed.dart';

part 'upload_image_story_model.g.dart';

@freezed
class UploadImageStoryModel with _$UploadImageStoryModel {
  const factory UploadImageStoryModel({
    required bool error,
    required String message,
  }) = _UploadImageStoryModel;

  factory UploadImageStoryModel.fromRawJson(String str) =>
      UploadImageStoryModel.fromJson(json.decode(str));

  factory UploadImageStoryModel.fromJson(Map<String, dynamic> json) =>
      _$UploadImageStoryModelFromJson(json);
}
