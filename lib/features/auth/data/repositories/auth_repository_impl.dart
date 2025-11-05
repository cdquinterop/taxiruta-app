import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/google_sign_in_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final GoogleSignInService _googleSignInService;

  AuthRepositoryImpl({
    required Dio dio,
    required FlutterSecureStorage storage,
    GoogleSignInService? googleSignInService,
  })  : _dio = dio,
        _storage = storage,
        _googleSignInService = googleSignInService ?? GoogleSignInService();

  @override
  Future<void> clearSession() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.deleteAll();
    } catch (e) {
      // Ignorar errores al limpiar
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
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

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
  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: 'access_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

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

      const fullUrl =
          '${AppConstants.baseUrl}${AppConstants.authEndpoint}/login';
      print('🌐 LOGIN: URL completa: $fullUrl');

      final response = await _dio.post('${AppConstants.authEndpoint}/login',
          data: requestData);

      print('✅ LOGIN: Respuesta recibida - Status: ${response.statusCode}');
      print('📥 LOGIN: Datos de respuesta: ${response.data}');

      // Extraer datos de la nueva estructura de respuesta
      final responseData = response.data;
      print(
          '🔍 LOGIN: Estructura de responseData: ${responseData.runtimeType}');
      print('🔍 LOGIN: Keys disponibles: ${responseData.keys.toList()}');

      if (responseData['data'] == null) {
        print('❌ LOGIN: ERROR - Campo "data" es null');
        return (
          data: null,
          failure: const ServerFailure('Estructura de respuesta inválida', 500)
        );
      }

      final dataSection = responseData['data'];
      print('🔍 LOGIN: Estructura de data: ${dataSection.runtimeType}');
      print('🔍 LOGIN: Keys en data: ${dataSection.keys.toList()}');

      if (dataSection['user'] == null) {
        print('❌ LOGIN: ERROR - Campo "user" es null en data');
        return (
          data: null,
          failure: const ServerFailure('Datos de usuario no encontrados', 500)
        );
      }

      final userData = dataSection['user'];
      print('🔍 LOGIN: Datos del usuario: $userData');

      try {
        // Dividir fullName en firstName y lastName
        final fullName = userData['fullName'] ?? '';
        final nameParts = fullName.split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

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
          await _storage.write(key: AppConstants.tokenKey, value: token);
          print(
              '✅ LOGIN: Token guardado exitosamente con clave: ${AppConstants.tokenKey}');
        } else {
          print('⚠️ LOGIN: ADVERTENCIA - No se encontró token en la respuesta');
        }

        return (data: user, failure: null);
      } catch (userCreationError) {
        print('❌ LOGIN: Error creando usuario: $userCreationError');
        return (
          data: null,
          failure: GenericFailure(
              'Error procesando datos de usuario: $userCreationError')
        );
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
        failure = ServerFailure(
            'Error del servidor: ${e.response?.statusCode ?? 'Sin código'} - ${e.message}',
            e.response?.statusCode ?? 0);
      }
      return (data: null, failure: failure);
    } catch (e) {
      print('❌ LOGIN: Error inesperado: $e');
      return (data: null, failure: GenericFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Result<User>> loginWithGoogle() async {
    try {
      print('🔐 GOOGLE_LOGIN: Iniciando login con Google');

      // 1. Autenticar con Google/Firebase
      final googleResult = await _googleSignInService.signInWithGoogle();
      print('✅ GOOGLE_LOGIN: Autenticación con Google exitosa');
      print('📧 GOOGLE_LOGIN: Email: ${googleResult.email}');

      // 2. Enviar el token al backend para validar y crear/obtener usuario
      final requestData = {
        'idToken': googleResult.idToken,
        'email': googleResult.email,
        'displayName': googleResult.displayName,
        'photoUrl': googleResult.photoUrl,
        'provider': 'google',
      };

      print('📤 GOOGLE_LOGIN: Enviando datos al backend');
      const fullUrl =
          '${AppConstants.baseUrl}${AppConstants.authEndpoint}/google-login';
      print('🌐 GOOGLE_LOGIN: URL: $fullUrl');

      final response = await _dio.post(
        '${AppConstants.authEndpoint}/google-login',
        data: requestData,
      );

      print(
          '✅ GOOGLE_LOGIN: Respuesta del backend recibida - Status: ${response.statusCode}');
      print('📥 GOOGLE_LOGIN: Datos de respuesta: ${response.data}');

      // 3. Procesar respuesta del backend (misma estructura que login normal)
      final responseData = response.data;

      if (responseData['data'] == null) {
        print('❌ GOOGLE_LOGIN: ERROR - Campo "data" es null');
        return (
          data: null,
          failure: const ServerFailure('Estructura de respuesta inválida', 500)
        );
      }

      final dataSection = responseData['data'];

      if (dataSection['user'] == null) {
        print('❌ GOOGLE_LOGIN: ERROR - Campo "user" es null');
        return (
          data: null,
          failure: const ServerFailure('Datos de usuario no encontrados', 500)
        );
      }

      final userData = dataSection['user'];

      // Dividir fullName en firstName y lastName
      final fullName = userData['fullName'] ?? googleResult.displayName;
      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final user = User(
        id: userData['id'] as int,
        firstName: firstName,
        lastName: lastName,
        email: userData['email'] as String? ?? googleResult.email,
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

      print('✅ GOOGLE_LOGIN: Usuario creado: ${user.fullName}');

      // 4. Guardar token
      final token = dataSection['token'];
      if (token != null) {
        await _storage.write(key: AppConstants.tokenKey, value: token);
        print('✅ GOOGLE_LOGIN: Token guardado');
      }

      return (data: user, failure: null);
    } on DioException catch (e) {
      print(
          '❌ GOOGLE_LOGIN: DioException: ${e.response?.statusCode} - ${e.message}');
      late Failure failure;
      if (e.response?.statusCode == 401) {
        failure = const AuthFailure('No se pudo validar el token de Google');
      } else {
        failure = ServerFailure(
          'Error del servidor: ${e.response?.statusCode ?? 'Sin código'} - ${e.message}',
          e.response?.statusCode ?? 0,
        );
      }
      return (data: null, failure: failure);
    } catch (e) {
      print('❌ GOOGLE_LOGIN: Error inesperado: $e');
      return (
        data: null,
        failure: GenericFailure('Error al iniciar sesión con Google: $e')
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await clearSession();
      // También cerrar sesión de Google si estaba activo
      await _googleSignInService.signOut();
      return (data: null, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: GenericFailure('Error al cerrar sesión: $e')
      );
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
      final response =
          await _dio.post('${AppConstants.authEndpoint}/register', data: {
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
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

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
        failure =
            ServerFailure('Error del servidor', e.response?.statusCode ?? 0);
      }
      return (data: null, failure: failure);
    } catch (e) {
      return (data: null, failure: GenericFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Result<User>> registerWithGoogle({required String role}) async {
    try {
      print('🔐 GOOGLE_REGISTER: Iniciando registro con Google');
      print('👤 GOOGLE_REGISTER: Rol seleccionado: $role');

      // 1. Autenticar con Google/Firebase
      final googleResult = await _googleSignInService.signInWithGoogle();
      print('✅ GOOGLE_REGISTER: Autenticación con Google exitosa');
      print('📧 GOOGLE_REGISTER: Email: ${googleResult.email}');

      // 2. Enviar el token y el rol al backend
      final requestData = {
        'idToken': googleResult.idToken,
        'email': googleResult.email,
        'displayName': googleResult.displayName,
        'photoUrl': googleResult.photoUrl,
        'provider': 'google',
        'role': role, // IMPORTANTE: Enviamos el rol seleccionado
      };

      print('📤 GOOGLE_REGISTER: Enviando datos al backend con rol: $role');
      const fullUrl =
          '${AppConstants.baseUrl}${AppConstants.authEndpoint}/google-login';
      print('🌐 GOOGLE_REGISTER: URL: $fullUrl');

      final response = await _dio.post(
        '${AppConstants.authEndpoint}/google-login',
        data: requestData,
      );

      print(
          '✅ GOOGLE_REGISTER: Respuesta del backend recibida - Status: ${response.statusCode}');
      print('📥 GOOGLE_REGISTER: Datos de respuesta: ${response.data}');

      // 3. Procesar respuesta del backend
      final responseData = response.data;

      if (responseData['data'] == null) {
        print('❌ GOOGLE_REGISTER: ERROR - Campo "data" es null');
        return (
          data: null,
          failure: const ServerFailure('Estructura de respuesta inválida', 500)
        );
      }

      final dataSection = responseData['data'];

      if (dataSection['user'] == null) {
        print('❌ GOOGLE_REGISTER: ERROR - Campo "user" es null');
        return (
          data: null,
          failure: const ServerFailure('Datos de usuario no encontrados', 500)
        );
      }

      final userData = dataSection['user'];

      // Dividir fullName en firstName y lastName
      final fullName = userData['fullName'] ?? googleResult.displayName;
      final nameParts = fullName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final user = User(
        id: userData['id'] as int,
        firstName: firstName,
        lastName: lastName,
        email: userData['email'] as String? ?? googleResult.email,
        phone: userData['phoneNumber'] as String? ?? '',
        role: userData['role'] as String? ?? role,
        active: (userData['active'] as bool?) ?? true,
        createdAt: userData['createdAt'] != null
            ? DateTime.parse(userData['createdAt'] as String)
            : null,
        updatedAt: userData['updatedAt'] != null
            ? DateTime.parse(userData['updatedAt'] as String)
            : null,
      );

      print(
          '✅ GOOGLE_REGISTER: Usuario registrado: ${user.fullName} como ${user.role}');

      // 4. Guardar token
      final token = dataSection['token'];
      if (token != null) {
        await _storage.write(key: AppConstants.tokenKey, value: token);
        print('✅ GOOGLE_REGISTER: Token guardado');
      }

      return (data: user, failure: null);
    } on DioException catch (e) {
      print(
          '❌ GOOGLE_REGISTER: DioException: ${e.response?.statusCode} - ${e.message}');
      late Failure failure;
      if (e.response?.statusCode == 401) {
        failure = const AuthFailure('No se pudo validar el token de Google');
      } else {
        failure = ServerFailure(
          'Error del servidor: ${e.response?.statusCode ?? 'Sin código'} - ${e.message}',
          e.response?.statusCode ?? 0,
        );
      }
      return (data: null, failure: failure);
    } catch (e) {
      print('❌ GOOGLE_REGISTER: Error inesperado: $e');
      return (
        data: null,
        failure: GenericFailure('Error al registrarse con Google: $e')
      );
    }
  }
}
