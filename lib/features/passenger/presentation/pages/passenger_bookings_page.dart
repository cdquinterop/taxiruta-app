import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla para mostrar las reservas del pasajero
class PassengerBookingsPage extends ConsumerWidget {
  const PassengerBookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Tabs para filtrar reservas
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Activas'),
                  Tab(text: 'Completadas'),
                  Tab(text: 'Canceladas'),
                ],
              ),
            ),
            
            // Contenido de las tabs
            Expanded(
              child: TabBarView(
                children: [
                  _buildActiveBookings(),
                  _buildCompletedBookings(),
                  _buildCancelledBookings(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          bookingId: 'TXR-001',
          driverName: 'Carlos Mendoza',
          origin: 'Centro Comercial Unicentro',
          destination: 'Universidad Nacional',
          date: '17 Sep 2025',
          time: '10:30 AM',
          status: 'Confirmada',
          statusColor: Colors.green,
          price: '\$8,500',
          isActive: true,
        ),
        _buildBookingCard(
          bookingId: 'TXR-002',
          driverName: 'María González',
          origin: 'Aeropuerto El Dorado',
          destination: 'Hotel Bogotá Plaza',
          date: '18 Sep 2025',
          time: '2:15 PM',
          status: 'Pendiente',
          statusColor: Colors.orange,
          price: '\$25,000',
          isActive: true,
        ),
      ],
    );
  }

  Widget _buildCompletedBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          bookingId: 'TXR-003',
          driverName: 'Pedro Ramirez',
          origin: 'Universidad Javeriana',
          destination: 'Centro Andino',
          date: '15 Sep 2025',
          time: '6:00 PM',
          status: 'Completada',
          statusColor: Colors.blue,
          price: '\$12,000',
          isActive: false,
        ),
        _buildBookingCard(
          bookingId: 'TXR-004',
          driverName: 'Ana Morales',
          origin: 'Zona Rosa',
          destination: 'Terminal de Transporte',
          date: '14 Sep 2025',
          time: '8:45 AM',
          status: 'Completada',
          statusColor: Colors.blue,
          price: '\$18,500',
          isActive: false,
        ),
        _buildBookingCard(
          bookingId: 'TXR-005',
          driverName: 'Luis Herrera',
          origin: 'Casa',
          destination: 'Oficina',
          date: '13 Sep 2025',
          time: '7:30 AM',
          status: 'Completada',
          statusColor: Colors.blue,
          price: '\$9,200',
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildCancelledBookings() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookingCard(
          bookingId: 'TXR-006',
          driverName: 'Roberto Silva',
          origin: 'Plaza de Bolívar',
          destination: 'Museo del Oro',
          date: '12 Sep 2025',
          time: '11:00 AM',
          status: 'Cancelada',
          statusColor: Colors.red,
          price: '\$6,500',
          isActive: false,
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Las reservas canceladas se muestran aquí',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard({
    required String bookingId,
    required String driverName,
    required String origin,
    required String destination,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
    required String price,
    required bool isActive,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ID y precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reserva $bookingId',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información del conductor
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: 20,
                  child: Text(
                    driverName[0],
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
                        driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Conductor',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
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
                          origin,
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
                        '~25 min',
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
                          destination,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Fecha y hora
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blue[600]),
                const SizedBox(width: 6),
                Text(date, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 20),
                Icon(Icons.access_time, size: 16, color: Colors.orange[600]),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(fontSize: 14)),
              ],
            ),
            
            if (isActive) ...[
              const SizedBox(height: 16),
              // Botones de acción para reservas activas
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _contactDriver(driverName),
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
                      onPressed: () => _cancelBooking(bookingId),
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Cancelar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _contactDriver(String driverName) {
    // TODO: Implementar contacto con conductor
  }

  void _cancelBooking(String bookingId) {
    // TODO: Implementar cancelación de reserva
  }
}