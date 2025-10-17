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
        // Parsear el mensaje específico del servidor
        String errorMessage = 'Datos de entrada inválidos o no hay asientos disponibles';
        try {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic> && responseData['message'] != null) {
            final serverMessage = responseData['message'].toString().toLowerCase();
            if (serverMessage.contains('booking already exists')) {
              errorMessage = 'Ya tienes una reserva activa para este viaje';
            } else if (serverMessage.contains('no available seats') || serverMessage.contains('insufficient seats')) {
              errorMessage = 'No hay suficientes asientos disponibles';
            } else if (serverMessage.contains('invalid seats')) {
              errorMessage = 'Cantidad de asientos inválida';
            } else {
              errorMessage = responseData['message'];
            }
          }
        } catch (_) {
          // Si hay error parseando, usar mensaje por defecto
        }
        throw ServerException(errorMessage, 400);
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
  /// GET /api/my-bookings
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await _apiClient.dio.get('/api/my-bookings');

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

  /// Cancelar una reserva
  /// DELETE /api/trips/{tripId}/bookings/{bookingId}
  Future<void> cancelBooking(int tripId, int bookingId) async {
    try {
      final response = await _apiClient.dio.delete('/api/trips/$tripId/bookings/$bookingId');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] != true) {
          throw ServerException(apiResponse['message'] ?? 'Booking cancellation failed', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Booking cancellation failed with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para cancelar esta reserva', 403);
      } else if (e.response?.statusCode == 404) {
        throw ServerException('Reserva o viaje no encontrado', 404);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }

  /// Obtener reservas pendientes para el conductor autenticado
  /// GET /api/driver/pending-bookings
  Future<List<BookingModel>> getPendingBookingsForDriver() async {
    try {
      final response = await _apiClient.dio.get('/api/driver/pending-bookings');

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          final List<dynamic> bookingsData = apiResponse['data'];
          return bookingsData.map((booking) => BookingModel.fromJson(booking)).toList();
        } else {
          throw ServerException(apiResponse['message'] ?? 'Failed to get pending bookings', response.statusCode ?? 500);
        }
      } else {
        throw ServerException('Failed to get pending bookings with status code: ${response.statusCode}', response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException('No tienes permisos para ver estas reservas', 403);
      } else if (e.response?.statusCode == 401) {
        throw ServerException('No autorizado', 401);
      } else {
        throw ServerException('Error de conexión: ${e.message}', e.response?.statusCode ?? 500);
      }
    } catch (e) {
      throw ServerException('Error inesperado: $e', 500);
    }
  }
}