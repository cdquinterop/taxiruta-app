import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo de datos para bookings de conductores
class DriverBooking {
  final String id;
  final String passenger;
  final String pickup;
  final String destination;
  final String date;
  final String time;
  final String fare;
  final String status;
  final String? specialRequests;
  final double rating;
  final int passengers;

  DriverBooking({
    required this.id,
    required this.passenger,
    required this.pickup,
    required this.destination,
    required this.date,
    required this.time,
    required this.fare,
    required this.status,
    this.specialRequests,
    required this.rating,
    required this.passengers,
  });
}

/// Pantalla de gestión de bookings para conductores
class DriverBookingsPage extends ConsumerWidget {
  const DriverBookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Reservas'),
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Nuevas', icon: Icon(Icons.notification_important)),
              Tab(text: 'Programadas', icon: Icon(Icons.schedule)),
              Tab(text: 'Historial', icon: Icon(Icons.history)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NewBookingsTab(),
            _ScheduledBookingsTab(),
            _BookingHistoryTab(),
          ],
        ),
      ),
    );
  }
}

/// Tab de nuevas reservas (pendientes de confirmación)
class _NewBookingsTab extends StatelessWidget {
  const _NewBookingsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4, // Simulado
      itemBuilder: (context, index) {
        return _buildNewBookingCard(context, index);
      },
    );
  }

  Widget _buildNewBookingCard(BuildContext context, int index) {
    final bookings = [
      DriverBooking(
        id: 'B001',
        passenger: 'María José García',
        pickup: 'Aeropuerto El Dorado',
        destination: 'Hotel Casa Dann Carlton',
        date: '25 Sep 2025',
        time: '14:30',
        fare: '\$45,000',
        status: 'pending',
        specialRequests: 'Viaje con equipaje pesado',
        rating: 4.9,
        passengers: 2,
      ),
      DriverBooking(
        id: 'B002',
        passenger: 'Carlos Eduardo Ruiz',
        pickup: 'Centro Comercial Andino',
        destination: 'Clínica Fundación Santa Fe',
        date: '25 Sep 2025',
        time: '16:00',
        fare: '\$18,500',
        status: 'pending',
        rating: 4.7,
        passengers: 1,
      ),
      DriverBooking(
        id: 'B003',
        passenger: 'Ana Lucía Torres',
        pickup: 'Universidad Javeriana',
        destination: 'Terminal de Transportes',
        date: '26 Sep 2025',
        time: '08:15',
        fare: '\$22,000',
        status: 'pending',
        specialRequests: 'Prefiere música clásica',
        rating: 4.8,
        passengers: 1,
      ),
      DriverBooking(
        id: 'B004',
        passenger: 'Roberto Silva Mendoza',
        pickup: 'Zona Rosa',
        destination: 'Centro Internacional',
        date: '26 Sep 2025',
        time: '12:45',
        fare: '\$15,000',
        status: 'pending',
        rating: 4.6,
        passengers: 3,
      ),
    ];

    if (index >= bookings.length) return const SizedBox.shrink();

    final booking = bookings[index];

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
                  backgroundColor: Colors.orange[100],
                  child: Text(
                    booking.passenger.substring(0, 1),
                    style: TextStyle(
                      color: Colors.orange[800],
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
                        booking.passenger,
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
                            booking.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.people, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.passengers} pax',
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
                    'NUEVA',
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
            
            // Fecha y hora
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    booking.date,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    booking.time,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
                          booking.pickup,
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
                        'Reserva programada',
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
                          booking.destination,
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
            
            // Solicitudes especiales (si existen)
            if (booking.specialRequests != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.yellow[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.specialRequests!,
                        style: TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Tarifa y botones de acción
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
                        booking.fare,
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
                  onPressed: () => _rejectBooking(context, booking.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                  ),
                  child: const Text('Rechazar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _acceptBooking(context, booking.id),
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

  void _acceptBooking(BuildContext context, String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva $bookingId aceptada'),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: Lógica para aceptar reserva
  }

  void _rejectBooking(BuildContext context, String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva $bookingId rechazada'),
        backgroundColor: Colors.red,
      ),
    );
    // TODO: Lógica para rechazar reserva
  }
}

/// Tab de reservas programadas (confirmadas)
class _ScheduledBookingsTab extends StatelessWidget {
  const _ScheduledBookingsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Simulado
      itemBuilder: (context, index) {
        return _buildScheduledBookingCard(context, index);
      },
    );
  }

  Widget _buildScheduledBookingCard(BuildContext context, int index) {
    final bookings = [
      DriverBooking(
        id: 'B005',
        passenger: 'Elena Rodríguez',
        pickup: 'Hotel Hilton Bogotá',
        destination: 'Aeropuerto El Dorado',
        date: 'Mañana',
        time: '06:00',
        fare: '\$38,000',
        status: 'confirmed',
        specialRequests: 'Viaje temprano - no tocar bocina',
        rating: 4.9,
        passengers: 1,
      ),
      DriverBooking(
        id: 'B006',
        passenger: 'Diego Martínez López',
        pickup: 'Centro Empresarial',
        destination: 'Universidad de los Andes',
        date: 'Mañana',
        time: '14:00',
        fare: '\$25,500',
        status: 'confirmed',
        rating: 4.7,
        passengers: 2,
      ),
      DriverBooking(
        id: 'B007',
        passenger: 'Patricia Jiménez',
        pickup: 'Clínica Country',
        destination: 'Residencias del Norte',
        date: '27 Sep 2025',
        time: '10:30',
        fare: '\$32,000',
        status: 'confirmed',
        rating: 4.8,
        passengers: 1,
      ),
    ];

    if (index >= bookings.length) return const SizedBox.shrink();

    final booking = bookings[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    booking.passenger.substring(0, 1),
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
                        booking.passenger,
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
                            booking.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.people, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.passengers} pax',
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
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'CONFIRMADA',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Fecha y hora destacadas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FECHA',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        booking.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'HORA',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        booking.time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                          booking.pickup,
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
                        booking.fare,
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold,
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
                          booking.destination,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Solicitudes especiales (si existen)
            if (booking.specialRequests != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.specialRequests!,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _contactPassenger(context),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Contactar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue[600],
                      side: BorderSide(color: Colors.blue[600]!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startTrip(context, booking.id),
                    icon: const Icon(Icons.navigation, size: 18),
                    label: const Text('Iniciar Viaje'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _contactPassenger(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contactando al pasajero...')),
    );
  }

  void _startTrip(BuildContext context, String bookingId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Iniciando viaje para reserva $bookingId'),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: Lógica para iniciar viaje
  }
}

/// Tab de historial de reservas
class _BookingHistoryTab extends StatelessWidget {
  const _BookingHistoryTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Simulado
      itemBuilder: (context, index) {
        return _buildHistoryItem(context, index);
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, int index) {
    final historyBookings = [
      DriverBooking(
        id: 'B008',
        passenger: 'Sandra Morales',
        pickup: 'Centro Comercial Gran Estación',
        destination: 'Barrio La Candelaria',
        date: '23 Sep 2025',
        time: '19:15',
        fare: '\$28,500',
        status: 'completed',
        rating: 5.0,
        passengers: 2,
      ),
      DriverBooking(
        id: 'B009',
        passenger: 'Andrés Felipe Castro',
        pickup: 'Universidad Central',
        destination: 'Plaza de las Américas',
        date: '22 Sep 2025',
        time: '16:30',
        fare: '\$21,000',
        status: 'completed',
        rating: 4.6,
        passengers: 1,
      ),
    ];

    // Reutilizar datos para más elementos
    final booking = historyBookings[index % historyBookings.length];

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
          '${booking.pickup} → ${booking.destination}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${booking.passenger} • ${booking.date} ${booking.time}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${booking.passengers} pax',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 2),
                Text(
                  booking.rating.toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          booking.fare,
          style: TextStyle(
            color: Colors.green[600],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // TODO: Mostrar detalles de la reserva histórica
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mostrando detalles de la reserva...')),
          );
        },
      ),
    );
  }
}