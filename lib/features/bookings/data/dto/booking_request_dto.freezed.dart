// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingRequestDto _$BookingRequestDtoFromJson(Map<String, dynamic> json) {
  return _BookingRequestDto.fromJson(json);
}

/// @nodoc
mixin _$BookingRequestDto {
  int get seatsRequested => throw _privateConstructorUsedError;

  /// Serializes this BookingRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingRequestDtoCopyWith<BookingRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingRequestDtoCopyWith<$Res> {
  factory $BookingRequestDtoCopyWith(
          BookingRequestDto value, $Res Function(BookingRequestDto) then) =
      _$BookingRequestDtoCopyWithImpl<$Res, BookingRequestDto>;
  @useResult
  $Res call({int seatsRequested});
}

/// @nodoc
class _$BookingRequestDtoCopyWithImpl<$Res, $Val extends BookingRequestDto>
    implements $BookingRequestDtoCopyWith<$Res> {
  _$BookingRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seatsRequested = null,
  }) {
    return _then(_value.copyWith(
      seatsRequested: null == seatsRequested
          ? _value.seatsRequested
          : seatsRequested // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingRequestDtoImplCopyWith<$Res>
    implements $BookingRequestDtoCopyWith<$Res> {
  factory _$$BookingRequestDtoImplCopyWith(_$BookingRequestDtoImpl value,
          $Res Function(_$BookingRequestDtoImpl) then) =
      __$$BookingRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int seatsRequested});
}

/// @nodoc
class __$$BookingRequestDtoImplCopyWithImpl<$Res>
    extends _$BookingRequestDtoCopyWithImpl<$Res, _$BookingRequestDtoImpl>
    implements _$$BookingRequestDtoImplCopyWith<$Res> {
  __$$BookingRequestDtoImplCopyWithImpl(_$BookingRequestDtoImpl _value,
      $Res Function(_$BookingRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seatsRequested = null,
  }) {
    return _then(_$BookingRequestDtoImpl(
      seatsRequested: null == seatsRequested
          ? _value.seatsRequested
          : seatsRequested // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingRequestDtoImpl implements _BookingRequestDto {
  const _$BookingRequestDtoImpl({required this.seatsRequested});

  factory _$BookingRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingRequestDtoImplFromJson(json);

  @override
  final int seatsRequested;

  @override
  String toString() {
    return 'BookingRequestDto(seatsRequested: $seatsRequested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingRequestDtoImpl &&
            (identical(other.seatsRequested, seatsRequested) ||
                other.seatsRequested == seatsRequested));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, seatsRequested);

  /// Create a copy of BookingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingRequestDtoImplCopyWith<_$BookingRequestDtoImpl> get copyWith =>
      __$$BookingRequestDtoImplCopyWithImpl<_$BookingRequestDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _BookingRequestDto implements BookingRequestDto {
  const factory _BookingRequestDto({required final int seatsRequested}) =
      _$BookingRequestDtoImpl;

  factory _BookingRequestDto.fromJson(Map<String, dynamic> json) =
      _$BookingRequestDtoImpl.fromJson;

  @override
  int get seatsRequested;

  /// Create a copy of BookingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingRequestDtoImplCopyWith<_$BookingRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
