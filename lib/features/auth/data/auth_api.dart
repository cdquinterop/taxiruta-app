import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/constants/app_constants.dart';
import 'models/auth_response_model.dart';
import 'models/user_model.dart';

/// API service para autenticación
class AuthApi {
  final ApiClient _apiClient;

  AuthApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Registrar nuevo usuario
  /// POST /api/auth/register
  Future<AuthResponseModel> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  }) async {
    final requestData = {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
      'phone': phone,
    };

    final response = await _apiClient.post(
      '${AppConstants.authEndpoint}/register',
      data: requestData,
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Iniciar sesión
  /// POST /api/auth/login
  Future<AuthResponseModel> loginUser({
    required String email,
    required String password,
  }) async {
    final requestData = {
      'usernameOrEmail': email,
      'password': password,
    };

    final response = await _apiClient.post(
      '${AppConstants.authEndpoint}/login',
      data: requestData,
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Refrescar token de acceso
  /// POST /api/auth/refresh
  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    final requestData = {
      'refresh_token': refreshToken,
    };

    final response = await _apiClient.post(
      '${AppConstants.authEndpoint}/refresh',
      data: requestData,
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Cerrar sesión
  /// POST /api/auth/logout
  Future<void> logout() async {
    await _apiClient.post('${AppConstants.authEndpoint}/logout');
  }
}