// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListStoryModel _$ListStoryModelFromJson(Map<String, dynamic> json) {
  return _ListStoryModel.fromJson(json);
}

/// @nodoc
mixin _$ListStoryModel {
  bool get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<ListStory> get listStory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListStoryModelCopyWith<ListStoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListStoryModelCopyWith<$Res> {
  factory $ListStoryModelCopyWith(
          ListStoryModel value, $Res Function(ListStoryModel) then) =
      _$ListStoryModelCopyWithImpl<$Res, ListStoryModel>;
  @useResult
  $Res call({bool error, String message, List<ListStory> listStory});
}

/// @nodoc
class _$ListStoryModelCopyWithImpl<$Res, $Val extends ListStoryModel>
    implements $ListStoryModelCopyWith<$Res> {
  _$ListStoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? listStory = null,
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
      listStory: null == listStory
          ? _value.listStory
          : listStory // ignore: cast_nullable_to_non_nullable
              as List<ListStory>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListStoryModelImplCopyWith<$Res>
    implements $ListStoryModelCopyWith<$Res> {
  factory _$$ListStoryModelImplCopyWith(_$ListStoryModelImpl value,
          $Res Function(_$ListStoryModelImpl) then) =
      __$$ListStoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool error, String message, List<ListStory> listStory});
}

/// @nodoc
class __$$ListStoryModelImplCopyWithImpl<$Res>
    extends _$ListStoryModelCopyWithImpl<$Res, _$ListStoryModelImpl>
    implements _$$ListStoryModelImplCopyWith<$Res> {
  __$$ListStoryModelImplCopyWithImpl(
      _$ListStoryModelImpl _value, $Res Function(_$ListStoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? listStory = null,
  }) {
    return _then(_$ListStoryModelImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      listStory: null == listStory
          ? _value._listStory
          : listStory // ignore: cast_nullable_to_non_nullable
              as List<ListStory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListStoryModelImpl implements _ListStoryModel {
  const _$ListStoryModelImpl(
      {required this.error,
      required this.message,
      required final List<ListStory> listStory})
      : _listStory = listStory;

  factory _$ListStoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListStoryModelImplFromJson(json);

  @override
  final bool error;
  @override
  final String message;
  final List<ListStory> _listStory;
  @override
  List<ListStory> get listStory {
    if (_listStory is EqualUnmodifiableListView) return _listStory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listStory);
  }

  @override
  String toString() {
    return 'ListStoryModel(error: $error, message: $message, listStory: $listStory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListStoryModelImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._listStory, _listStory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message,
      const DeepCollectionEquality().hash(_listStory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListStoryModelImplCopyWith<_$ListStoryModelImpl> get copyWith =>
      __$$ListStoryModelImplCopyWithImpl<_$ListStoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListStoryModelImplToJson(
      this,
    );
  }
}

abstract class _ListStoryModel implements ListStoryModel {
  const factory _ListStoryModel(
      {required final bool error,
      required final String message,
      required final List<ListStory> listStory}) = _$ListStoryModelImpl;

  factory _ListStoryModel.fromJson(Map<String, dynamic> json) =
      _$ListStoryModelImpl.fromJson;

  @override
  bool get error;
  @override
  String get message;
  @override
  List<ListStory> get listStory;
  @override
  @JsonKey(ignore: true)
  _$$ListStoryModelImplCopyWith<_$ListStoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ListStory _$ListStoryFromJson(Map<String, dynamic> json) {
  return _ListStory.fromJson(json);
}

/// @nodoc
mixin _$ListStory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get photoUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListStoryCopyWith<ListStory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListStoryCopyWith<$Res> {
  factory $ListStoryCopyWith(ListStory value, $Res Function(ListStory) then) =
      _$ListStoryCopyWithImpl<$Res, ListStory>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String photoUrl,
      DateTime createdAt,
      double? lat,
      double? lon});
}

/// @nodoc
class _$ListStoryCopyWithImpl<$Res, $Val extends ListStory>
    implements $ListStoryCopyWith<$Res> {
  _$ListStoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListStoryImplCopyWith<$Res>
    implements $ListStoryCopyWith<$Res> {
  factory _$$ListStoryImplCopyWith(
          _$ListStoryImpl value, $Res Function(_$ListStoryImpl) then) =
      __$$ListStoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String photoUrl,
      DateTime createdAt,
      double? lat,
      double? lon});
}

/// @nodoc
class __$$ListStoryImplCopyWithImpl<$Res>
    extends _$ListStoryCopyWithImpl<$Res, _$ListStoryImpl>
    implements _$$ListStoryImplCopyWith<$Res> {
  __$$ListStoryImplCopyWithImpl(
      _$ListStoryImpl _value, $Res Function(_$ListStoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_$ListStoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListStoryImpl implements _ListStory {
  const _$ListStoryImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.photoUrl,
      required this.createdAt,
      required this.lat,
      required this.lon});

  factory _$ListStoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListStoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String photoUrl;
  @override
  final DateTime createdAt;
  @override
  final double? lat;
  @override
  final double? lon;

  @override
  String toString() {
    return 'ListStory(id: $id, name: $name, description: $description, photoUrl: $photoUrl, createdAt: $createdAt, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListStoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, photoUrl, createdAt, lat, lon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListStoryImplCopyWith<_$ListStoryImpl> get copyWith =>
      __$$ListStoryImplCopyWithImpl<_$ListStoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListStoryImplToJson(
      this,
    );
  }
}

abstract class _ListStory implements ListStory {
  const factory _ListStory(
      {required final String id,
      required final String name,
      required final String description,
      required final String photoUrl,
      required final DateTime createdAt,
      required final double? lat,
      required final double? lon}) = _$ListStoryImpl;

  factory _ListStory.fromJson(Map<String, dynamic> json) =
      _$ListStoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get photoUrl;
  @override
  DateTime get createdAt;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  @JsonKey(ignore: true)
  _$$ListStoryImplCopyWith<_$ListStoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}