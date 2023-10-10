import 'dart:convert';

class UploadImageStoryResponse {
  final bool error;
  final String message;

  UploadImageStoryResponse({
    required this.error,
    required this.message,
  });

  factory UploadImageStoryResponse.fromRawJson(String str) =>
      UploadImageStoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UploadImageStoryResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageStoryResponse(
      error: json["error"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
    };
  }
}
