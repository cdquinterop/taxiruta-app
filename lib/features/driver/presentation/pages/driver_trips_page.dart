import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Modelo de datos para viajes
class TripData {
  final String id;
  final String passenger;
  final String pickup;
  final String destination;
  final String distance;
  final String fare;
  final String? status;
  final String? requestTime;
  final String? estimatedTime;
  final String? date;
  final String? duration;
  final double rating;

  TripData({
    required this.id,
    required this.passenger,
    required this.pickup,
    required this.destination,
    required this.distance,
    required this.fare,
    this.status,
    this.requestTime,
    this.estimatedTime,
    this.date,
    this.duration,
    required this.rating,
  });
}

/// Pantalla de gestión de viajes para conductores
class DriverTripsPage extends ConsumerWidget {
  const DriverTripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Viajes'),
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pendientes', icon: Icon(Icons.access_time)),
              Tab(text: 'En Curso', icon: Icon(Icons.directions_car)),
              Tab(text: 'Completados', icon: Icon(Icons.check_circle)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PendingTripsTab(),
            _ActiveTripsTab(),
            _CompletedTripsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createNewTrip(context),
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Crear Viaje'),
        ),
      ),
    );
  }

  void _createNewTrip(BuildContext context) {
    context.push('/driver/create-trip');
  }
}

/// Tab de viajes pendientes
class _PendingTripsTab extends StatelessWidget {
  const _PendingTripsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Simulado
      itemBuilder: (context, index) {
        return _buildPendingTripCard(context, index);
      },
    );
  }

  Widget _buildPendingTripCard(BuildContext context, int index) {
    final trips = [
      TripData(
        id: 'T001',
        passenger: 'María González',
        pickup: 'Centro Comercial Unicentro',
        destination: 'Universidad Javeriana',
        distance: '8.5 km',
        fare: '\$15,500',
        requestTime: '2 min ago',
        rating: 4.9,
      ),
      TripData(
        id: 'T002',
        passenger: 'Carlos Ruiz',
        pickup: 'Aeropuerto El Dorado',
        destination: 'Zona Rosa',
        distance: '22 km',
        fare: '\$35,000',
        requestTime: '5 min ago',
        rating: 4.7,
      ),
      TripData(
        id: 'T003',
        passenger: 'Ana Sofía Torres',
        pickup: 'Hospital San Ignacio',
        destination: 'Centro Andino',
        distance: '12 km',
        fare: '\$18,500',
        requestTime: '8 min ago',
        rating: 4.8,
      ),
    ];

    if (index >= trips.length) return const SizedBox.shrink();

    final trip = trips[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con información del pasajero
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    trip.passenger.substring(0, 1),
                    style: TextStyle(
                      color: Colors.blue[800],
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
                        trip.passenger,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            trip.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            trip.requestTime ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'PENDIENTE',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Información de la ruta
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.pickup,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        alignment: Alignment.center,
                        child: Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        trip.distance,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.destination,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tarifa estimada y botones de acción
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarifa Estimada',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        trip.fare,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => _rejectTrip(context, trip.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                  ),
                  child: const Text('Rechazar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _acceptTrip(context, trip.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _acceptTrip(BuildContext context, String tripId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viaje $tripId aceptado'),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: Lógica para aceptar viaje
  }

  void _rejectTrip(BuildContext context, String tripId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viaje $tripId rechazado'),
        backgroundColor: Colors.red,
      ),
    );
    // TODO: Lógica para rechazar viaje
  }
}

/// Tab de viajes en curso
class _ActiveTripsTab extends StatelessWidget {
  const _ActiveTripsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 2, // Simulado
      itemBuilder: (context, index) {
        return _buildActiveTripCard(context, index);
      },
    );
  }

  Widget _buildActiveTripCard(BuildContext context, int index) {
    final trips = [
      TripData(
        id: 'T004',
        passenger: 'Roberto Díaz',
        pickup: 'Terminal de Transportes',
        destination: 'Centro Comercial Santafé',
        distance: '15.2 km',
        fare: '\$22,500',
        status: 'En camino al origen',
        estimatedTime: '8 min',
        rating: 4.6,
      ),
      TripData(
        id: 'T005',
        passenger: 'Laura Medina',
        pickup: 'Plaza de Bolívar',
        destination: 'Chapinero Alto',
        distance: '18.7 km',
        fare: '\$28,000',
        status: 'Trasladando pasajero',
        estimatedTime: '15 min',
        rating: 4.9,
      ),
    ];

    if (index >= trips.length) return const SizedBox.shrink();

    final trip = trips[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: Text(
                    trip.passenger.substring(0, 1),
                    style: TextStyle(
                      color: Colors.green[800],
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
                        trip.passenger,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            trip.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'ACTIVO',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Estado actual
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip.status ?? 'En proceso',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'ETA: ${trip.estimatedTime ?? ''}',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Ruta
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.pickup,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        alignment: Alignment.center,
                        child: Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        trip.distance,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.destination,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Acciones y tarifa
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarifa',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        trip.fare,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _callPassenger(context),
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Llamar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[600],
                    side: BorderSide(color: Colors.blue[600]!),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _completeTrip(context, trip.id),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Completar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _callPassenger(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Llamando al pasajero...')),
    );
  }

  void _completeTrip(BuildContext context, String tripId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viaje $tripId completado'),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: Lógica para completar viaje
  }
}

/// Tab de viajes completados
class _CompletedTripsTab extends StatelessWidget {
  const _CompletedTripsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8, // Simulado
      itemBuilder: (context, index) {
        return _buildCompletedTripCard(context, index);
      },
    );
  }

  Widget _buildCompletedTripCard(BuildContext context, int index) {
    final trips = [
      TripData(
        id: 'T006',
        passenger: 'Elena Vargas',
        pickup: 'Aeropuerto Internacional',
        destination: 'Hotel Tequendama',
        distance: '28.5 km',
        fare: '\$42,000',
        date: 'Hoy, 14:30',
        duration: '45 min',
        rating: 5.0,
      ),
      TripData(
        id: 'T007',
        passenger: 'José Martín',
        pickup: 'Universidad Nacional',
        destination: 'Estación TransMilenio',
        distance: '12.8 km',
        fare: '\$16,500',
        date: 'Hoy, 13:15',
        duration: '22 min',
        rating: 4.8,
      ),
    ];

    // Si se necesitan más elementos, reutiliza los datos
    final trip = trips[index % trips.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
        title: Text(
          '${trip.pickup} → ${trip.destination}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${trip.passenger} • ${trip.date ?? 'Fecha no disponible'}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  trip.duration ?? 'N/A',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.straighten, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  trip.distance,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              trip.fare,
              style: TextStyle(
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 2),
                Text(
                  trip.rating.toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // TODO: Mostrar detalles del viaje completado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mostrando detalles del viaje...')),
          );
        },
      ),
    );
  }
}