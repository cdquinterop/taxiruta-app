import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl({
    required Dio dio,
    required FlutterSecureStorage storage,
  }) : _dio = dio, _storage = storage;

  @override
  Future<Result<User>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 LOGIN: Iniciando login para email: $email');
      
      final requestData = {
        'usernameOrEmail': email,
        'password': password,
      };
      print('📤 LOGIN: Enviando datos: $requestData');
      
      final fullUrl = '${AppConstants.baseUrl}${AppConstants.authEndpoint}/login';
      print('🌐 LOGIN: URL completa: $fullUrl');
      
      final response = await _dio.post('${AppConstants.authEndpoint}/login', data: requestData);
      
      print('✅ LOGIN: Respuesta recibida - Status: ${response.statusCode}');
      print('📥 LOGIN: Datos de respuesta: ${response.data}');
      
      // Extraer datos de la nueva estructura de respuesta
      final responseData = response.data;
      print('🔍 LOGIN: Estructura de responseData: ${responseData.runtimeType}');
      print('🔍 LOGIN: Keys disponibles: ${responseData.keys.toList()}');
      
      if (responseData['data'] == null) {
        print('❌ LOGIN: ERROR - Campo "data" es null');
        return (data: null, failure: const ServerFailure('Estructura de respuesta inválida', 500));
      }
      
      final dataSection = responseData['data'];
      print('🔍 LOGIN: Estructura de data: ${dataSection.runtimeType}');
      print('🔍 LOGIN: Keys en data: ${dataSection.keys.toList()}');
      
      if (dataSection['user'] == null) {
        print('❌ LOGIN: ERROR - Campo "user" es null en data');
        return (data: null, failure: const ServerFailure('Datos de usuario no encontrados', 500));
      }
      
      final userData = dataSection['user'];
      print('🔍 LOGIN: Datos del usuario: $userData');
      
      try {
        // Dividir fullName en firstName y lastName
        final fullName = userData['fullName'] ?? '';
        final nameParts = fullName.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        
        final user = User(
          id: userData['id'] as int,
          firstName: firstName,
          lastName: lastName,
          email: userData['email'] as String? ?? '',
          phone: userData['phoneNumber'] as String? ?? '',
          role: userData['role'] as String? ?? 'PASSENGER',
          active: (userData['active'] as bool?) ?? true,
          createdAt: userData['createdAt'] != null 
              ? DateTime.parse(userData['createdAt'] as String) 
              : null,
          updatedAt: userData['updatedAt'] != null 
              ? DateTime.parse(userData['updatedAt'] as String) 
              : null,
        );
        
        print('✅ LOGIN: Usuario creado exitosamente: ${user.fullName}');
        
        // Guardar token de la nueva estructura
        final token = dataSection['token'];
        if (token != null) {
          await _storage.write(key: 'access_token', value: token);
          print('✅ LOGIN: Token guardado exitosamente');
        } else {
          print('⚠️ LOGIN: ADVERTENCIA - No se encontró token en la respuesta');
        }
        
        return (data: user, failure: null);
      } catch (userCreationError) {
        print('❌ LOGIN: Error creando usuario: $userCreationError');
        return (data: null, failure: GenericFailure('Error procesando datos de usuario: $userCreationError'));
      }
    } on DioException catch (e) {
      print('❌ LOGIN: DioException capturada');
      print('📊 LOGIN: Tipo de error: ${e.type}');
      print('📊 LOGIN: Status Code: ${e.response?.statusCode}');
      print('📊 LOGIN: Response Data: ${e.response?.data}');
      print('📊 LOGIN: Error Message: ${e.message}');
      print('📊 LOGIN: Request Options: ${e.requestOptions.uri}');
      print('📊 LOGIN: Headers: ${e.requestOptions.headers}');
      
      late Failure failure;
      if (e.response?.statusCode == 401) {
        failure = const AuthFailure('Credenciales inválidas');
      } else {
        failure = ServerFailure('Error del servidor: ${e.response?.statusCode ?? 'Sin código'} - ${e.message}', e.response?.statusCode ?? 0);
      }
      return (data: null, failure: failure);
    } catch (e) {
      print('❌ LOGIN: Error inesperado: $e');
      return (data: null, failure: GenericFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Result<User>> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  }) async {
    try {
      final response = await _dio.post('${AppConstants.authEndpoint}/register', data: {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        'phone': phone,
      });
      
      // Extraer datos de la nueva estructura de respuesta para registro
      final responseData = response.data;
      final userData = responseData['data']['user'];
      
      // Dividir fullName en firstName y lastName
      final fullName = userData['fullName'] ?? '';
      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      final user = User(
        id: userData['id'] as int,
        firstName: firstName,
        lastName: lastName,
        email: userData['email'] as String? ?? '',
        phone: userData['phoneNumber'] as String? ?? '',
        role: userData['role'] as String? ?? 'PASSENGER',
        active: (userData['active'] as bool?) ?? true,
        createdAt: userData['createdAt'] != null 
            ? DateTime.parse(userData['createdAt'] as String) 
            : null,
        updatedAt: userData['updatedAt'] != null 
            ? DateTime.parse(userData['updatedAt'] as String) 
            : null,
      );
      
      return (data: user, failure: null);
    } on DioException catch (e) {
      late Failure failure;
      if (e.response?.statusCode == 409) {
        failure = const AuthFailure('El usuario ya existe');
      } else {
        failure = ServerFailure('Error del servidor', e.response?.statusCode ?? 0);
      }
      return (data: null, failure: failure);
    } catch (e) {
      return (data: null, failure: GenericFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await clearSession();
      return (data: null, failure: null);
    } catch (e) {
      return (data: null, failure: GenericFailure('Error al cerrar sesión: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: 'access_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      if (!await isAuthenticated()) return null;
      
      final response = await _dio.get('${AppConstants.usersEndpoint}/me');
      // Estructura similar para el usuario actual
      final userData = response.data['data']['user'];
      
      // Dividir fullName en firstName y lastName
      final fullName = userData['fullName'] ?? '';
      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      return User(
        id: userData['id'] as int,
        firstName: firstName,
        lastName: lastName,
        email: userData['email'] as String? ?? '',
        phone: userData['phoneNumber'] as String? ?? '',
        role: userData['role'] as String? ?? 'PASSENGER',
        active: (userData['active'] as bool?) ?? true,
        createdAt: userData['createdAt'] != null 
            ? DateTime.parse(userData['createdAt'] as String) 
            : null,
        updatedAt: userData['updatedAt'] != null 
            ? DateTime.parse(userData['updatedAt'] as String) 
            : null,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.deleteAll();
    } catch (e) {
      // Ignorar errores al limpiar
    }
  }
}