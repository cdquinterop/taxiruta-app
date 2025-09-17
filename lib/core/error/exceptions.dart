/// Excepción base para todas las excepciones personalizadas de la aplicación
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message';
}

/// Excepción de red
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});
}

/// Excepción de servidor
class ServerException extends AppException {
  final int statusCode;
  
  const ServerException(
    super.message, 
    this.statusCode, 
    {super.code, super.details}
  );
}

/// Excepción de caché
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.details});
}

/// Excepción de validación
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;
  
  const ValidationException(
    super.message, 
    {this.fieldErrors, super.code, super.details}
  );
}

/// Excepción de autenticación
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.details});
}

/// Excepción de autorización  
class AuthorizationException extends AppException {
  const AuthorizationException(super.message, {super.code, super.details});
}

/// Excepción cuando no se encuentra un recurso
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.details});
}

/// Excepción de timeout
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code, super.details});
}

/// Excepción genérica
class GenericException extends AppException {
  const GenericException(super.message, {super.code, super.details});
}