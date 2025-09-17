import 'package:equatable/equatable.dart';

/// Clase base para todos los failures de la aplicación
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(this.message, {this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

/// Failure de red
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.details});
}

/// Failure de servidor
class ServerFailure extends Failure {
  final int statusCode;
  
  const ServerFailure(
    super.message, 
    this.statusCode, 
    {super.code, super.details}
  );

  @override
  List<Object?> get props => [message, statusCode, code, details];
}

/// Failure de caché
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code, super.details});
}

/// Failure de validación
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;
  
  const ValidationFailure(
    super.message, 
    {this.fieldErrors, super.code, super.details}
  );

  @override
  List<Object?> get props => [message, fieldErrors, code, details];
}

/// Failure de autenticación
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code, super.details});
}

/// Failure de autorización
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, {super.code, super.details});
}

/// Failure cuando no se encuentra un recurso
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code, super.details});
}

/// Failure de timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, {super.code, super.details});
}

/// Failure genérico
class GenericFailure extends Failure {
  const GenericFailure(super.message, {super.code, super.details});
}