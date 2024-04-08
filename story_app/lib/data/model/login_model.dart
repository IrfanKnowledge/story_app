import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

@freezed
class LoginModel with _$LoginModel {
  const factory LoginModel({
    required final bool error,
    required final String message,
    required final LoginResult? loginResult,
  }) = _LoginModel;

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);
}

@freezed
class LoginResult with _$LoginResult {
  const factory LoginResult({
    required final String userId,
    required final String name,
    required final String token,
  }) = _LoginResult;

  factory LoginResult.fromRawJson(String str) =>
      LoginResult.fromJson(json.decode(str));

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
}
