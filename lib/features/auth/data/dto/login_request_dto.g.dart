// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestDtoImpl _$$LoginRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginRequestDtoImpl(
      usernameOrEmail: json['usernameOrEmail'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestDtoImplToJson(
        _$LoginRequestDtoImpl instance) =>
    <String, dynamic>{
      'usernameOrEmail': instance.usernameOrEmail,
      'password': instance.password,
    };
