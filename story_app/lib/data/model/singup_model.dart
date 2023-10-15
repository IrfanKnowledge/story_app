import 'dart:convert';

class SignupWrap {
  final bool error;
  final String message;

  SignupWrap({
    required this.error,
    required this.message,
  });

  factory SignupWrap.fromRawJson(String str) => SignupWrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignupWrap.fromJson(Map<String, dynamic> json) => SignupWrap(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}
