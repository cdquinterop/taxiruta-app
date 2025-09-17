// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestDtoImpl _$$RegisterRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestDtoImpl(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      role: json['role'] as String? ?? 'PASSENGER',
    );

Map<String, dynamic> _$$RegisterRequestDtoImplToJson(
        _$RegisterRequestDtoImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'role': instance.role,
    };
