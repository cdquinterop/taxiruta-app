// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterRequestDto _$RegisterRequestDtoFromJson(Map<String, dynamic> json) {
  return _RegisterRequestDto.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequestDto {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestDtoCopyWith<RegisterRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestDtoCopyWith<$Res> {
  factory $RegisterRequestDtoCopyWith(
          RegisterRequestDto value, $Res Function(RegisterRequestDto) then) =
      _$RegisterRequestDtoCopyWithImpl<$Res, RegisterRequestDto>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String role});
}

/// @nodoc
class _$RegisterRequestDtoCopyWithImpl<$Res, $Val extends RegisterRequestDto>
    implements $RegisterRequestDtoCopyWith<$Res> {
  _$RegisterRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = null,
    Object? password = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestDtoImplCopyWith<$Res>
    implements $RegisterRequestDtoCopyWith<$Res> {
  factory _$$RegisterRequestDtoImplCopyWith(_$RegisterRequestDtoImpl value,
          $Res Function(_$RegisterRequestDtoImpl) then) =
      __$$RegisterRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      String email,
      String phone,
      String password,
      String role});
}

/// @nodoc
class __$$RegisterRequestDtoImplCopyWithImpl<$Res>
    extends _$RegisterRequestDtoCopyWithImpl<$Res, _$RegisterRequestDtoImpl>
    implements _$$RegisterRequestDtoImplCopyWith<$Res> {
  __$$RegisterRequestDtoImplCopyWithImpl(_$RegisterRequestDtoImpl _value,
      $Res Function(_$RegisterRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = null,
    Object? password = null,
    Object? role = null,
  }) {
    return _then(_$RegisterRequestDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestDtoImpl implements _RegisterRequestDto {
  const _$RegisterRequestDtoImpl(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.password,
      this.role = 'PASSENGER'});

  factory _$RegisterRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestDtoImplFromJson(json);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String password;
  @override
  @JsonKey()
  final String role;

  @override
  String toString() {
    return 'RegisterRequestDto(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, password: $password, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, firstName, lastName, email, phone, password, role);

  /// Create a copy of RegisterRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestDtoImplCopyWith<_$RegisterRequestDtoImpl> get copyWith =>
      __$$RegisterRequestDtoImplCopyWithImpl<_$RegisterRequestDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequestDto implements RegisterRequestDto {
  const factory _RegisterRequestDto(
      {required final String firstName,
      required final String lastName,
      required final String email,
      required final String phone,
      required final String password,
      final String role}) = _$RegisterRequestDtoImpl;

  factory _RegisterRequestDto.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestDtoImpl.fromJson;

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get password;
  @override
  String get role;

  /// Create a copy of RegisterRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestDtoImplCopyWith<_$RegisterRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
