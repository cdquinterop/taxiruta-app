import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../bookings/data/services/booking_service.dart';
import '../../../bookings/data/models/booking_model.dart';

/// Estado para las reservas del pasajero
class PassengerBookingState {
  final List<BookingModel> bookings;
  final bool isLoading;
  final String? error;

  const PassengerBookingState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
  });

  PassengerBookingState copyWith({
    List<BookingModel>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return PassengerBookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Obtener reservas por estado
  List<BookingModel> getBookingsByStatus(String status) {
    return bookings.where((booking) => booking.status.toLowerCase() == status.toLowerCase()).toList();
  }

  /// Reservas activas (CONFIRMED y PENDING)
  List<BookingModel> get activeBookings {
    return bookings.where((booking) => 
      booking.status.toLowerCase() == 'confirmed' || 
      booking.status.toLowerCase() == 'pending'
    ).toList();
  }

  /// Reservas completadas
  List<BookingModel> get completedBookings {
    return bookings.where((booking) => booking.status.toLowerCase() == 'completed').toList();
  }

  /// Reservas canceladas
  List<BookingModel> get cancelledBookings {
    return bookings.where((booking) => 
      booking.status.toLowerCase() == 'cancelled' ||
      booking.status.toLowerCase() == 'rejected'
    ).toList();
  }
}

/// Provider para gestión de reservas del pasajero
class PassengerBookingNotifier extends StateNotifier<PassengerBookingState> {
  final BookingService _bookingService;

  PassengerBookingNotifier({
    BookingService? bookingService,
  })  : _bookingService = bookingService ?? BookingService(),
        super(const PassengerBookingState());

  /// Cargar todas las reservas del pasajero
  Future<void> loadMyBookings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final bookings = await _bookingService.getMyBookings();
      
      state = state.copyWith(
        bookings: bookings,
        isLoading: false,
      );
    } catch (e) {
      print('📋 ERROR loading bookings: $e');
      state = state.copyWith(
        error: 'Error al cargar reservas: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Cancelar una reserva
  Future<bool> cancelBooking(BookingModel booking) async {
    try {
      await _bookingService.cancelBooking(booking.tripId, booking.id);
      
      // Actualizar el estado local eliminando la reserva cancelada
      final updatedBookings = state.bookings.map((b) {
        if (b.id == booking.id) {
          return b.copyWith(status: 'cancelled');
        }
        return b;
      }).toList();
      
      state = state.copyWith(bookings: updatedBookings);
      
      print('📋 Booking cancelled successfully: ${booking.id}');
      return true;
    } catch (e) {
      print('📋 ERROR cancelling booking: $e');
      state = state.copyWith(
        error: 'Error al cancelar reserva: ${e.toString()}',
      );
      return false;
    }
  }

  /// Limpiar el estado de error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider principal para el estado de reservas del pasajero
final passengerBookingProvider = StateNotifierProvider<PassengerBookingNotifier, PassengerBookingState>((ref) {
  return PassengerBookingNotifier();
});