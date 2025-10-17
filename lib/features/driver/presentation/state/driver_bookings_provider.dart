import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../bookings/data/services/booking_service.dart';
import '../../../bookings/data/models/booking_model.dart';

/// Estado para las reservas del conductor
class DriverBookingsState {
  final List<BookingModel> pendingBookings;
  final List<BookingModel> confirmedBookings;
  final List<BookingModel> completedBookings;
  final bool isLoading;
  final String? error;

  const DriverBookingsState({
    this.pendingBookings = const [],
    this.confirmedBookings = const [],
    this.completedBookings = const [],
    this.isLoading = false,
    this.error,
  });

  DriverBookingsState copyWith({
    List<BookingModel>? pendingBookings,
    List<BookingModel>? confirmedBookings,
    List<BookingModel>? completedBookings,
    bool? isLoading,
    String? error,
  }) {
    return DriverBookingsState(
      pendingBookings: pendingBookings ?? this.pendingBookings,
      confirmedBookings: confirmedBookings ?? this.confirmedBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Total de reservas activas (pendientes + confirmadas)
  int get totalActiveBookings => pendingBookings.length + confirmedBookings.length;

  /// Todas las reservas
  List<BookingModel> get allBookings => [
    ...pendingBookings,
    ...confirmedBookings,
    ...completedBookings,
  ];
}

/// Provider para gestión de reservas del conductor
class DriverBookingsNotifier extends StateNotifier<DriverBookingsState> {
  final BookingService _bookingService;

  DriverBookingsNotifier({
    BookingService? bookingService,
  })  : _bookingService = bookingService ?? BookingService(),
        super(const DriverBookingsState());

  /// Cargar todas las reservas pendientes del conductor
  Future<void> loadPendingBookings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pendingBookings = await _bookingService.getPendingBookingsForDriver();
      
      state = state.copyWith(
        pendingBookings: pendingBookings,
        isLoading: false,
      );
    } catch (e) {
      print('📋 ERROR loading pending bookings: $e');
      state = state.copyWith(
        error: 'Error al cargar reservas pendientes: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Aceptar una reserva
  Future<bool> acceptBooking(BookingModel booking) async {
    try {
      final updatedBooking = await _bookingService.acceptBooking(
        booking.tripId, 
        booking.id,
      );
      
      // Actualizar el estado local
      final updatedPendingBookings = state.pendingBookings.where((b) => b.id != booking.id).toList();
      final updatedConfirmedBookings = [...state.confirmedBookings, updatedBooking];
      
      state = state.copyWith(
        pendingBookings: updatedPendingBookings,
        confirmedBookings: updatedConfirmedBookings,
      );
      
      return true;
    } catch (e) {
      print('📋 ERROR accepting booking: $e');
      state = state.copyWith(
        error: 'Error al aceptar reserva: ${e.toString()}',
      );
      return false;
    }
  }

  /// Rechazar una reserva
  Future<bool> rejectBooking(BookingModel booking) async {
    try {
      await _bookingService.rejectBooking(
        booking.tripId, 
        booking.id,
      );
      
      // Actualizar el estado local eliminando la reserva rechazada
      final updatedPendingBookings = state.pendingBookings.where((b) => b.id != booking.id).toList();
      
      state = state.copyWith(
        pendingBookings: updatedPendingBookings,
      );
      
      return true;
    } catch (e) {
      print('📋 ERROR rejecting booking: $e');
      state = state.copyWith(
        error: 'Error al rechazar reserva: ${e.toString()}',
      );
      return false;
    }
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refrescar datos
  Future<void> refresh() async {
    await loadPendingBookings();
  }
}

/// Provider principal para reservas del conductor
final driverBookingsProvider = StateNotifierProvider<DriverBookingsNotifier, DriverBookingsState>((ref) {
  return DriverBookingsNotifier();
});

/// Provider para obtener solo reservas pendientes
final pendingDriverBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingsState = ref.watch(driverBookingsProvider);
  return bookingsState.pendingBookings;
});

/// Provider para obtener solo reservas confirmadas
final confirmedDriverBookingsProvider = Provider<List<BookingModel>>((ref) {
  final bookingsState = ref.watch(driverBookingsProvider);
  return bookingsState.confirmedBookings;
});

/// Provider AsyncValue para usar con .when()
final pendingDriverBookingsAsyncProvider = FutureProvider<List<BookingModel>>((ref) async {
  final notifier = ref.read(driverBookingsProvider.notifier);
  await notifier.loadPendingBookings();
  return ref.watch(driverBookingsProvider).pendingBookings;
});