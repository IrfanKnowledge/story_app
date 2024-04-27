// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_image_story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UploadImageStoryModel _$UploadImageStoryModelFromJson(
    Map<String, dynamic> json) {
  return _UploadImageStoryModel.fromJson(json);
}

/// @nodoc
mixin _$UploadImageStoryModel {
  bool get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UploadImageStoryModelCopyWith<UploadImageStoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadImageStoryModelCopyWith<$Res> {
  factory $UploadImageStoryModelCopyWith(UploadImageStoryModel value,
          $Res Function(UploadImageStoryModel) then) =
      _$UploadImageStoryModelCopyWithImpl<$Res, UploadImageStoryModel>;
  @useResult
  $Res call({bool error, String message});
}

/// @nodoc
class _$UploadImageStoryModelCopyWithImpl<$Res,
        $Val extends UploadImageStoryModel>
    implements $UploadImageStoryModelCopyWith<$Res> {
  _$UploadImageStoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadImageStoryModelImplCopyWith<$Res>
    implements $UploadImageStoryModelCopyWith<$Res> {
  factory _$$UploadImageStoryModelImplCopyWith(
          _$UploadImageStoryModelImpl value,
          $Res Function(_$UploadImageStoryModelImpl) then) =
      __$$UploadImageStoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool error, String message});
}

/// @nodoc
class __$$UploadImageStoryModelImplCopyWithImpl<$Res>
    extends _$UploadImageStoryModelCopyWithImpl<$Res,
        _$UploadImageStoryModelImpl>
    implements _$$UploadImageStoryModelImplCopyWith<$Res> {
  __$$UploadImageStoryModelImplCopyWithImpl(_$UploadImageStoryModelImpl _value,
      $Res Function(_$UploadImageStoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_$UploadImageStoryModelImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadImageStoryModelImpl implements _UploadImageStoryModel {
  const _$UploadImageStoryModelImpl(
      {required this.error, required this.message});

  factory _$UploadImageStoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadImageStoryModelImplFromJson(json);

  @override
  final bool error;
  @override
  final String message;

  @override
  String toString() {
    return 'UploadImageStoryModel(error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadImageStoryModelImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadImageStoryModelImplCopyWith<_$UploadImageStoryModelImpl>
      get copyWith => __$$UploadImageStoryModelImplCopyWithImpl<
          _$UploadImageStoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadImageStoryModelImplToJson(
      this,
    );
  }
}

abstract class _UploadImageStoryModel implements UploadImageStoryModel {
  const factory _UploadImageStoryModel(
      {required final bool error,
      required final String message}) = _$UploadImageStoryModelImpl;

  factory _UploadImageStoryModel.fromJson(Map<String, dynamic> json) =
      _$UploadImageStoryModelImpl.fromJson;

  @override
  bool get error;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$UploadImageStoryModelImplCopyWith<_$UploadImageStoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
