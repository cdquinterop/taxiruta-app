import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/trip_service.dart';
import '../../data/dto/trip_request_dto.dart';
import '../../data/models/trip_model.dart';
import '../../domain/entities/trip.dart';

/// Estado para manejar la creación y gestión de viajes
class TripState {
  final List<Trip> trips;
  final List<TripModel> pendingTrips;
  final List<TripModel> inProgressTrips;
  final List<TripModel> completedTrips;
  final Trip? currentTrip;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  const TripState({
    this.trips = const [],
    this.pendingTrips = const [],
    this.inProgressTrips = const [],
    this.completedTrips = const [],
    this.currentTrip,
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });

  TripState copyWith({
    List<Trip>? trips,
    List<TripModel>? pendingTrips,
    List<TripModel>? inProgressTrips,
    List<TripModel>? completedTrips,
    Trip? currentTrip,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return TripState(
      trips: trips ?? this.trips,
      pendingTrips: pendingTrips ?? this.pendingTrips,
      inProgressTrips: inProgressTrips ?? this.inProgressTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      currentTrip: currentTrip ?? this.currentTrip,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error,
    );
  }
}

/// Notificador para el estado de los viajes
class TripNotifier extends StateNotifier<TripState> {
  final TripService _tripService;

  TripNotifier(this._tripService) : super(const TripState());

  /// Crear un nuevo viaje
  Future<bool> createTrip({
    required String origin,
    required String destination,
    required DateTime departureTime,
    required int availableSeats,
    required double pricePerSeat,
    String? description,
  }) async {
    print('🚗 TRIP_PROVIDER: Iniciando creación de viaje');
    state = state.copyWith(isCreating: true, error: null);

    try {
      final request = TripRequestDto(
        origin: origin,
        destination: destination,
        departureTime: departureTime,
        availableSeats: availableSeats,
        pricePerSeat: pricePerSeat,
        description: description,
      );

      print('🚗 TRIP_PROVIDER: Datos del viaje: $request');
      final tripModel = await _tripService.createTrip(request);
      final trip = tripModel.toEntity();
      
      print('✅ TRIP_PROVIDER: Viaje creado exitosamente - ID: ${trip.id}');
      
      // Actualizar la lista de viajes agregando el nuevo viaje
      final updatedTrips = List<Trip>.from(state.trips)..add(trip);
      state = state.copyWith(
        trips: updatedTrips,
        currentTrip: trip,
        isCreating: false,
      );
      
      return true;
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error creando viaje: $e');
      state = state.copyWith(
        isCreating: false,
        error: 'Error creando viaje: $e',
      );
      return false;
    }
  }

