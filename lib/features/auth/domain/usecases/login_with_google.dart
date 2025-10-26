import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para iniciar sesión con Google
class LoginWithGoogle {
  final AuthRepository _repository;

  LoginWithGoogle(this._repository);

  Future<Result<User>> call() async {
    return await _repository.loginWithGoogle();
  }
}
