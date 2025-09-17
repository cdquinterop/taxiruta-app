import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/auth_repository.dart' as domain;
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../../../shared/constants/app_constants.dart';

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

/// Notifier para el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  final domain.AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;

  AuthNotifier(this._authRepository, this._secureStorage) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Verificar si el usuario está autenticado al iniciar la app
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final token = await _secureStorage.read(key: AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        final user = await _authRepository.getCurrentUser();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      // Token inválido o expirado
      await _logout();
    }
  }

  /// Login del usuario
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _authRepository.loginUser(
        email: email,
        password: password,
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
        print('✅ AUTH_PROVIDER: Estado actualizado - usuario autenticado: ${user.fullName}');
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
        print('✅ AUTH_PROVIDER: Registro exitoso - usuario autenticado: ${user.fullName}');
      } else {
        print('❌ AUTH_PROVIDER: No se recibieron datos del usuario en registro');
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

  /// Logout del usuario
  Future<void> logout() async {
    await _logout();
  }

  Future<void> _logout() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.userDataKey);
    
    state = const AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }

  /// Actualizar perfil del usuario
  Future<void> refreshProfile() async {
    if (!state.isAuthenticated) return;
    
    try {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      // Si falla, probablemente el token expiró
      await _logout();
    }
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para Dio
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = AppConstants.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 30);
  return dio;
});

/// Provider para el repositorio de autenticación
final authRepositoryProvider = Provider<domain.AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dio: ref.read(dioProvider),
    storage: ref.read(secureStorageProvider),
  );
});

/// Provider para el secure storage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider principal de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthNotifier(authRepository, secureStorage);
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