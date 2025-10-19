import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../trips/data/services/trip_service.dart';
import '../../../trips/data/models/trip_model.dart';
import '../../../bookings/data/models/booking_model.dart';

/// Estado para viajes del conductor
class DriverTripsState {
  final List<TripModel> myTrips;
  final List<TripModel> activeTrips;
  final List<TripModel> inProgressTrips;
  final List<TripModel> completedTrips;
  final List<BookingModel> tripPassengers;
  final bool isLoading;
  final String? error;
  final bool isStartingTrip;
  final bool isCompletingTrip;

  const DriverTripsState({
    this.myTrips = const [],
    this.activeTrips = const [],
    this.inProgressTrips = const [],
    this.completedTrips = const [],
    this.tripPassengers = const [],
    this.isLoading = false,
    this.error,
    this.isStartingTrip = false,
    this.isCompletingTrip = false,
  });

  DriverTripsState copyWith({
    List<TripModel>? myTrips,
    List<TripModel>? activeTrips,
    List<TripModel>? inProgressTrips,
    List<TripModel>? completedTrips,
    List<BookingModel>? tripPassengers,
    bool? isLoading,
    String? error,
    bool? isStartingTrip,
    bool? isCompletingTrip,
  }) {
    return DriverTripsState(
      myTrips: myTrips ?? this.myTrips,
      activeTrips: activeTrips ?? this.activeTrips,
      inProgressTrips: inProgressTrips ?? this.inProgressTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      tripPassengers: tripPassengers ?? this.tripPassengers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isStartingTrip: isStartingTrip ?? this.isStartingTrip,
      isCompletingTrip: isCompletingTrip ?? this.isCompletingTrip,
    );
  }
}

/// Notifier para gestión de viajes del conductor
class DriverTripsNotifier extends StateNotifier<DriverTripsState> {
  final TripService _tripService;

  DriverTripsNotifier({
    TripService? tripService,
  })  : _tripService = tripService ?? TripService(),
        super(const DriverTripsState());

  /// Cargar todos los viajes del conductor
  Future<void> loadMyTrips() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trips = await _tripService.getMyTrips();
      
