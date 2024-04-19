import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_model.freezed.dart';
part 'signup_model.g.dart';

@freezed
class SignupModel with _$SignupModel {
  const factory SignupModel({
    required final bool error,
    required final String message,
  }) = _SignupModel;

  factory SignupModel.fromRawJson(String str) =>
      SignupModel.fromJson(json.decode(str));

  factory SignupModel.fromJson(Map<String, dynamic> json) =>
      _$SignupModelFromJson(json);
}
