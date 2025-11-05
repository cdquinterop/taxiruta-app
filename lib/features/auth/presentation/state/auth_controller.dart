import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';

/// Estado de autenticación
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Estado del controlador de autenticación
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final Map<String, List<String>>? fieldErrors;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.fieldErrors,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors,
    );
  }

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => status == AuthStatus.error;
}

/// Controlador de autenticación
class AuthController extends StateNotifier<AuthState> {
  final RegisterUser _registerUser;
  final LoginUser _loginUser;
  final LoginWithGoogle _loginWithGoogle;
  final LogoutUser _logoutUser;
  final AuthRepository _repository;

  AuthController({
    required RegisterUser registerUser,
    required LoginUser loginUser,
    required LoginWithGoogle loginWithGoogle,
    required LogoutUser logoutUser,
    required AuthRepository repository,
  })  : _registerUser = registerUser,
        _loginUser = loginUser,
        _loginWithGoogle = loginWithGoogle,
        _logoutUser = logoutUser,
        _repository = repository,
        super(const AuthState());

  /// Inicializar el estado de autenticación
  Future<void> initialize() async {
    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
        return;
      }
    }
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  /// Registrar usuario
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _registerUser.call(
      email: email,
      password: password,
      name: name,
      role: role,
      phone: phone,
    );

    if (result.data != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.data,
        errorMessage: null,
        fieldErrors: null,
      );
    } else if (result.failure != null) {
      _handleFailure(result.failure!);
    }
  }

  /// Iniciar sesión
  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('🎯 AUTH_CONTROLLER: Iniciando login para: $email');
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginUser.call(
      email: email,
      password: password,
    );

    print('🎯 AUTH_CONTROLLER: Resultado del login:');
    print('   - Data: ${result.data}');
    print('   - Failure: ${result.failure}');

    if (result.data != null) {
      print('✅ AUTH_CONTROLLER: Login exitoso, actualizando estado');
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.data,
        errorMessage: null,
        fieldErrors: null,
      );
    } else if (result.failure != null) {
      print('❌ AUTH_CONTROLLER: Login falló, manejando error');
      _handleFailure(result.failure!);
    }
  }

  /// Iniciar sesión con Google
  Future<void> loginWithGoogle() async {
    print('🎯 AUTH_CONTROLLER: Iniciando login con Google');
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginWithGoogle.call();

    print('🎯 AUTH_CONTROLLER: Resultado del login con Google:');
    print('   - Data: ${result.data}');
    print('   - Failure: ${result.failure}');

    if (result.data != null) {
      print('✅ AUTH_CONTROLLER: Login con Google exitoso');
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.data,
        errorMessage: null,
        fieldErrors: null,
      );
    } else if (result.failure != null) {
      print('❌ AUTH_CONTROLLER: Login con Google falló');
      _handleFailure(result.failure!);
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUser.call();

    if (result.failure == null) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
        fieldErrors: null,
      );
    } else {
      _handleFailure(result.failure!);
    }
  }

  /// Limpiar errores
  void clearErrors() {
    state = state.copyWith(
      errorMessage: null,
      fieldErrors: null,
    );
  }

  /// Manejar fallos
  void _handleFailure(Failure failure) {
    print('🚨 AUTH_CONTROLLER: Manejando fallo:');
    print('   - Tipo: ${failure.runtimeType}');
    print('   - Mensaje: ${failure.message}');

    if (failure is ValidationFailure) {
      print('   - Errores de campo: ${failure.fieldErrors}');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
        fieldErrors: failure.fieldErrors,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
        fieldErrors: null,
      );
    }

    print(
        '🚨 AUTH_CONTROLLER: Estado actualizado con error: ${state.errorMessage}');
  }
}

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ApiClient();
  return AuthRepositoryImpl(
    dio: apiClient.dio, // Usar el Dio configurado del ApiClient
    storage: const FlutterSecureStorage(),
  );
});

/// Provider de los casos de uso
final registerUserProvider = Provider<RegisterUser>((ref) {
  return RegisterUser(ref.read(authRepositoryProvider));
});

final loginUserProvider = Provider<LoginUser>((ref) {
  return LoginUser(ref.read(authRepositoryProvider));
});

final loginWithGoogleProvider = Provider<LoginWithGoogle>((ref) {
  return LoginWithGoogle(ref.read(authRepositoryProvider));
});

final logoutUserProvider = Provider<LogoutUser>((ref) {
  return LogoutUser(ref.read(authRepositoryProvider));
});

/// Provider del controlador de autenticación
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    registerUser: ref.read(registerUserProvider),
    loginUser: ref.read(loginUserProvider),
    loginWithGoogle: ref.read(loginWithGoogleProvider),
    logoutUser: ref.read(logoutUserProvider),
    repository: ref.read(authRepositoryProvider),
  );
});

/// Provider para verificar si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.isAuthenticated;
});

/// Provider del usuario actual
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.user;
});
