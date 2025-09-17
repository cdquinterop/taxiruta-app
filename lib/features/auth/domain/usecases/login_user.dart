import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para iniciar sesión
class LoginUser {
  final AuthRepository _repository;

  LoginUser(this._repository);

  Future<Result<User>> call({
    required String email,
    required String password,
  }) async {
    return await _repository.loginUser(
      email: email,
      password: password,
    );
  }
}