      // Filtrar y ordenar viajes según las nuevas reglas:
      // 1. Viajes de hoy y futuros: TODOS los estados
      // 2. Viajes pasados: Solo COMPLETED e IN_PROGRESS (NO ACTIVE vencidos)
      // 3. Viajes de hoy primero, luego futuros ordenados por fecha
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Filtrar viajes válidos
      final validTrips = trips.where((trip) {
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month,
          trip.departureTime.day,
        );
        
        // Viajes de hoy o futuros: incluir todos los estados
        if (tripDate.isAtSameMomentAs(today) || tripDate.isAfter(today)) {
          return true;
        }
        
        // Viajes pasados: solo incluir COMPLETED e IN_PROGRESS
        return trip.status == 'COMPLETED' || trip.status == 'IN_PROGRESS';
      }).toList();
      
      // Separar viajes de hoy vs futuros vs pasados
      final todayTrips = validTrips.where((trip) {
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month,
          trip.departureTime.day,
        );
        return tripDate.isAtSameMomentAs(today);
      }).toList();
      
      final futureTrips = validTrips.where((trip) {
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month,
          trip.departureTime.day,
        );
        return tripDate.isAfter(today);
      }).toList();
      
      final pastTrips = validTrips.where((trip) {
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month,
          trip.departureTime.day,
        );
        return tripDate.isBefore(today);
      }).toList();
      
      // Ordenar viajes de hoy por hora de salida (más próximos primero)
      todayTrips.sort((a, b) => a.departureTime.compareTo(b.departureTime));
      
      // Ordenar viajes futuros por fecha de salida
      futureTrips.sort((a, b) => a.departureTime.compareTo(b.departureTime));
      
      // Ordenar viajes pasados por fecha de salida (más recientes primero)
      pastTrips.sort((a, b) => b.departureTime.compareTo(a.departureTime));
      
      // Combinar: primero hoy, luego futuros, luego pasados
      final sortedValidTrips = [...todayTrips, ...futureTrips, ...pastTrips];
      
      print('🚗 DEBUG: Total trips from backend: ${trips.length}');
      
      // Agregar debug detallado de fechas
      print('🚗 DEBUG: Current date: $now');
      print('🚗 DEBUG: Today: $today');
      
      for (var trip in trips.take(3)) { // Solo los primeros 3 para no saturar
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month,
          trip.departureTime.day,
        );
        print('🚗 DEBUG Trip ${trip.id}: departureTime=${trip.departureTime}, tripDate=$tripDate, status=${trip.status}');
        print('🚗 DEBUG Trip ${trip.id}: isToday=${tripDate.isAtSameMomentAs(today)}, isFuture=${tripDate.isAfter(today)}');
      }
      
      print('🚗 DEBUG: Today trips: ${todayTrips.length}');
      print('🚗 DEBUG: Future trips: ${futureTrips.length}');
      print('🚗 DEBUG: Total valid trips: ${sortedValidTrips.length}');
      
      // Filtrar por estado manteniendo el orden
      final activeTrips = sortedValidTrips.where((trip) => trip.status == 'ACTIVE').toList();
      final inProgressTrips = sortedValidTrips.where((trip) => trip.status == 'IN_PROGRESS').toList();
      final completedTrips = sortedValidTrips.where((trip) => trip.status == 'COMPLETED').toList();

      print('🚗 DEBUG: Active trips: ${activeTrips.length}');
      print('🚗 DEBUG: InProgress trips: ${inProgressTrips.length}');
      print('🚗 DEBUG: Completed trips: ${completedTrips.length}');
      
      state = state.copyWith(
        myTrips: sortedValidTrips,
        activeTrips: activeTrips,
        inProgressTrips: inProgressTrips,
        completedTrips: completedTrips,
        isLoading: false,
      );
    } catch (e) {
      print('🚗 ERROR loading driver trips: $e');
      state = state.copyWith(
        error: 'Error al cargar viajes: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Iniciar un viaje
  Future<bool> startTrip(int tripId) async {
    state = state.copyWith(isStartingTrip: true, error: null);

    try {
      final updatedTrip = await _tripService.startTrip(tripId);
      
      // Actualizar la lista local
      final updatedTrips = state.myTrips.map((trip) {
        if (trip.id == tripId) {
          return updatedTrip;
        }
        return trip;
      }).toList();

      // Refiltrar por estado
      final activeTrips = updatedTrips.where((trip) => trip.status == 'ACTIVE').toList();
      final inProgressTrips = updatedTrips.where((trip) => trip.status == 'IN_PROGRESS').toList();
      final completedTrips = updatedTrips.where((trip) => trip.status == 'COMPLETED').toList();

      state = state.copyWith(
        myTrips: updatedTrips,
        activeTrips: activeTrips,
        inProgressTrips: inProgressTrips,
        completedTrips: completedTrips,
        isStartingTrip: false,
      );

      return true;
    } catch (e) {
      print('🚗 ERROR starting trip: $e');
      state = state.copyWith(
        error: 'Error al iniciar viaje: ${e.toString()}',
        isStartingTrip: false,
      );
      return false;
    }
  }

  /// Completar un viaje
  Future<bool> completeTrip(int tripId) async {
    state = state.copyWith(isCompletingTrip: true, error: null);

    try {
      final updatedTrip = await _tripService.completeTrip(tripId);
      
      // Actualizar la lista local
      final updatedTrips = state.myTrips.map((trip) {
        if (trip.id == tripId) {
          return updatedTrip;
        }
        return trip;
      }).toList();

      // Refiltrar por estado
      final activeTrips = updatedTrips.where((trip) => trip.status == 'ACTIVE').toList();
      final inProgressTrips = updatedTrips.where((trip) => trip.status == 'IN_PROGRESS').toList();
      final completedTrips = updatedTrips.where((trip) => trip.status == 'COMPLETED').toList();

      state = state.copyWith(
        myTrips: updatedTrips,
        activeTrips: activeTrips,
        inProgressTrips: inProgressTrips,
        completedTrips: completedTrips,
        isCompletingTrip: false,
      );

      return true;
    } catch (e) {
      print('🚗 ERROR completing trip: $e');
      state = state.copyWith(
        error: 'Error al completar viaje: ${e.toString()}',
        isCompletingTrip: false,
      );
      return false;
    }
  }

  /// Obtener pasajeros de un viaje
  Future<void> loadTripPassengers(int tripId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final passengers = await _tripService.getTripPassengers(tripId);
      
      state = state.copyWith(
        tripPassengers: passengers,
        isLoading: false,
      );
    } catch (e) {
      print('🚗 ERROR loading trip passengers: $e');
      state = state.copyWith(
        error: 'Error al cargar pasajeros: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para viajes del conductor
final driverTripsProvider = StateNotifierProvider<DriverTripsNotifier, DriverTripsState>((ref) {
  return DriverTripsNotifier();
});