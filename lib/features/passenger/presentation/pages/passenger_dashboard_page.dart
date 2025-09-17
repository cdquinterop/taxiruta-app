import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_provider.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/stats_widget.dart';

/// Dashboard principal para pasajeros
class PassengerDashboardPage extends ConsumerWidget {
  const PassengerDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${user?.firstName ?? 'Pasajero'}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navegar a notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navegar a configuración
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Búsqueda rápida de viajes
            _buildQuickSearchCard(context),
            const SizedBox(height: 16),
            
            // Estadísticas del pasajero
            _buildPassengerStatsSection(context),
            const SizedBox(height: 16),
            
            // Viajes programados
            _buildScheduledTripsSection(context),
            const SizedBox(height: 16),
            
            // Acciones rápidas
            _buildQuickActionsSection(context),
            const SizedBox(height: 16),
            
            // Historial reciente
            _buildRecentTripsSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar a búsqueda de viajes
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.search),
        label: const Text('Buscar Viaje'),
      ),
    );
  }

  /// Construye la tarjeta de búsqueda rápida
  Widget _buildQuickSearchCard(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Buscar Viaje',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: '¿A dónde quieres ir?',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            readOnly: true,
            onTap: () {
              // TODO: Navegar a búsqueda detallada
            },
          ),
        ],
      ),
    );
  }

  /// Construye la sección de estadísticas del pasajero
  Widget _buildPassengerStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu Actividad',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsWidget(
                title: 'Viajes Este Mes',
                value: '8', // TODO: obtener datos reales
                icon: Icons.directions_car,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsWidget(
                title: 'Viajes Totales',
                value: '42', // TODO: obtener datos reales
                icon: Icons.history,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye la sección de viajes programados
  Widget _buildScheduledTripsSection(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximos Viajes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Ver todos los viajes programados
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Lista de viajes programados (simulados)
          _buildScheduledTripItem(
            context,
            'Oficina → Casa',
            'Hoy, 18:30',
            'Confirmado',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildScheduledTripItem(
            context,
            'Casa → Centro Comercial',
            'Mañana, 14:00',
            'Pendiente',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  /// Construye un item de viaje programado
  Widget _buildScheduledTripItem(
    BuildContext context,
    String route,
    String time,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: statusColor,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de acciones rápidas
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Reservar',
                Icons.book_online,
                Colors.blue,
                () {
                  // TODO: Navegar a crear reserva
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Historial',
                Icons.history,
                Colors.purple,
                () {
                  // TODO: Navegar a historial
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Perfil',
                Icons.person,
                Colors.green,
                () {
                  // TODO: Navegar a perfil
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye un botón de acción rápida
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de viajes recientes
  Widget _buildRecentTripsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Viajes Recientes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navegar a historial completo
              },
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Lista de viajes recientes (simulados)
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3, // TODO: obtener datos reales
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildRecentTripItem(context, index);
          },
        ),
      ],
    );
  }

  /// Construye un item de viaje reciente
  Widget _buildRecentTripItem(BuildContext context, int index) {
    // Datos simulados - TODO: reemplazar con datos reales
    final trips = [
      {
        'origin': 'San Isidro',
        'destination': 'Miraflores',
        'date': 'Ayer 16:45',
        'cost': 'S/. 18.50',
        'rating': 5,
        'driver': 'Carlos M.',
      },
      {
        'origin': 'Casa',
        'destination': 'Centro de Lima',
        'date': '15 Mar 14:20',
        'cost': 'S/. 22.00',
        'rating': 4,
        'driver': 'Ana L.',
      },
      {
        'origin': 'Aeropuerto',
        'destination': 'Hotel',
        'date': '12 Mar 09:30',
        'cost': 'S/. 35.80',
        'rating': 5,
        'driver': 'Roberto P.',
      },
    ];

    final trip = trips[index];

    return CustomCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            (trip['driver']! as String).split(' ')[0][0], // Primera letra del nombre
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${trip['origin']} → ${trip['destination']}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${trip['date']} - ${trip['driver']}'),
        trailing: Text(
          trip['cost']! as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // TODO: Mostrar detalles del viaje
        },
      ),
    );
  }
}