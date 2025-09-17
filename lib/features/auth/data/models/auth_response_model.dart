import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Modelo de respuesta para login y registro
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required bool success,
    required String message,
    required AuthDataModel data,
    required String timestamp,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

/// Modelo para el campo 'data' dentro de AuthResponseModel
@freezed
class AuthDataModel with _$AuthDataModel {
  const factory AuthDataModel({
    required String token,
    required String type,
    required UserModel user,
  }) = _AuthDataModel;

  factory AuthDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDataModelFromJson(json);
}

/// Modelo para solicitud de registro
@freezed
class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  }) = _RegisterRequestModel;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);
}

/// Modelo para solicitud de login
@freezed
class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    required String usernameOrEmail,
    required String password,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}