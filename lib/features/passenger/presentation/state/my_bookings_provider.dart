import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../bookings/data/services/booking_service.dart';
import '../../../bookings/domain/entities/booking.dart';

/// Estado para las reservas del usuario
@immutable
class MyBookingsState {
  final List<BookingModel> bookings;
  final bool isLoading;
  final String? error;

  const MyBookingsState({
    this.bookings = const [],
    this.isLoading = false,
    this.error,
  });

  MyBookingsState copyWith({
    List<BookingModel>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return MyBookingsState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notificador para gestionar las reservas del usuario
class MyBookingsNotifier extends StateNotifier<MyBookingsState> {
  final BookingService _bookingService;

  MyBookingsNotifier({BookingService? bookingService})
      : _bookingService = bookingService ?? BookingService(),
        super(const MyBookingsState());

  /// Cargar las reservas del usuario autenticado
  Future<void> loadMyBookings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final bookings = await _bookingService.getMyBookings();
      
      // Ordenar por fecha de reserva (más recientes primero)
      bookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
      
      state = state.copyWith(
        bookings: bookings,
        isLoading: false,
      );

      print('📋 Loaded ${bookings.length} bookings');
    } catch (e) {
      print('📋 ERROR loading bookings: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Cancelar una reserva específica
  Future<void> cancelBooking(int tripId, int bookingId) async {
    try {
      await _bookingService.cancelBooking(tripId, bookingId);
      
      // Recargar las reservas después de cancelar
      await loadMyBookings();
      
      print('📋 Booking $bookingId cancelled successfully');
    } catch (e) {
      print('📋 ERROR cancelling booking: $e');
      throw e; // Re-lanzar para que la UI pueda manejar el error
    }
  }

  /// Verificar si el usuario ya tiene una reserva activa para un viaje específico
  bool hasActiveBookingForTrip(int tripId) {
    return state.bookings.any((booking) =>
        booking.tripId == tripId &&
        (BookingStatusX.fromString(booking.status) == BookingStatus.pending ||
        BookingStatusX.fromString(booking.status) == BookingStatus.confirmed));
  }

  /// Limpiar el estado de error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider principal para las reservas del usuario
final myBookingsProvider = StateNotifierProvider<MyBookingsNotifier, MyBookingsState>((ref) {
  return MyBookingsNotifier();
});

/// Provider para obtener reservas pendientes solamente
final pendingBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingsState = ref.watch(myBookingsProvider);
  return bookingsState.bookings.where((booking) => booking.status == 'PENDING').toList();
});

/// Provider para obtener reservas confirmadas solamente
final confirmedBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingsState = ref.watch(myBookingsProvider);
  return bookingsState.bookings.where((booking) => booking.status == 'CONFIRMED').toList();
});

/// Provider AsyncValue para usar con .when()
final myBookingsAsyncProvider = FutureProvider<List<BookingModel>>((ref) async {
  final notifier = ref.read(myBookingsProvider.notifier);
  await notifier.loadMyBookings();
  return ref.watch(myBookingsProvider).bookings;
});