import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../dto/booking_request_dto.dart';
import '../models/booking_model.dart';

/// Servicio para consumir endpoints de reservas
class BookingService {
  final ApiClient _apiClient;

  BookingService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Crear una reserva para un viaje específico
  /// POST /api/trips/{tripId}/bookings
  Future<BookingModel> createBooking(int tripId, BookingRequestDto request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/trips/$tripId/bookings',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return BookingModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Booking creation failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Booking creation failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para crear reservas', 403);
      } else if (e.response?.statusCode == 400) {
        throw ServerException('Datos de entrada inválidos o no hay asientos disponibles', 400);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Aceptar una reserva (solo conductores)
  /// PUT /api/trips/{tripId}/bookings/{bookingId}/accept
  Future<BookingModel> acceptBooking(int tripId, int bookingId) async {
    try {
      final response = await _apiClient.dio.put('/api/trips/$tripId/bookings/$bookingId/accept');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return BookingModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Booking acceptance failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Booking acceptance failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para aceptar esta reserva', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Reserva o viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Rechazar una reserva (solo conductores)
  /// PUT /api/trips/{tripId}/bookings/{bookingId}/reject
  Future<BookingModel> rejectBooking(int tripId, int bookingId) async {
    try {
      final response = await _apiClient.dio.put('/api/trips/$tripId/bookings/$bookingId/reject');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return BookingModel.fromJson(apiResponse['data']);
        } else {
          throw ServerException(apiResponse['message'] ?? 'Booking rejection failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Booking rejection failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para rechazar esta reserva', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Reserva o viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Listar reservas de un viaje (solo conductores)
  /// GET /api/trips/{tripId}/bookings
  Future<List<BookingModel>> getTripBookings(int tripId) async {
    try {
      final response = await _apiClient.dio.get('/api/trips/$tripId/bookings');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> bookingsData = apiResponse['data'];
          return bookingsData.map((booking) => BookingModel.fromJson(booking)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get trip bookings', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get trip bookings with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para ver las reservas de este viaje', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Listar reservas de un usuario
  /// GET /api/users/{userId}/bookings
  Future<List<BookingModel>> getUserBookings(int userId) async {
    try {
      final response = await _apiClient.dio.get('/api/users/$userId/bookings');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> bookingsData = apiResponse['data'];
          return bookingsData.map((booking) => BookingModel.fromJson(booking)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get user bookings', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get user bookings with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para ver estas reservas', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Usuario no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener reservas del usuario autenticado
  /// GET /api/bookings/my-bookings (asumiendo que existe este endpoint o usar getUserBookings con el ID del usuario actual)
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await _apiClient.dio.get('/api/bookings/my-bookings');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> bookingsData = apiResponse['data'];
          return bookingsData.map((booking) => BookingModel.fromJson(booking)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get my bookings', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get my bookings with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('No autorizado', 401);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }
}