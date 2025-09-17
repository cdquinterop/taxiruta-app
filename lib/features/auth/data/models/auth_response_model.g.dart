// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseModelImpl _$$AuthResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseModelImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$$AuthResponseModelImplToJson(
        _$AuthResponseModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

_$AuthDataModelImpl _$$AuthDataModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthDataModelImpl(
      token: json['token'] as String,
      type: json['type'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthDataModelImplToJson(_$AuthDataModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'type': instance.type,
      'user': instance.user,
    };

_$RegisterRequestModelImpl _$$RegisterRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestModelImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$$RegisterRequestModelImplToJson(
        _$RegisterRequestModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'role': instance.role,
      'phone': instance.phone,
    };

_$LoginRequestModelImpl _$$LoginRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginRequestModelImpl(
      usernameOrEmail: json['usernameOrEmail'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestModelImplToJson(
        _$LoginRequestModelImpl instance) =>
    <String, dynamic>{
      'usernameOrEmail': instance.usernameOrEmail,
      'password': instance.password,
    };
