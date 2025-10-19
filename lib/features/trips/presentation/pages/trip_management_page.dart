import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/trip_card.dart';
import '../../../driver/presentation/state/driver_trips_provider.dart';
import '../../data/models/trip_model.dart';
import '../../../../core/config/app_routes.dart';

/// Página de gestión de viajes con tabs para categorías
class TripManagementPage extends ConsumerStatefulWidget {
  const TripManagementPage({super.key});

  @override
  ConsumerState<TripManagementPage> createState() => _TripManagementPageState();
}

class _TripManagementPageState extends ConsumerState<TripManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_currentIndex != _tabController.index) {
        setState(() {
          _currentIndex = _tabController.index;
        });
        _loadTripsForCurrentTab();
      }
    });
    
    // Cargar viajes pendientes al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTripsForCurrentTab();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTripsForCurrentTab() {
    // Siempre cargar todos los viajes del conductor y luego filtrar por estado
    ref.read(driverTripsProvider.notifier).loadMyTrips();
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(driverTripsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Gestión de Viajes',
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
            onPressed: _loadTripsForCurrentTab,
          ),
        ],
      ),
      body: Column(
        children: [
          // Custom Tab Bar
          Container(
            color: const Color(0xFF4CAF50),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.access_time),
                  text: 'Pendientes',
                ),
                Tab(
                  icon: Icon(Icons.directions_car),
                  text: 'En Curso',
                ),
                Tab(
                  icon: Icon(Icons.check_circle),
                  text: 'Completados',
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pendientes
                _buildTripsList(tripsState, 'pending'),
                // En Curso
                _buildTripsList(tripsState, 'in-progress'),
                // Completados
                _buildTripsList(tripsState, 'completed'),
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button para crear viaje
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.driverCreateTrip);
        },
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Crear Viaje'),
      ),
    );
  }

  Widget _buildTripsList(DriverTripsState state, String category) {
    print('🚗 DEBUG: Building trips list for category: $category');
    print('🚗 DEBUG: State - isLoading: ${state.isLoading}, error: ${state.error}');
    print('🚗 DEBUG: Active trips: ${state.activeTrips.length}');
    print('🚗 DEBUG: InProgress trips: ${state.inProgressTrips.length}');  
    print('🚗 DEBUG: Completed trips: ${state.completedTrips.length}');
    
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
              onPressed: _loadTripsForCurrentTab,
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

    final trips = _getTripsForCategory(state, category);

    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyIconForCategory(category),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessageForCategory(category),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubtitleForCategory(category),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadTripsForCurrentTab();
      },
      color: const Color(0xFF4CAF50),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
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
              onTripStarted: () {
                // Cambiar a la pestaña "En Curso" después de un pequeño delay
                print('🚗 DEBUG: Switching to In Progress tab');
                Future.delayed(const Duration(milliseconds: 1500), () {
                  _tabController.animateTo(1); // Índice 1 = "En Curso"
                });
              },
            ),
          );
        },
      ),
    );
  }

  List<TripModel> _getTripsForCategory(DriverTripsState state, String category) {
    print('🚗 DEBUG: Getting trips for category: $category');
    List<TripModel> trips;
    switch (category) {
      case 'pending':
        trips = List.from(state.activeTrips);
        print('🚗 DEBUG: Found ${trips.length} active trips');
        break;
      case 'in-progress':
        trips = List.from(state.inProgressTrips);
        print('🚗 DEBUG: Found ${trips.length} in-progress trips');
        break;
      case 'completed':
        trips = List.from(state.completedTrips);
        print('🚗 DEBUG: Found ${trips.length} completed trips');
        break;
      default:
        return [];
    }

    // Los viajes ya vienen ordenados desde el DriverTripsProvider:
    // 1. Viajes de hoy (ordenados por hora de salida)
    // 2. Viajes futuros (ordenados por fecha de salida)
    // 3. Viajes vencidos NO se incluyen
    
    print('🚗 DEBUG: Category $category has ${trips.length} trips');
    return trips;
  }

  IconData _getEmptyIconForCategory(String category) {
    switch (category) {
      case 'pending':
        return Icons.access_time;
      case 'in-progress':
        return Icons.directions_car;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getEmptyMessageForCategory(String category) {
    switch (category) {
      case 'pending':
        return 'No hay viajes pendientes';
      case 'in-progress':
        return 'No hay viajes en curso';
      case 'completed':
        return 'No hay viajes completados';
      default:
        return 'No hay viajes';
    }
  }

  String _getEmptySubtitleForCategory(String category) {
    switch (category) {
      case 'pending':
        return 'Los viajes que crees aparecerán aquí\nuna vez que sean publicados';
      case 'in-progress':
        return 'Los viajes con pasajeros confirmados\naparecerán en esta sección';
      case 'completed':
        return 'Aquí verás el historial de\nviajes completados';
      default:
        return '';
    }
  }


}