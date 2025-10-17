import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/trip_card.dart';
import '../state/trip_provider.dart';
import '../../data/models/trip_model.dart';

/// Página para mostrar todos los viajes sin categorías
class AllTripsPage extends ConsumerStatefulWidget {
  const AllTripsPage({super.key});

  @override
  ConsumerState<AllTripsPage> createState() => _AllTripsPageState();
}

class _AllTripsPageState extends ConsumerState<AllTripsPage> {
  List<TripModel> allTrips = [];

  @override
  void initState() {
    super.initState();
    // Cargar todos los viajes al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllTrips();
    });
  }

  Future<void> _loadAllTrips() async {
    // Cargar todas las categorías de viajes
    await Future.wait([
      ref.read(tripProvider.notifier).loadPendingTrips(),
      ref.read(tripProvider.notifier).loadInProgressTrips(),
      ref.read(tripProvider.notifier).loadCompletedTrips(),
    ]);
    
    final state = ref.read(tripProvider);
    setState(() {
      allTrips = [
        ...state.pendingTrips,
        ...state.inProgressTrips,
        ...state.completedTrips,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Todos los Viajes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(tripProvider.notifier).loadActiveTrips();
            },
          ),
        ],
      ),
      body: _buildTripsList(tripState),
      // Floating Action Button para crear viaje
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/driver/create-trip');
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTripsList(TripState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar viajes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(tripProvider.notifier).loadActiveTrips();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (allTrips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay viajes disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los viajes que crees o estén\ndisponibles aparecerán aquí',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/driver/create-trip');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Crear Viaje'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllTrips,
      color: const Color(0xFF4CAF50),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allTrips.length,
        itemBuilder: (context, index) {
          final trip = allTrips[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TripCard(
              trip: trip,
              onTap: () {
                // Navegar a detalles del viaje
                Navigator.pushNamed(context, '/trips/details', arguments: trip.id);
              },
              showActions: true, // Mostrar acciones para conductores
              isDriverView: true, // Vista para conductores
            ),
          );
        },
      ),
    );
  }
}