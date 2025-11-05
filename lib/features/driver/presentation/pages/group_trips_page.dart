import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/group_trip_model.dart';
import '../../../../providers/group_trips_provider.dart';
import '../../../../providers/group_provider.dart';

/// Página para mostrar los viajes del grupo del día actual
class GroupTripsPage extends ConsumerStatefulWidget {
  const GroupTripsPage({super.key});

  @override
  ConsumerState<GroupTripsPage> createState() => _GroupTripsPageState();
}

class _GroupTripsPageState extends ConsumerState<GroupTripsPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cargar datos del grupo y viajes
      ref.read(groupProvider.notifier).loadCurrentGroup();
      ref.read(groupTripsProvider.notifier).loadGroupTripsToday();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(groupProvider);
    final groupTripsState = ref.watch(groupTripsProvider);
    final currentGroup = groupState.currentGroup;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Viajes del Grupo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (currentGroup != null)
              Text(
                currentGroup.name,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(groupTripsProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              text: 'Todos',
              icon: Icon(Icons.list, size: 16),
            ),
            Tab(
              text: 'Pendientes',
              icon: Icon(Icons.schedule, size: 16),
            ),
            Tab(
              text: 'En Curso',
              icon: Icon(Icons.directions_car, size: 16),
            ),
            Tab(
              text: 'Completados',
              icon: Icon(Icons.check_circle, size: 16),
            ),
          ],
        ),
      ),
      body: currentGroup == null
          ? _buildNoGroupView()
          : groupTripsState.isLoading && groupTripsState.trips.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : groupTripsState.error != null
                  ? _buildErrorView(groupTripsState.error!, ref)
                  : Column(
                      children: [
                        _buildStatsHeader(groupTripsState),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildTripsTab(groupTripsState.trips, 'todos'),
                              _buildTripsTab(
                                groupTripsState.getTripsByStatus(TripStatus.pending),
                                'pendientes',
                              ),
                              _buildTripsTab(
                                groupTripsState.getTripsByStatus(TripStatus.inProgress),
                                'en curso',
                              ),
                              _buildTripsTab(
                                groupTripsState.getTripsByStatus(TripStatus.completed),
                                'completados',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildNoGroupView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No perteneces a ningún grupo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Únete a un grupo para ver los viajes de tus compañeros',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Volver al Dashboard'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar viajes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(groupTripsProvider.notifier).clearError();
              ref.read(groupTripsProvider.notifier).loadGroupTripsToday();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(GroupTripsState state) {
    final tripCounts = state.tripCounts;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            state.trips.length.toString(),
            Colors.blue[600]!,
            Icons.list,
          ),
          _buildStatItem(
            'Pendientes',
            tripCounts[TripStatus.pending].toString(),
            Colors.orange[600]!,
            Icons.schedule,
          ),
          _buildStatItem(
            'En Curso',
            tripCounts[TripStatus.inProgress].toString(),
            Colors.green[600]!,
            Icons.directions_car,
          ),
          _buildStatItem(
            'Completados',
            tripCounts[TripStatus.completed].toString(),
            Colors.grey[600]!,
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTripsTab(List<GroupTripModel> trips, String tabName) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trip_origin,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay viajes $tabName hoy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los viajes de tus compañeros aparecerán aquí',
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
        await ref.read(groupTripsProvider.notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return _buildTripCard(trip);
        },
      ),
    );
  }

  Widget _buildTripCard(GroupTripModel trip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con conductor y estado
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getStatusColor(trip.status),
                  radius: 16,
                  child: Text(
                    trip.driver.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.driver.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Conductor',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(trip.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatusColor(trip.status)),
                  ),
                  child: Text(
                    trip.status.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(trip.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información de ruta y horario
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.trip_origin, size: 16, color: Colors.green[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trip.origin,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.red[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trip.destination,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.blue[600]),
                        const SizedBox(width: 4),
                        Text(
                          trip.formattedDepartureTime,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      trip.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información adicional
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.purple[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${trip.remainingSeats}/${trip.availableSeats} disponibles',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: Colors.green[600]),
                    Text(
                      '\$${trip.pricePerSeat.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (trip.description != null && trip.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trip.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
            
            if (trip.bookings.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Pasajeros confirmados: ${trip.bookings.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.pending:
        return Colors.orange[600]!;
      case TripStatus.inProgress:
        return Colors.green[600]!;
      case TripStatus.completed:
        return Colors.grey[600]!;
      case TripStatus.cancelled:
        return Colors.red[600]!;
    }
  }
}