  /// Obtener todos los viajes activos
  Future<void> loadActiveTrips() async {
    print('🚗 TRIP_PROVIDER: Cargando viajes activos');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tripModels = await _tripService.getAllTrips();
      final trips = tripModels.map((model) => model.toEntity()).toList();
      
      print('✅ TRIP_PROVIDER: ${trips.length} viajes cargados');
      state = state.copyWith(
        trips: trips,
        isLoading: false,
      );
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error cargando viajes: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando viajes: $e',
      );
    }
  }

  /// Obtener los viajes del conductor actual
  Future<void> loadMyTrips() async {
    print('🚗 TRIP_PROVIDER: Cargando mis viajes');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tripModels = await _tripService.getMyTrips();
      final trips = tripModels.map((model) => model.toEntity()).toList();
      
      print('✅ TRIP_PROVIDER: ${trips.length} viajes propios cargados');
      state = state.copyWith(
        trips: trips,
        isLoading: false,
      );
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error cargando mis viajes: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando mis viajes: $e',
      );
    }
  }

  /// Obtener un viaje por ID
  Future<Trip?> getTripById(int id) async {
    print('🚗 TRIP_PROVIDER: Obteniendo viaje ID: $id');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tripModel = await _tripService.getTripById(id);
      final trip = tripModel.toEntity();
      
      print('✅ TRIP_PROVIDER: Viaje obtenido: ${trip.origin} -> ${trip.destination}');
      state = state.copyWith(
        currentTrip: trip,
        isLoading: false,
      );
      
      return trip;
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error obteniendo viaje: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error obteniendo viaje: $e',
      );
      return null;
    }
  }

  /// Actualizar un viaje existente
  Future<bool> updateTrip({
    required int id,
    required String origin,
    required String destination,
    required DateTime departureTime,
    required int availableSeats,
    required double pricePerSeat,
    String? description,
  }) async {
    print('🚗 TRIP_PROVIDER: Actualizando viaje ID: $id');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = TripRequestDto(
        origin: origin,
        destination: destination,
        departureTime: departureTime,
        availableSeats: availableSeats,
        pricePerSeat: pricePerSeat,
        description: description,
      );

      final tripModel = await _tripService.updateTrip(id, request);
      final updatedTrip = tripModel.toEntity();
      
      // Actualizar la lista de viajes
      final updatedTrips = state.trips.map((trip) {
        return trip.id == id ? updatedTrip : trip;
      }).toList();
      
      print('✅ TRIP_PROVIDER: Viaje actualizado exitosamente');
      state = state.copyWith(
        trips: updatedTrips,
        currentTrip: updatedTrip,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error actualizando viaje: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error actualizando viaje: $e',
      );
      return false;
    }
  }

  /// Cancelar un viaje
  Future<bool> cancelTrip(int id) async {
    print('🚗 TRIP_PROVIDER: Cancelando viaje ID: $id');
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _tripService.deleteTrip(id);
      
      // Remover el viaje de la lista
      final updatedTrips = state.trips.where((trip) => trip.id != id).toList();
      
      print('✅ TRIP_PROVIDER: Viaje cancelado exitosamente');
      state = state.copyWith(
        trips: updatedTrips,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error cancelando viaje: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cancelando viaje: $e',
      );
      return false;
    }
  }

  /// Cargar viajes pendientes (ACTIVE)
  Future<void> loadPendingTrips() async {
    print('🚗 TRIP_PROVIDER: Cargando viajes pendientes');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tripModels = await _tripService.getPendingTrips();
      
      // Filtrar viajes: mostrar de HOY y FUTUROS (no mostrar vencidos)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final filteredTrips = tripModels.where((trip) {
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month, 
          trip.departureTime.day,
        );
        return tripDate.isAfter(today) || tripDate.isAtSameMomentAs(today);
      }).toList();
      
      print('✅ TRIP_PROVIDER: ${tripModels.length} viajes pendientes cargados, ${filteredTrips.length} después del filtro de fecha');
      state = state.copyWith(
        pendingTrips: filteredTrips,
        isLoading: false,
      );
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error cargando viajes pendientes: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando viajes pendientes: $e',
      );
    }
  }

  /// Cargar viajes en progreso
  Future<void> loadInProgressTrips() async {
    print('🚗 TRIP_PROVIDER: Cargando viajes en progreso');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tripModels = await _tripService.getInProgressTrips();
      
      // Filtrar viajes: mostrar de HOY y FUTUROS (no mostrar vencidos)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final filteredTrips = tripModels.where((trip) {
        final tripDate = DateTime(
          trip.departureTime.year,
          trip.departureTime.month, 
          trip.departureTime.day,
        );
        return tripDate.isAfter(today) || tripDate.isAtSameMomentAs(today);
      }).toList();
      
      print('✅ TRIP_PROVIDER: ${tripModels.length} viajes en progreso cargados, ${filteredTrips.length} después del filtro de fecha');
      state = state.copyWith(
        inProgressTrips: filteredTrips,
        isLoading: false,
      );
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error cargando viajes en progreso: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando viajes en progreso: $e',
      );
    }
  }

  /// Cargar viajes completados
  Future<void> loadCompletedTrips() async {
    print('🚗 TRIP_PROVIDER: Cargando viajes completados');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tripModels = await _tripService.getCompletedTrips();
      
      // Para viajes completados, mostrar historial completo (no filtrar por fecha)
      // Los completados ya están finalizados, así que es útil ver el historial
      
      print('✅ TRIP_PROVIDER: ${tripModels.length} viajes completados cargados (historial completo)');
      state = state.copyWith(
        completedTrips: tripModels,
        isLoading: false,
      );
    } catch (e) {
      print('❌ TRIP_PROVIDER: Error cargando viajes completados: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando viajes completados: $e',
      );
    }
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Limpiar el viaje actual
  void clearCurrentTrip() {
    state = state.copyWith(currentTrip: null);
  }

  /// Limpiar todos los datos
  void clearAll() {
    state = const TripState();
  }
}

/// Provider del servicio de trips
final tripServiceProvider = Provider<TripService>((ref) {
  return TripService();
});

/// Provider principal del notificador de trips
final tripNotifierProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  final tripService = ref.watch(tripServiceProvider);
  return TripNotifier(tripService);
});

/// Provider para obtener la lista de viajes
final tripsProvider = Provider<List<Trip>>((ref) {
  return ref.watch(tripNotifierProvider).trips;
});

/// Provider para obtener el viaje actual
final currentTripProvider = Provider<Trip?>((ref) {
  return ref.watch(tripNotifierProvider).currentTrip;
});

/// Provider para el estado de carga
final tripLoadingProvider = Provider<bool>((ref) {
  return ref.watch(tripNotifierProvider).isLoading;
});

/// Provider para el estado de creación
final tripCreatingProvider = Provider<bool>((ref) {
  return ref.watch(tripNotifierProvider).isCreating;
});

/// Provider para errores
final tripErrorProvider = Provider<String?>((ref) {
  return ref.watch(tripNotifierProvider).error;
});

/// Provider principal simplificado para acceso directo
final tripProvider = tripNotifierProvider;