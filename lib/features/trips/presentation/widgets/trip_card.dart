import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/trip_model.dart';
import '../../../driver/presentation/state/driver_trips_provider.dart';

/// Widget para mostrar información de un viaje en tarjeta
class TripCard extends ConsumerWidget {
  final TripModel trip;
  final VoidCallback? onTap;
  final bool showActions;
  final bool isDriverView;
  final bool isCompact;
  final int? realAvailableSeats; // Asientos realmente disponibles calculados

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.showActions = false,
    this.isDriverView = false,
    this.isCompact = false,
    this.realAvailableSeats,
  });

  /// Obtener los asientos disponibles (reales si están calculados, sino los del modelo)
  int _getAvailableSeats() {
    return realAvailableSeats ?? trip.remainingSeats;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isCompact) {
      return _buildCompactCard(context);
    }
    
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con conductor y estado
              Row(
                children: [
                  // Avatar del conductor
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF4CAF50),
                    child: Text(
                      trip.driver.fullName.isNotEmpty 
                          ? trip.driver.fullName[0].toUpperCase()
                          : 'D',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nombre y calificación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.driver.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            // Sistema de estrellas
                            _buildStarRating(4.5), // TODO: Obtener calificación real del conductor
                            const SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Fecha y hora de salida
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDepartureTime(trip.departureTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Estado
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(trip.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(trip.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Ruta
              Row(
                children: [
                  // Origen
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trip.origin,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Línea conectora
              Container(
                margin: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                child: Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ),
              
              // Destino
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red[400],
                    size: 20,
                  ),
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
              
              const SizedBox(height: 16),
              
              // Información del viaje
              Row(
                children: [
                  // Distancia (placeholder)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '8.5 km', // TODO: Calcular distancia real
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Precio
                  Text(
                    'Tarifa Estimada',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Precio y acciones
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${trip.pricePerSeat.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      // Información de asientos disponibles
                      Row(
                        children: [
                          Icon(
                            Icons.event_seat,
                            size: 16,
                            color: _getAvailableSeats() > 0 ? Colors.green[600] : Colors.red[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_getAvailableSeats()} disponible${_getAvailableSeats() == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: _getAvailableSeats() > 0 ? Colors.green[600] : Colors.red[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (showActions) ...[
                    if (isDriverView) ...[
                      // Vista para conductores - Botones dinámicos según estado del viaje
                      ..._buildDriverActionButtons(context, ref),
                    ] else ...[
                      // Vista para pasajeros - Aceptar/Rechazar viajes
                      OutlinedButton(
                        onPressed: () {
                          _showCancelDialog(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Rechazar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _acceptTrip(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el sistema de calificación con estrellas
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    // Agregar estrellas llenas
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(
        Icons.star,
        size: 14,
        color: Colors.amber,
      ));
    }
    
    // Agregar media estrella si corresponde
    if (hasHalfStar && fullStars < 5) {
      stars.add(const Icon(
        Icons.star_half,
        size: 14,
        color: Colors.amber,
      ));
      fullStars++;
    }
    
    // Agregar estrellas vacías
    for (int i = fullStars; i < 5; i++) {
      stars.add(Icon(
        Icons.star_border,
        size: 14,
        color: Colors.grey[400],
      ));
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  /// Formatea la fecha y hora de salida
  String _formatDepartureTime(DateTime departureTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final departureDate = DateTime(departureTime.year, departureTime.month, departureTime.day);
    
    String dateStr;
    if (departureDate == today) {
      dateStr = 'Hoy';
    } else if (departureDate == tomorrow) {
      dateStr = 'Mañana';
    } else {
      // Formatear fecha completa
      List<String> months = [
        '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      dateStr = '${departureTime.day} ${months[departureTime.month]}';
    }
    
    // Formatear hora
    String hour = departureTime.hour.toString().padLeft(2, '0');
    String minute = departureTime.minute.toString().padLeft(2, '0');
    
    return '$dateStr a las $hour:$minute';
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Colors.orange;
      case 'COMPLETED':
        return const Color(0xFF4CAF50);
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'PENDIENTE';
      case 'COMPLETED':
        return 'COMPLETADO';
      case 'CANCELLED':
        return 'CANCELADO';
      default:
        return status;
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Viaje'),
        content: const Text('¿Estás seguro de que quieres cancelar este viaje?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar cancelación del viaje
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Viaje cancelado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _acceptTrip(BuildContext context) {
    // TODO: Implementar aceptación del viaje
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Viaje aceptado'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _editTrip(BuildContext context) {
    // Navegar a página de edición del viaje
    context.push('/trips/edit', extra: trip);
  }

  void _viewTripDetails(BuildContext context) {
    // TODO: Navegar a página de detalles del viaje
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de ver detalles próximamente'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Construye los botones de acción dinámicos para conductores
  List<Widget> _buildDriverActionButtons(BuildContext context, WidgetRef ref) {
    final hasConfirmedBookings = trip.bookings?.any((booking) => booking.status == 'CONFIRMED') ?? false;
    final confirmedSeatsCount = trip.bookings?.where((b) => b.status == 'CONFIRMED')
        .fold<int>(0, (sum, booking) => sum + booking.seatsRequested) ?? 0;
    final isTripFull = confirmedSeatsCount >= trip.availableSeats;

    switch (trip.status.toUpperCase()) {
      case 'ACTIVE':
        if (hasConfirmedBookings) {
          // Viaje activo con reservas confirmadas
          return [
            OutlinedButton.icon(
              onPressed: () => _viewPassengers(context, ref),
              icon: const Icon(Icons.people, size: 16),
              label: const Text('Ver Pasajeros'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2196F3),
                side: const BorderSide(color: Color(0xFF2196F3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: isTripFull ? () => _startTrip(context, ref) : null,
              icon: const Icon(Icons.play_arrow, size: 16),
              label: const Text('Iniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isTripFull ? const Color(0xFF4CAF50) : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ];
        } else {
          // Viaje activo sin reservas confirmadas
          return [
            OutlinedButton.icon(
              onPressed: () => _editTrip(context),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50),
                side: const BorderSide(color: Color(0xFF4CAF50)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _viewTripDetails(context),
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('Ver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ];
        }

      case 'IN_PROGRESS':
        // Viaje en progreso
        return [
          OutlinedButton.icon(
            onPressed: () => _viewPassengers(context, ref),
            icon: const Icon(Icons.people, size: 16),
            label: const Text('Ver Pasajeros'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2196F3),
              side: const BorderSide(color: Color(0xFF2196F3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _completeTrip(context, ref),
            icon: const Icon(Icons.check_circle, size: 16),
            label: const Text('Completar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ];

      case 'COMPLETED':
        // Viaje completado - solo ver
        return [
          ElevatedButton.icon(
            onPressed: () => _viewTripDetails(context),
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('Ver Detalles'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ];

      default:
        // Fallback - botones por defecto
        return [
          OutlinedButton.icon(
            onPressed: () => _editTrip(context),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Editar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4CAF50),
              side: const BorderSide(color: Color(0xFF4CAF50)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _viewTripDetails(context),
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('Ver'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ];
    }
  }

  /// Construye una versión compacta del card para vistas rápidas
  Widget _buildCompactCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar más pequeño
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF4CAF50),
                child: Text(
                  trip.driver.fullName.isNotEmpty 
                      ? trip.driver.fullName[0].toUpperCase()
                      : 'D',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Información del viaje
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Conductor y estado
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip.driver.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(trip.status),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(trip.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Ruta
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF4CAF50),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trip.origin,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.flag,
                          color: Colors.red,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            trip.destination,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Precio y acciones compactas
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${trip.pricePerSeat.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  // Asientos disponibles
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event_seat,
                        size: 12,
                        color: _getAvailableSeats() > 0 ? Colors.green[600] : Colors.red[600],
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${_getAvailableSeats()}',
                        style: TextStyle(
                          fontSize: 10,
                          color: _getAvailableSeats() > 0 ? Colors.green[600] : Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (isDriverView && showActions) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _editTrip(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.blue[300]!, width: 1),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.blue[600],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => _viewTripDetails(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green[300]!, width: 1),
                            ),
                            child: Icon(
                              Icons.visibility,
                              size: 14,
                              color: Colors.green[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ver pasajeros del viaje
  void _viewPassengers(BuildContext context, WidgetRef ref) async {
    // Cargar pasajeros del viaje
    await ref.read(driverTripsProvider.notifier).loadTripPassengers(trip.id);
    
    if (!context.mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _TripPassengersModal(trip: trip, ref: ref),
    );
  }

  /// Iniciar viaje
  void _startTrip(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Iniciar Viaje'),
          content: const Text('¿Estás seguro de que deseas iniciar este viaje?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                final success = await ref.read(driverTripsProvider.notifier).startTrip(trip.id);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                          ? 'Viaje iniciado exitosamente' 
                          : 'Error al iniciar el viaje'),
                      backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('Iniciar'),
            ),
          ],
        );
      },
    );
  }

  /// Completar viaje
  void _completeTrip(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Completar Viaje'),
          content: const Text('¿Estás seguro de que deseas completar este viaje?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                final success = await ref.read(driverTripsProvider.notifier).completeTrip(trip.id);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                          ? 'Viaje completado exitosamente' 
                          : 'Error al completar el viaje'),
                      backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text('Completar'),
            ),
          ],
        );
      },
    );
  }
}

/// Modal para mostrar pasajeros de un viaje
class _TripPassengersModal extends ConsumerWidget {
  final TripModel trip;
  final WidgetRef ref;
  
  const _TripPassengersModal({required this.trip, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(driverTripsProvider);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle del modal
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.people, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pasajeros - Viaje #${trip.id}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Lista de pasajeros
          if (tripsState.isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (tripsState.tripPassengers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No hay pasajeros confirmados para este viaje',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: tripsState.tripPassengers.length,
                itemBuilder: (context, index) {
                  final passenger = tripsState.tripPassengers[index];
                  return _buildPassengerCard(passenger);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                booking.passenger.fullName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.blue[600],
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
                    booking.passenger.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.airline_seat_recline_normal, 
                           color: Colors.grey[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${booking.seatsRequested} asiento${booking.seatsRequested > 1 ? 's' : ''}',
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
            ElevatedButton.icon(
              onPressed: () => _callPassenger(booking.passenger.phoneNumber),
              icon: const Icon(Icons.phone, size: 18),
              label: const Text('Llamar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callPassenger(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      print('Error al intentar llamar: $e');
    }
  }
}