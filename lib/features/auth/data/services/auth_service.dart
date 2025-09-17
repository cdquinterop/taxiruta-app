import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Servicio para consumir endpoints de autenticación
class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Login de usuario
  /// POST /api/auth/login
  Future<AuthResponseModel> login(LoginRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return AuthResponseModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Login failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Login failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Credenciales incorrectas', 401);
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Datos de entrada inválidos', 400);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Registro de usuario
  /// POST /api/auth/register
  Future<AuthResponseModel> register(RegisterRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return AuthResponseModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Registration failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Registration failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw ServerException('El usuario ya existe', 409);
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Datos de entrada inválidos', 400);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener perfil del usuario autenticado
  /// GET /api/users/profile
  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/api/users/profile');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return UserModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get profile', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get profile with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('No autorizado', 401);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }
}