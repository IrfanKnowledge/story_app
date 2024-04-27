import 'package:freezed_annotation/freezed_annotation.dart';

part 'loading_state.freezed.dart';

@freezed
class LoadingState<T> with _$LoadingState<T> {
  const factory LoadingState.initial() = Initial;
  const factory LoadingState.loading() = Loading;
  const factory LoadingState.loaded(T data) = Loaded;
  const factory LoadingState.error(String message) = Error;
}
