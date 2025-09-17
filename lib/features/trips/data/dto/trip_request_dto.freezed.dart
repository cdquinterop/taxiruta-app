// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripRequestDto _$TripRequestDtoFromJson(Map<String, dynamic> json) {
  return _TripRequestDto.fromJson(json);
}

/// @nodoc
mixin _$TripRequestDto {
  String get origin => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;
  double get pricePerSeat => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this TripRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripRequestDtoCopyWith<TripRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripRequestDtoCopyWith<$Res> {
  factory $TripRequestDtoCopyWith(
          TripRequestDto value, $Res Function(TripRequestDto) then) =
      _$TripRequestDtoCopyWithImpl<$Res, TripRequestDto>;
  @useResult
  $Res call(
      {String origin,
      String destination,
      DateTime departureTime,
      int availableSeats,
      double pricePerSeat,
      String? description});
}

/// @nodoc
class _$TripRequestDtoCopyWithImpl<$Res, $Val extends TripRequestDto>
    implements $TripRequestDtoCopyWith<$Res> {
  _$TripRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? origin = null,
    Object? destination = null,
    Object? departureTime = null,
    Object? availableSeats = null,
    Object? pricePerSeat = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      origin: null == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSeats: null == availableSeats
          ? _value.availableSeats
          : availableSeats // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripRequestDtoImplCopyWith<$Res>
    implements $TripRequestDtoCopyWith<$Res> {
  factory _$$TripRequestDtoImplCopyWith(_$TripRequestDtoImpl value,
          $Res Function(_$TripRequestDtoImpl) then) =
      __$$TripRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String origin,
      String destination,
      DateTime departureTime,
      int availableSeats,
      double pricePerSeat,
      String? description});
}

/// @nodoc
class __$$TripRequestDtoImplCopyWithImpl<$Res>
    extends _$TripRequestDtoCopyWithImpl<$Res, _$TripRequestDtoImpl>
    implements _$$TripRequestDtoImplCopyWith<$Res> {
  __$$TripRequestDtoImplCopyWithImpl(
      _$TripRequestDtoImpl _value, $Res Function(_$TripRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? origin = null,
    Object? destination = null,
    Object? departureTime = null,
    Object? availableSeats = null,
    Object? pricePerSeat = null,
    Object? description = freezed,
  }) {
    return _then(_$TripRequestDtoImpl(
      origin: null == origin
          ? _value.origin
          : origin // ignore: cast_nullable_to_non_nullable
              as String,
      destination: null == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableSeats: null == availableSeats
          ? _value.availableSeats
          : availableSeats // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripRequestDtoImpl implements _TripRequestDto {
  const _$TripRequestDtoImpl(
      {required this.origin,
      required this.destination,
      required this.departureTime,
      required this.availableSeats,
      required this.pricePerSeat,
      this.description});

  factory _$TripRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripRequestDtoImplFromJson(json);

  @override
  final String origin;
  @override
  final String destination;
  @override
  final DateTime departureTime;
  @override
  final int availableSeats;
  @override
  final double pricePerSeat;
  @override
  final String? description;

  @override
  String toString() {
    return 'TripRequestDto(origin: $origin, destination: $destination, departureTime: $departureTime, availableSeats: $availableSeats, pricePerSeat: $pricePerSeat, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripRequestDtoImpl &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, origin, destination,
      departureTime, availableSeats, pricePerSeat, description);

  /// Create a copy of TripRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripRequestDtoImplCopyWith<_$TripRequestDtoImpl> get copyWith =>
      __$$TripRequestDtoImplCopyWithImpl<_$TripRequestDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _TripRequestDto implements TripRequestDto {
  const factory _TripRequestDto(
      {required final String origin,
      required final String destination,
      required final DateTime departureTime,
      required final int availableSeats,
      required final double pricePerSeat,
      final String? description}) = _$TripRequestDtoImpl;

  factory _TripRequestDto.fromJson(Map<String, dynamic> json) =
      _$TripRequestDtoImpl.fromJson;

  @override
  String get origin;
  @override
  String get destination;
  @override
  DateTime get departureTime;
  @override
  int get availableSeats;
  @override
  double get pricePerSeat;
  @override
  String? get description;

  /// Create a copy of TripRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripRequestDtoImplCopyWith<_$TripRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
