// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripModel _$TripModelFromJson(Map<String, dynamic> json) {
  return _TripModel.fromJson(json);
}

/// @nodoc
mixin _$TripModel {
  int get id => throw _privateConstructorUsedError;
  UserModel get driver => throw _privateConstructorUsedError;
  String get origin => throw _privateConstructorUsedError;
  String get destination => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;
  int get remainingSeats => throw _privateConstructorUsedError;
  int? get realAvailableSeats =>
      throw _privateConstructorUsedError; // Asientos disponibles considerando reservas pendientes
  double get pricePerSeat => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<BookingModel>? get bookings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TripModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripModelCopyWith<TripModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripModelCopyWith<$Res> {
  factory $TripModelCopyWith(TripModel value, $Res Function(TripModel) then) =
      _$TripModelCopyWithImpl<$Res, TripModel>;
  @useResult
  $Res call(
      {int id,
      UserModel driver,
      String origin,
      String destination,
      DateTime departureTime,
      int availableSeats,
      int remainingSeats,
      int? realAvailableSeats,
      double pricePerSeat,
      String? description,
      String status,
      List<BookingModel>? bookings,
      DateTime createdAt,
      DateTime? updatedAt});

  $UserModelCopyWith<$Res> get driver;
}

/// @nodoc
class _$TripModelCopyWithImpl<$Res, $Val extends TripModel>
    implements $TripModelCopyWith<$Res> {
  _$TripModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driver = null,
    Object? origin = null,
    Object? destination = null,
    Object? departureTime = null,
    Object? availableSeats = null,
    Object? remainingSeats = null,
    Object? realAvailableSeats = freezed,
    Object? pricePerSeat = null,
    Object? description = freezed,
    Object? status = null,
    Object? bookings = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      driver: null == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as UserModel,
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
      remainingSeats: null == remainingSeats
          ? _value.remainingSeats
          : remainingSeats // ignore: cast_nullable_to_non_nullable
              as int,
      realAvailableSeats: freezed == realAvailableSeats
          ? _value.realAvailableSeats
          : realAvailableSeats // ignore: cast_nullable_to_non_nullable
              as int?,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookings: freezed == bookings
          ? _value.bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<BookingModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get driver {
    return $UserModelCopyWith<$Res>(_value.driver, (value) {
      return _then(_value.copyWith(driver: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripModelImplCopyWith<$Res>
    implements $TripModelCopyWith<$Res> {
  factory _$$TripModelImplCopyWith(
          _$TripModelImpl value, $Res Function(_$TripModelImpl) then) =
      __$$TripModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      UserModel driver,
      String origin,
      String destination,
      DateTime departureTime,
      int availableSeats,
      int remainingSeats,
      int? realAvailableSeats,
      double pricePerSeat,
      String? description,
      String status,
      List<BookingModel>? bookings,
      DateTime createdAt,
      DateTime? updatedAt});

  @override
  $UserModelCopyWith<$Res> get driver;
}

/// @nodoc
class __$$TripModelImplCopyWithImpl<$Res>
    extends _$TripModelCopyWithImpl<$Res, _$TripModelImpl>
    implements _$$TripModelImplCopyWith<$Res> {
  __$$TripModelImplCopyWithImpl(
      _$TripModelImpl _value, $Res Function(_$TripModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? driver = null,
    Object? origin = null,
    Object? destination = null,
    Object? departureTime = null,
    Object? availableSeats = null,
    Object? remainingSeats = null,
    Object? realAvailableSeats = freezed,
    Object? pricePerSeat = null,
    Object? description = freezed,
    Object? status = null,
    Object? bookings = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TripModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      driver: null == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as UserModel,
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
      remainingSeats: null == remainingSeats
          ? _value.remainingSeats
          : remainingSeats // ignore: cast_nullable_to_non_nullable
              as int,
      realAvailableSeats: freezed == realAvailableSeats
          ? _value.realAvailableSeats
          : realAvailableSeats // ignore: cast_nullable_to_non_nullable
              as int?,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      bookings: freezed == bookings
          ? _value._bookings
          : bookings // ignore: cast_nullable_to_non_nullable
              as List<BookingModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripModelImpl implements _TripModel {
  const _$TripModelImpl(
      {required this.id,
      required this.driver,
      required this.origin,
      required this.destination,
      required this.departureTime,
      required this.availableSeats,
      required this.remainingSeats,
      this.realAvailableSeats,
      required this.pricePerSeat,
      this.description,
      required this.status,
      final List<BookingModel>? bookings,
      required this.createdAt,
      this.updatedAt})
      : _bookings = bookings;

  factory _$TripModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripModelImplFromJson(json);

  @override
  final int id;
  @override
  final UserModel driver;
  @override
  final String origin;
  @override
  final String destination;
  @override
  final DateTime departureTime;
  @override
  final int availableSeats;
  @override
  final int remainingSeats;
  @override
  final int? realAvailableSeats;
// Asientos disponibles considerando reservas pendientes
  @override
  final double pricePerSeat;
  @override
  final String? description;
  @override
  final String status;
  final List<BookingModel>? _bookings;
  @override
  List<BookingModel>? get bookings {
    final value = _bookings;
    if (value == null) return null;
    if (_bookings is EqualUnmodifiableListView) return _bookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TripModel(id: $id, driver: $driver, origin: $origin, destination: $destination, departureTime: $departureTime, availableSeats: $availableSeats, remainingSeats: $remainingSeats, realAvailableSeats: $realAvailableSeats, pricePerSeat: $pricePerSeat, description: $description, status: $status, bookings: $bookings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats) &&
            (identical(other.remainingSeats, remainingSeats) ||
                other.remainingSeats == remainingSeats) &&
            (identical(other.realAvailableSeats, realAvailableSeats) ||
                other.realAvailableSeats == realAvailableSeats) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._bookings, _bookings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      driver,
      origin,
      destination,
      departureTime,
      availableSeats,
      remainingSeats,
      realAvailableSeats,
      pricePerSeat,
      description,
      status,
      const DeepCollectionEquality().hash(_bookings),
      createdAt,
      updatedAt);

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      __$$TripModelImplCopyWithImpl<_$TripModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripModelImplToJson(
      this,
    );
  }
}

abstract class _TripModel implements TripModel {
  const factory _TripModel(
      {required final int id,
      required final UserModel driver,
      required final String origin,
      required final String destination,
      required final DateTime departureTime,
      required final int availableSeats,
      required final int remainingSeats,
      final int? realAvailableSeats,
      required final double pricePerSeat,
      final String? description,
      required final String status,
      final List<BookingModel>? bookings,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$TripModelImpl;

  factory _TripModel.fromJson(Map<String, dynamic> json) =
      _$TripModelImpl.fromJson;

  @override
  int get id;
  @override
  UserModel get driver;
  @override
  String get origin;
  @override
  String get destination;
  @override
  DateTime get departureTime;
  @override
  int get availableSeats;
  @override
  int get remainingSeats;
  @override
  int?
      get realAvailableSeats; // Asientos disponibles considerando reservas pendientes
  @override
  double get pricePerSeat;
  @override
  String? get description;
  @override
  String get status;
  @override
  List<BookingModel>? get bookings;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
