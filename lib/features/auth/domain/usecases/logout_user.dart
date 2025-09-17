import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para cerrar sesión
class LogoutUser {
  final AuthRepository _repository;

  LogoutUser(this._repository);

  Future<Result<void>> call() async {
    return await _repository.logout();
  }
}