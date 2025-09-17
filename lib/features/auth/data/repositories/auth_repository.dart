import '../../../../core/error/exceptions.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../../domain/entities/user.dart';

/// Repositorio de autenticación que maneja la lógica de negocio
class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService}) 
      : _authService = authService ?? AuthService();

  /// Login de usuario
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequestDto(
        usernameOrEmail: email,
        password: password,
      );
      
      return await _authService.login(request);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error inesperado durante el login: $e', 500);
    }
  }

  /// Registro de usuario
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String role = 'PASSENGER',
  }) async {
    try {
      final request = RegisterRequestDto(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      
      return await _authService.register(request);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error inesperado durante el registro: $e', 500);
    }
  }

  /// Obtener perfil del usuario autenticado
  Future<User> getProfile() async {
    try {
      final userModel = await _authService.getProfile();
      return userModel.toEntity();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error inesperado al obtener el perfil: $e', 500);
    }
  }

  /// Validar que el usuario esté autenticado
  Future<bool> isAuthenticated() async {
    try {
      await getProfile();
      return true;
    } catch (e) {
      return false;
    }
  }
}