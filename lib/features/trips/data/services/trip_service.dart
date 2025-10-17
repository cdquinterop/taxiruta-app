import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../dto/trip_request_dto.dart';
import '../models/trip_model.dart';
import '../../../bookings/data/models/booking_model.dart';

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

  /// Obtener viajes por estado específico
  /// GET /api/trips/status/{status}
  Future<List<TripModel>> getTripsByStatus(String status) async {
    try {
      final response = await _apiClient.dio.get('/api/trips/status/$status');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get trips by status', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get trips by status with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener viajes pendientes (ACTIVE)
  /// GET /api/trips/pending
  Future<List<TripModel>> getPendingTrips() async {
    try {
      final response = await _apiClient.dio.get('/api/trips/pending');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get pending trips', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get pending trips with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener viajes en curso (con reservas confirmadas)
  /// GET /api/trips/in-progress
  Future<List<TripModel>> getInProgressTrips() async {
    try {
      final response = await _apiClient.dio.get('/api/trips/in-progress');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get in progress trips', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get in progress trips with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener viajes completados
  /// GET /api/trips/completed
  Future<List<TripModel>> getCompletedTrips() async {
    try {
      final response = await _apiClient.dio.get('/api/trips/completed');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get completed trips', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get completed trips with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Buscar viajes por destino con filtros opcionales
  /// GET /api/trips/search
  Future<List<TripModel>> searchTrips({
    String? origin,
    String? destination,
    DateTime? departureDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (origin != null && origin.isNotEmpty) {
        queryParams['origin'] = origin;
      }
      if (destination != null && destination.isNotEmpty) {
        queryParams['destination'] = destination;
      }
      if (departureDate != null) {
        queryParams['departureDate'] = departureDate.toIso8601String();
      }

      final response = await _apiClient.dio.get(
        '/api/trips/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> tripsData = apiResponse['data'];
          return tripsData.map((trip) => TripModel.fromJson(trip)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to search trips', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to search trips with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException('Parámetros de búsqueda inválidos', 400);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Iniciar un viaje
  /// POST /api/trips/{id}/start
  Future<TripModel> startTrip(int tripId) async {
    try {
      final response = await _apiClient.dio.post('/api/trips/$tripId/start');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return TripModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to start trip', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to start trip with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Completar un viaje
  /// POST /api/trips/{id}/complete
  Future<TripModel> completeTrip(int tripId) async {
    try {
      final response = await _apiClient.dio.post('/api/trips/$tripId/complete');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return TripModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to complete trip', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to complete trip with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener pasajeros confirmados de un viaje
  /// GET /api/trips/{id}/passengers
  Future<List<BookingModel>> getTripPassengers(int tripId) async {
    try {
      final response = await _apiClient.dio.get('/api/trips/$tripId/passengers');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> passengersData = apiResponse['data'];
          return passengersData.map((passenger) => BookingModel.fromJson(passenger)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get trip passengers', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get trip passengers with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }
}