import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';
import '../../shared/constants/app_constants.dart';

/// Cliente HTTP configurado para la aplicación TaxiRuta
class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  
  /// Getter para acceder al Dio configurado
  Dio get dio => _dio;

  ApiClient({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor para logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ));

    // Interceptor para autenticación
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: AppConstants.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expirado, intentar refresh
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Reintentar la petición original
            final options = error.requestOptions;
            final token = await _secureStorage.read(key: AppConstants.tokenKey);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            try {
              final response = await _dio.fetch(options);
              handler.resolve(response);
              return;
            } catch (e) {
              // Si falla el reintento, continuar con el error original
            }
          }
        }
        handler.next(error);
      },
    ));
  }

  /// Realizar petición GET
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Realizar petición POST
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Realizar petición PUT
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Realizar petición DELETE
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Actualizar token de autenticación
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _dio.post(
        '${AppConstants.authEndpoint}/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newToken != null) {
          await _secureStorage.write(
            key: AppConstants.tokenKey,
            value: newToken,
          );
        }

        if (newRefreshToken != null) {
          await _secureStorage.write(
            key: AppConstants.refreshTokenKey,
            value: newRefreshToken,
          );
        }

        return true;
      }
    } catch (e) {
      // Error al refrescar token
    }

    return false;
  }

  /// Manejar excepciones de Dio
  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Tiempo de espera agotado');
      
      case DioExceptionType.connectionError:
        return const NetworkException('Error de conexión');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        
        switch (statusCode) {
          case 400:
            return ValidationException(
              data?['message'] ?? 'Datos inválidos',
              fieldErrors: _extractFieldErrors(data),
            );
          case 401:
            return const AuthException('No autorizado');
          case 403:
            return const AuthorizationException('Acceso denegado');
          case 404:
            return const NotFoundException('Recurso no encontrado');
          case 500:
            return const ServerException('Error interno del servidor', 500);
          default:
            return ServerException(
              data?['message'] ?? 'Error del servidor',
              statusCode,
            );
        }
      
      case DioExceptionType.cancel:
        return const GenericException('Petición cancelada');
      
      case DioExceptionType.unknown:
      default:
        return GenericException(e.message ?? 'Error desconocido');
    }
  }

  /// Extraer errores de campo de la respuesta del servidor
  Map<String, List<String>>? _extractFieldErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.cast<String>());
          } else if (value is String) {
            return MapEntry(key, [value]);
          }
          return MapEntry(key, ['Error de validación']);
        });
      }
    }
    return null;
  }

  /// Limpiar tokens almacenados
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }
}