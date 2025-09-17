import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../dto/trip_request_dto.dart';
import '../models/trip_model.dart';

/// Servicio para consumir endpoints de viajes
class TripService {
  final ApiClient _apiClient;

  TripService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Crear un nuevo viaje (solo conductores)
  /// POST /api/trips
  Future<TripModel> createTrip(TripRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/trips',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return TripModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Trip creation failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Trip creation failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para crear viajes', 403);
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Datos de entrada inválidos', 400);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener todos los viajes activos disponibles
  /// GET /api/trips
  Future<List<TripModel>> getAllTrips() async {
    try {
      final response = await _apiClient.dio.get('/api/trips');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get trips', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get trips with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener un viaje por su ID
  /// GET /api/trips/{id}
  Future<TripModel> getTripById(int id) async {
    try {
      final response = await _apiClient.dio.get('/api/trips/$id');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return TripModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get trip', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get trip with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ServerException('Viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Actualizar un viaje existente (solo el conductor propietario)
  /// PUT /api/trips/{id}
  Future<TripModel> updateTrip(int id, TripRequestDto request) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/trips/$id',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return TripModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Trip update failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Trip update failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para actualizar este viaje', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Viaje no encontrado', 404);
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Datos de entrada inválidos', 400);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Cancelar un viaje (solo el conductor propietario)
  /// DELETE /api/trips/{id}
  Future<void> deleteTrip(int id) async {
    try {
      final response = await _apiClient.dio.delete('/api/trips/$id');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] != true) {
          throw ServerException(apiResponse['message'] ?? 'Trip deletion failed', response.statusCode ?? 500);
        }
        // Success - no return value needed
      } else {
        throw ServerException('Trip deletion failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para cancelar este viaje', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener los viajes del conductor autenticado
  /// GET /api/trips/my-trips
  Future<List<TripModel>> getMyTrips() async {
    try {
      final response = await _apiClient.dio.get('/api/trips/my-trips');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get my trips', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get my trips with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para ver viajes de conductor', 403);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }
}