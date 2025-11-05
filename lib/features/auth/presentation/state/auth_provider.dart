import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../shared/constants/app_constants.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart' as domain;

/// Provider principal de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthNotifier(authRepository, secureStorage);
});

/// Provider para el repositorio de autenticación
final authRepositoryProvider = Provider<domain.AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dio: ref.read(dioProvider),
    storage: ref.read(secureStorageProvider),
  );
});

/// Provider para Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = AppConstants.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 30);
  return dio;
});

/// Provider para verificar si el usuario es conductor
final isDriverProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.role.toUpperCase() == 'DRIVER';
});

/// Provider para verificar si el usuario es pasajero
final isPassengerProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.role.toUpperCase() == 'PASSENGER';
});

/// Provider para el secure storage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Notifier para el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final domain.AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;

  AuthNotifier(this._authRepository, this._secureStorage)
      : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Login del usuario
  Future<void> login(String email, String password, {bool rememberMe = true}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.loginUser(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      if (result.failure != null) {
        print('❌ AUTH_PROVIDER: Error de login: ${result.failure!.message}');
        state = state.copyWith(
          error: result.failure!.message,
          isLoading: false,
        );
        return;
      }

      if (result.data != null) {
        // El token ya fue guardado en el repositorio
        // Guardar información del usuario
        final user = result.data!;
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print(
            '✅ AUTH_PROVIDER: Estado actualizado - usuario autenticado: ${user.fullName}');
      } else {
        print('❌ AUTH_PROVIDER: No se recibieron datos del usuario');
        state = state.copyWith(
          error: 'No se recibieron datos del usuario',
          isLoading: false,
        );
      }
    } catch (e) {
      print('❌ AUTH_PROVIDER: Error inesperado en login: $e');
      state = state.copyWith(
        error: 'Error inesperado durante el login: $e',
        isLoading: false,
      );
    }
  }

  /// Login con Google
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.loginWithGoogle();

      if (result.failure != null) {
        print(
            '❌ AUTH_PROVIDER (Google): Error de login: ${result.failure!.message}');
        state = state.copyWith(
          error: result.failure!.message,
          isLoading: false,
        );
        return;
      }

      if (result.data != null) {
        // El token ya fue guardado en el repositorio
        // Guardar información del usuario
        final user = result.data!;
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print(
            '✅ AUTH_PROVIDER (Google): Estado actualizado - usuario autenticado: ${user.fullName}');
      } else {
        print('❌ AUTH_PROVIDER (Google): No se recibieron datos del usuario');
        state = state.copyWith(
          error: 'No se recibieron datos del usuario',
          isLoading: false,
        );
      }
    } catch (e) {
      print('❌ AUTH_PROVIDER (Google): Error inesperado en login: $e');
      state = state.copyWith(
        error: 'Error inesperado durante el login con Google: $e',
        isLoading: false,
      );
    }
  }

  /// Logout del usuario (limpia completamente la sesión)
  Future<void> logout() async {
    print('👤 AUTH: Logout explícito del usuario');
    await _logout(clearRememberMe: true);
  }

  /// Limpia solo sesión temporal (mantiene preferencias)
  Future<void> clearTemporarySession() async {
    print('🔄 AUTH: Limpiando sesión temporal');
    await _logout(clearRememberMe: false);
  }

  /// Actualizar perfil del usuario
  Future<void> refreshProfile() async {
    if (!state.isAuthenticated) return;

    try {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      // Si falla, probablemente el token expiró
      await _logout(clearRememberMe: false);
    }
  }

  /// Registro del usuario
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String role = 'PASSENGER',
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.registerUser(
        name: '$firstName $lastName',
        email: email,
        phone: phone,
        password: password,
        role: role,
      );

      if (result.failure != null) {
        print('❌ AUTH_PROVIDER: Error de registro: ${result.failure!.message}');
        state = state.copyWith(
          error: result.failure!.message,
          isLoading: false,
        );
        return;
      }

      if (result.data != null) {
        // El token ya fue guardado en el repositorio
        // Guardar información del usuario
        final user = result.data!;
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print(
            '✅ AUTH_PROVIDER: Registro exitoso - usuario autenticado: ${user.fullName}');
      } else {
        print(
            '❌ AUTH_PROVIDER: No se recibieron datos del usuario en registro');
        state = state.copyWith(
          error: 'No se recibieron datos del usuario',
          isLoading: false,
        );
      }
    } catch (e) {
      print('❌ AUTH_PROVIDER: Error inesperado en registro: $e');
      state = state.copyWith(
        error: 'Error inesperado durante registro: $e',
        isLoading: false,
      );
    }
  }

  /// Registro con Google (permite especificar el rol)
  Future<void> registerWithGoogle({required String role}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.registerWithGoogle(role: role);

      if (result.failure != null) {
        print(
            '❌ AUTH_PROVIDER (Google Register): Error de registro: ${result.failure!.message}');
        state = state.copyWith(
          error: result.failure!.message,
          isLoading: false,
        );
        return;
      }

      if (result.data != null) {
        // El token ya fue guardado en el repositorio
        // Guardar información del usuario
        final user = result.data!;
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
        print(
            '✅ AUTH_PROVIDER (Google Register): Estado actualizado - usuario registrado: ${user.fullName} como ${user.role}');
      } else {
        print(
            '❌ AUTH_PROVIDER (Google Register): No se recibieron datos del usuario');
        state = state.copyWith(
          error: 'No se recibieron datos del usuario',
          isLoading: false,
        );
      }
    } catch (e) {
      print('❌ AUTH_PROVIDER (Google Register): Error inesperado: $e');
      state = state.copyWith(
        error: 'Error inesperado durante el registro con Google: $e',
        isLoading: false,
      );
    }
  }

  /// Verificar si el usuario está autenticado al iniciar la app
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await _secureStorage.read(key: AppConstants.tokenKey);
      final rememberMe = await _secureStorage.read(key: AppConstants.rememberMeKey);
      
      print('🔍 AUTH: Checking auth status - Token exists: ${token != null}, RememberMe: $rememberMe');
      
      if (token != null && token.isNotEmpty) {
        try {
          final user = await _authRepository.getCurrentUser();
          if (user != null) {
            state = state.copyWith(
              user: user,
              isAuthenticated: true,
              isLoading: false,
            );
            print('✅ AUTH: Usuario autenticado restaurado: ${user.fullName}');
            print('ℹ️ AUTH: RememberMe setting: $rememberMe');
          } else {
            print('❌ AUTH: No se pudo obtener el usuario, limpiando sesión');
            await _logout(clearRememberMe: false);
          }
        } catch (e) {
          print('❌ AUTH: Token inválido o expirado, limpiando sesión: $e');
          await _logout(clearRememberMe: false);
        }
      } else {
        print('ℹ️ AUTH: No hay token guardado');
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      print('❌ AUTH: Error verificando autenticación: $e');
      // En caso de error, limpiar estado pero no la sesión almacenada
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  Future<void> _logout({bool clearRememberMe = true}) async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.userDataKey);
    
    // Solo limpiar rememberMe si se especifica (logout explícito del usuario)
    if (clearRememberMe) {
      await _secureStorage.delete(key: AppConstants.rememberMeKey);
      print('🗑️ AUTH: Logout completo - preferencias limpiadas');
    } else {
      print('🔄 AUTH: Logout temporal - manteniendo preferencias');
    }

    state = const AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }
}

/// Estado de autenticación
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
