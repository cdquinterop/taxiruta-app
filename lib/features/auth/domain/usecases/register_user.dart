import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para registrar un usuario
class RegisterUser {
  final AuthRepository _repository;

  RegisterUser(this._repository);

  Future<Result<User>> call({
    required String email,
    required String password,
    required String name,
    required String role,
    required String phone,
  }) async {
    return await _repository.registerUser(
      email: email,
      password: password,
      name: name,
      role: role,
      phone: phone,
    );
  }
}