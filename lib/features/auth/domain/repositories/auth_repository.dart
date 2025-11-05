import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Resultado de operación que puede fallar
typedef Result<T> = ({T? data, Failure? failure});

/// Repositorio abstracto para autenticación
abstract class AuthRepository {
  /// Limpiar datos de sesión
  Future<void> clearSession();

  /// Obtener usuario actual
  Future<User?> getCurrentUser();

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated();

  /// Iniciar sesión
  Future<Result<User>> loginUser({
    required String email,
    required String password,
    bool rememberMe = true,
  });

  /// Iniciar sesión con Google
  Future<Result<User>> loginWithGoogle();

  /// Cerrar sesión
  Future<Result<void>> logout();

  /// Registrar nuevo usuario
  Future<Result<User>> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  });

  /// Registrarse con Google (permite especificar rol)
  Future<Result<User>> registerWithGoogle({required String role});
}
