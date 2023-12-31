import 'dart:convert';

class LoginWrap {
  final bool error;
  final String message;
  final LoginResult? loginResult;

  LoginWrap({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginWrap.fromRawJson(String str) => LoginWrap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginWrap.fromJson(Map<String, dynamic> json) {
    LoginResult? loginResult;

    if (json.containsKey("loginResult")) {
      loginResult = LoginResult.fromJson(json["loginResult"]);
    } else {
      loginResult = null;
    }

    return LoginWrap(
      error: json["error"],
      message: json["message"],
      loginResult: loginResult,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "loginResult": loginResult?.toJson(),
    };
  }
}

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  factory LoginResult.fromRawJson(String str) =>
      LoginResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json["userId"],
      name: json["name"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "token": token,
    };
  }
}
