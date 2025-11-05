import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/group_trip_model.dart';
import '../services/group_trips_service.dart';

/// Estado para los viajes del grupo
class GroupTripsState {
  final List<GroupTripModel> trips;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const GroupTripsState({
    this.trips = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  GroupTripsState copyWith({
    List<GroupTripModel>? trips,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return GroupTripsState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Obtener viajes por estado
  List<GroupTripModel> getTripsByStatus(TripStatus status) {
    return trips.where((trip) => trip.status == status).toList();
  }

  /// Obtener conteo de viajes por estado
  Map<TripStatus, int> get tripCounts {
    final counts = <TripStatus, int>{};
    for (final status in TripStatus.values) {
      counts[status] = getTripsByStatus(status).length;
    }
    return counts;
  }

  /// Verificar si hay viajes pendientes
  bool get hasPendingTrips => getTripsByStatus(TripStatus.pending).isNotEmpty;

  /// Verificar si hay viajes en curso
  bool get hasInProgressTrips => getTripsByStatus(TripStatus.inProgress).isNotEmpty;

  /// Verificar si hay viajes completados
  bool get hasCompletedTrips => getTripsByStatus(TripStatus.completed).isNotEmpty;
}

/// Notifier para manejar los viajes del grupo
class GroupTripsNotifier extends StateNotifier<GroupTripsState> {
  GroupTripsNotifier() : super(const GroupTripsState());

  /// Cargar viajes del grupo del día actual
  Future<void> loadGroupTripsToday({bool forceRefresh = false}) async {
    // Si ya estamos cargando, no hacer nada
    if (state.isLoading && !forceRefresh) return;

    // Si tenemos datos recientes (menos de 5 minutos) y no es refresh forzado, no recargar
    if (!forceRefresh && 
        state.lastUpdated != null && 
        DateTime.now().difference(state.lastUpdated!).inMinutes < 5) {
      print('📊 GROUP_TRIPS_PROVIDER: Using cached data');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      print('📊 GROUP_TRIPS_PROVIDER: Loading group trips for today...');
      
      final tripsData = await GroupTripsService.getGroupTripsToday();
      
      final trips = tripsData
          .map((tripData) => GroupTripModel.fromJson(tripData))
          .toList();

      // Ordenar por hora de salida
      trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));

      print('📊 GROUP_TRIPS_PROVIDER: Successfully loaded ${trips.length} trips');
      
      state = state.copyWith(
        trips: trips,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('❌ GROUP_TRIPS_PROVIDER: Error loading trips: $e');
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Refrescar datos
  Future<void> refresh() async {
    await loadGroupTripsToday(forceRefresh: true);
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Filtrar viajes por estado
  List<GroupTripModel> getFilteredTrips(List<TripStatus> statuses) {
    return state.trips
        .where((trip) => statuses.contains(trip.status))
        .toList();
  }

  /// Buscar viajes por texto (origen, destino, conductor)
  List<GroupTripModel> searchTrips(String query) {
    if (query.isEmpty) return state.trips;
    
    final lowercaseQuery = query.toLowerCase();
    return state.trips.where((trip) {
      return trip.origin.toLowerCase().contains(lowercaseQuery) ||
             trip.destination.toLowerCase().contains(lowercaseQuery) ||
             trip.driver.fullName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}

/// Provider para los viajes del grupo
final groupTripsProvider = StateNotifierProvider<GroupTripsNotifier, GroupTripsState>((ref) {
  return GroupTripsNotifier();
});