import '../entities/user.dart';
import '../../../../core/error/failures.dart';

/// Resultado de operación que puede fallar
typedef Result<T> = ({T? data, Failure? failure});

/// Repositorio abstracto para autenticación
abstract class AuthRepository {
  /// Registrar nuevo usuario
  Future<Result<User>> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  });

  /// Iniciar sesión
  Future<Result<User>> loginUser({
    required String email,
    required String password,
  });

  /// Cerrar sesión
  Future<Result<void>> logout();

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated();

  /// Obtener usuario actual
  Future<User?> getCurrentUser();

  /// Limpiar datos de sesión
  Future<void> clearSession();
}