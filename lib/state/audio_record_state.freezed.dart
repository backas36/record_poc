// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_record_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AudioRecordState {
  bool get isRecording => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get completedAudioFilePath => throw _privateConstructorUsedError;

  /// Create a copy of AudioRecordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioRecordStateCopyWith<AudioRecordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioRecordStateCopyWith<$Res> {
  factory $AudioRecordStateCopyWith(
    AudioRecordState value,
    $Res Function(AudioRecordState) then,
  ) = _$AudioRecordStateCopyWithImpl<$Res, AudioRecordState>;
  @useResult
  $Res call({
    bool isRecording,
    bool isPlaying,
    bool isLoading,
    String? completedAudioFilePath,
  });
}

/// @nodoc
class _$AudioRecordStateCopyWithImpl<$Res, $Val extends AudioRecordState>
    implements $AudioRecordStateCopyWith<$Res> {
  _$AudioRecordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioRecordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecording = null,
    Object? isPlaying = null,
    Object? isLoading = null,
    Object? completedAudioFilePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            isRecording: null == isRecording
                ? _value.isRecording
                : isRecording // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPlaying: null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAudioFilePath: freezed == completedAudioFilePath
                ? _value.completedAudioFilePath
                : completedAudioFilePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AudioRecordStateImplCopyWith<$Res>
    implements $AudioRecordStateCopyWith<$Res> {
  factory _$$AudioRecordStateImplCopyWith(
    _$AudioRecordStateImpl value,
    $Res Function(_$AudioRecordStateImpl) then,
  ) = __$$AudioRecordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isRecording,
    bool isPlaying,
    bool isLoading,
    String? completedAudioFilePath,
  });
}

/// @nodoc
class __$$AudioRecordStateImplCopyWithImpl<$Res>
    extends _$AudioRecordStateCopyWithImpl<$Res, _$AudioRecordStateImpl>
    implements _$$AudioRecordStateImplCopyWith<$Res> {
  __$$AudioRecordStateImplCopyWithImpl(
    _$AudioRecordStateImpl _value,
    $Res Function(_$AudioRecordStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AudioRecordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRecording = null,
    Object? isPlaying = null,
    Object? isLoading = null,
    Object? completedAudioFilePath = freezed,
  }) {
    return _then(
      _$AudioRecordStateImpl(
        isRecording: null == isRecording
            ? _value.isRecording
            : isRecording // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPlaying: null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAudioFilePath: freezed == completedAudioFilePath
            ? _value.completedAudioFilePath
            : completedAudioFilePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AudioRecordStateImpl implements _AudioRecordState {
  const _$AudioRecordStateImpl({
    required this.isRecording,
    required this.isPlaying,
    required this.isLoading,
    this.completedAudioFilePath,
  });

  @override
  final bool isRecording;
  @override
  final bool isPlaying;
  @override
  final bool isLoading;
  @override
  final String? completedAudioFilePath;

  @override
  String toString() {
    return 'AudioRecordState(isRecording: $isRecording, isPlaying: $isPlaying, isLoading: $isLoading, completedAudioFilePath: $completedAudioFilePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioRecordStateImpl &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.completedAudioFilePath, completedAudioFilePath) ||
                other.completedAudioFilePath == completedAudioFilePath));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isRecording,
    isPlaying,
    isLoading,
    completedAudioFilePath,
  );

  /// Create a copy of AudioRecordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioRecordStateImplCopyWith<_$AudioRecordStateImpl> get copyWith =>
      __$$AudioRecordStateImplCopyWithImpl<_$AudioRecordStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AudioRecordState implements AudioRecordState {
  const factory _AudioRecordState({
    required final bool isRecording,
    required final bool isPlaying,
    required final bool isLoading,
    final String? completedAudioFilePath,
  }) = _$AudioRecordStateImpl;

  @override
  bool get isRecording;
  @override
  bool get isPlaying;
  @override
  bool get isLoading;
  @override
  String? get completedAudioFilePath;

  /// Create a copy of AudioRecordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioRecordStateImplCopyWith<_$AudioRecordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
