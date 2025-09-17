import '../../core/error/failures.dart';

/// Clase para manejar resultados de operaciones que pueden fallar
/// Basada en el patrón Either/Result
sealed class Result<T> {
  const Result();

  /// Crea un resultado exitoso
  const factory Result.success(T data) = Success<T>;

  /// Crea un resultado con error
  const factory Result.failure(Failure failure) = FailureResult<T>;

  /// Verifica si el resultado es exitoso
  bool get isSuccess => this is Success<T>;

  /// Verifica si el resultado es un error
  bool get isFailure => this is FailureResult<T>;

  /// Obtiene los datos si es exitoso, null si es error
  T? get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Obtiene el error si falló, null si es exitoso
  Failure? get failure {
    if (this is FailureResult<T>) {
      return (this as FailureResult<T>).failure;
    }
    return null;
  }

  /// Ejecuta una función si el resultado es exitoso
  Result<R> map<R>(R Function(T) transform) {
    if (this is Success<T>) {
      try {
        return Result.success(transform((this as Success<T>).data));
      } catch (e) {
        return Result.failure(GenericFailure(e.toString()));
      }
    }
    return Result.failure((this as FailureResult<T>).failure);
  }

  /// Ejecuta una función si el resultado es exitoso y puede retornar otro Result
  Result<R> flatMap<R>(Result<R> Function(T) transform) {
    if (this is Success<T>) {
      try {
        return transform((this as Success<T>).data);
      } catch (e) {
        return Result.failure(GenericFailure(e.toString()));
      }
    }
    return Result.failure((this as FailureResult<T>).failure);
  }

  /// Ejecuta una función para cada caso (éxito o error)
  R fold<R>(
    R Function(Failure) onFailure,
    R Function(T) onSuccess,
  ) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    }
    return onFailure((this as FailureResult<T>).failure);
  }

  /// Obtiene los datos o lanza una excepción si es error
  T getOrThrow() {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    throw Exception((this as FailureResult<T>).failure.message);
  }

  /// Obtiene los datos o retorna un valor por defecto
  T getOrElse(T defaultValue) {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return defaultValue;
  }
}

/// Resultado exitoso
final class Success<T> extends Result<T> {
  final T data;
  
  const Success(this.data);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Success<T> && other.data == data);
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Resultado con error
final class FailureResult<T> extends Result<T> {
  final Failure failure;
  
  const FailureResult(this.failure);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is FailureResult<T> && other.failure == failure);
  }

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Failure($failure)';
}

/// Extensiones útiles para trabajar con Result
extension ResultExtensions<T> on Result<T> {
  /// Convierte a Future<Result<T>>
  Future<Result<T>> toFuture() async => this;

  /// Ejecuta una función solo si es exitoso (side effect)
  Result<T> onSuccess(void Function(T) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Ejecuta una función solo si es error (side effect)
  Result<T> onFailure(void Function(Failure) action) {
    if (this is FailureResult<T>) {
      action((this as FailureResult<T>).failure);
    }
    return this;
  }
}

/// Extensiones para Future<Result<T>>
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// Map asíncrono
  Future<Result<R>> mapAsync<R>(Future<R> Function(T) transform) async {
    final result = await this;
    if (result.isSuccess) {
      try {
        final transformed = await transform(result.data!);
        return Result.success(transformed);
      } catch (e) {
        return Result.failure(GenericFailure(e.toString()));
      }
    }
    return Result.failure(result.failure!);
  }

  /// FlatMap asíncrono
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T) transform,
  ) async {
    final result = await this;
    if (result.isSuccess) {
      try {
        return await transform(result.data!);
      } catch (e) {
        return Result.failure(GenericFailure(e.toString()));
      }
    }
    return Result.failure(result.failure!);
  }
}

/// Utilidades para crear Results
class ResultUtils {
  /// Ejecuta una función que puede lanzar excepciones y la envuelve en un Result
  static Result<T> attempt<T>(T Function() action) {
    try {
      return Result.success(action());
    } catch (e) {
      return Result.failure(GenericFailure(e.toString()));
    }
  }

  /// Versión asíncrona de attempt
  static Future<Result<T>> attemptAsync<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Result.success(result);
    } catch (e) {
      return Result.failure(GenericFailure(e.toString()));
    }
  }

  /// Combina múltiples Results en uno solo
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final List<T> values = [];
    for (final result in results) {
      if (result.isFailure) {
        return Result.failure(result.failure!);
      }
      values.add(result.data!);
    }
    return Result.success(values);
  }
}