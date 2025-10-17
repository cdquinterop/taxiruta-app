import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../trips/data/services/trip_service.dart';
import '../../../trips/data/models/trip_model.dart';
import '../../../bookings/data/services/booking_service.dart';
import '../../../bookings/data/dto/booking_request_dto.dart';
import '../../../bookings/data/models/booking_model.dart';

/// Estado para búsqueda de viajes
class PassengerTripState {
  final List<TripModel> availableTrips;
  final bool isLoading;
  final String? error;
  final bool isSearching;

  const PassengerTripState({
    this.availableTrips = const [],
    this.isLoading = false,
    this.error,
    this.isSearching = false,
  });

  PassengerTripState copyWith({
    List<TripModel>? availableTrips,
    bool? isLoading,
    String? error,
    bool? isSearching,
  }) {
    return PassengerTripState(
      availableTrips: availableTrips ?? this.availableTrips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// Provider para gestión de viajes del pasajero
class PassengerTripNotifier extends StateNotifier<PassengerTripState> {
  final TripService _tripService;
  final BookingService _bookingService;

  PassengerTripNotifier({
    TripService? tripService,
    BookingService? bookingService,
  })  : _tripService = tripService ?? TripService(),
        _bookingService = bookingService ?? BookingService(),
        super(const PassengerTripState());

  /// Buscar viajes con filtros opcionales
  Future<void> searchTrips({
    String? origin,
    String? destination,
    DateTime? departureDate,
  }) async {
    state = state.copyWith(isSearching: true, error: null);

    try {
      final trips = await _tripService.searchTrips(
        origin: origin,
        destination: destination,
        departureDate: departureDate,
      );

      state = state.copyWith(
        availableTrips: trips,
        isSearching: false,
      );
    } catch (e) {
      print('🔍 ERROR searching trips: $e');
      state = state.copyWith(
        error: 'Error al buscar viajes: ${e.toString()}',
        isSearching: false,
      );
    }
  }

  /// Obtener todos los viajes disponibles
  Future<void> loadAvailableTrips() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trips = await _tripService.getAllTrips();
      
      state = state.copyWith(
        availableTrips: trips,
        isLoading: false,
      );
    } catch (e) {
      print('🔍 ERROR loading trips: $e');
      state = state.copyWith(
        error: 'Error al cargar viajes: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Crear una reserva para un viaje específico
  Future<BookingModel?> bookTrip({
    required int tripId,
    required int seatsRequested,
  }) async {
    try {
      final bookingRequest = BookingRequestDto(
        seatsRequested: seatsRequested,
      );

      final booking = await _bookingService.createBooking(tripId, bookingRequest);
      
      print('🎫 Booking created successfully: ${booking.id}');
      return booking;
    } catch (e) {
      print('🎫 ERROR creating booking: $e');
      state = state.copyWith(
        error: 'Error al reservar viaje: ${e.toString()}',
      );
      // Re-lanzar la excepción para que pueda ser manejada en la UI
      rethrow;
    }
  }

  /// Calcular los asientos realmente disponibles para un viaje
  /// considerando las reservas pendientes y confirmadas
  int calculateRealAvailableSeats(TripModel trip) {
    if (trip.bookings == null || trip.bookings!.isEmpty) {
      return trip.remainingSeats;
    }
    
    // Sumar asientos de reservas activas (pendientes y confirmadas)
    int reservedSeats = trip.bookings!
        .where((booking) => 
            booking.status == 'PENDING' || 
            booking.status == 'CONFIRMED')
        .map((booking) => booking.seatsRequested)
        .fold(0, (sum, seats) => sum + seats);
    
    // Los asientos realmente disponibles son los totales menos los reservados
    int realAvailableSeats = trip.availableSeats - reservedSeats;
    
    return realAvailableSeats > 0 ? realAvailableSeats : 0;
  }

  /// Limpiar el estado de error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider principal para el estado de viajes del pasajero
final passengerTripProvider = StateNotifierProvider<PassengerTripNotifier, PassengerTripState>((ref) {
  return PassengerTripNotifier();
});