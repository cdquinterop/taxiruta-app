import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/trip_model.dart';
import '../../../driver/presentation/state/driver_trips_provider.dart';
import '../../../bookings/data/models/booking_model.dart';

/// Widget para mostrar información de un viaje en tarjeta
class TripCard extends ConsumerWidget {
  final TripModel trip;
  final VoidCallback? onTap;
  final bool showActions;
  final bool isDriverView;
  final bool isCompact;
  final int? realAvailableSeats; // Asientos realmente disponibles calculados
  final VoidCallback? onTripStarted; // Callback cuando se inicia un viaje

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.showActions = false,
    this.isDriverView = false,
    this.isCompact = false,
    this.realAvailableSeats,
    this.onTripStarted,
  });

  /// Obtener los asientos disponibles calculando correctamente las reservas confirmadas
  int _getAvailableSeats() {
    // Si hay realAvailableSeats del backend, usarlo (más confiable)
    if (realAvailableSeats != null) {
      print('🚗 DEBUG TripCard ${trip.id}: Usando realAvailableSeats=$realAvailableSeats');
      return realAvailableSeats!;
    }
    
    // Calcular basado en bookings confirmados
    int confirmedSeats = 0;
    if (trip.bookings != null) {
      for (var booking in trip.bookings!) {
        if (booking.status == 'CONFIRMED') {
          confirmedSeats += booking.seatsRequested;
        }
      }
    }
    
    final available = trip.availableSeats - confirmedSeats;
    print('🚗 DEBUG TripCard ${trip.id}: availableSeats=${trip.availableSeats}, confirmedSeats=$confirmedSeats, calculated=$available');
    return available.clamp(0, trip.availableSeats);
  }

  /// Obtener los asientos reservados confirmados
  int _getReservedSeats() {
    int confirmedSeats = 0;
    if (trip.bookings != null) {
      for (var booking in trip.bookings!) {
        if (booking.status == 'CONFIRMED') {
          confirmedSeats += booking.seatsRequested;
        }
      }
    }
    return confirmedSeats;
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
              
              // Ruta horizontal
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    // Origen
                    const Icon(
                      Icons.radio_button_checked,
                      color: Color(0xFF4CAF50),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        trip.origin,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E2E2E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Flecha
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                    // Destino
                    Expanded(
                      flex: 2,
                      child: Text(
                        trip.destination,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E2E2E),
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                      size: 18,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Información del viaje: Precio y asientos horizontal
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4CAF50).withOpacity(0.1),
                      const Color(0xFF4CAF50).withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    // Precio
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio por asiento',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${trip.pricePerSeat.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Separador vertical
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    // Asientos disponibles
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Asientos disponibles',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.event_seat,
                                size: 20,
                                color: _getAvailableSeats() > 0 ? Colors.blue[600] : Colors.red[600],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_getAvailableSeats()} de ${trip.availableSeats}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getAvailableSeats() > 0 ? Colors.blue[600] : Colors.red[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Botones de acción más grandes y claros
              if (showActions) ...[
                Row(
                  children: [
                    if (isDriverView) ...[
                      // Vista para conductores - Botones dinámicos según estado del viaje
                      ..._buildDriverActionButtons(context, ref),
                    ] else ...[
                      // Vista para pasajeros - Botones más grandes y claros
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showCancelDialog(context);
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text(
                            'Rechazar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red[600],
                            side: BorderSide(color: Colors.red[300]!, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 48),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _acceptTrip(context);
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text(
                            'Aceptar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 48),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
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
      case 'IN_PROGRESS':
        return const Color(0xFF2196F3); // Azul para en curso
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
      case 'IN_PROGRESS':
        return 'EN CURSO';
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
    
    print('🚗 TripCard ${trip.id}: Status=${trip.status}, Bookings=${trip.bookings?.length ?? 0}, Confirmed=$confirmedSeatsCount/${trip.availableSeats}, Full=$isTripFull');

    switch (trip.status.toUpperCase()) {
      case 'ACTIVE':
        if (hasConfirmedBookings) {
          // Viaje activo con reservas confirmadas
          return [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _viewPassengers(context, ref),
                icon: const Icon(Icons.people, size: 18),
                label: const Text(
                  'Pasajeros',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2196F3),
                  side: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton.icon(
                  onPressed: isTripFull ? () => _startTrip(context, ref) : null,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isTripFull ? Icons.play_arrow_rounded : Icons.play_disabled,
                      size: 18,
                      key: ValueKey(isTripFull),
                    ),
                  ),
                  label: const Text(
                    'Iniciar',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTripFull 
                        ? const Color(0xFF4CAF50) 
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    minimumSize: const Size(0, 48),
                    elevation: isTripFull ? 2 : 0,
                  ),
                ),
              ),
            ),
          ];
        } else {
          // Viaje activo sin reservas confirmadas
          return [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _editTrip(context),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'Editar',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50),
                  side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _viewTripDetails(context),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text(
                  'Ver',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(0, 48),
                  elevation: 2,
                ),
              ),
            ),
          ];
        }

      case 'IN_PROGRESS':
        // Viaje en progreso
        return [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _viewPassengers(context, ref),
              icon: const Icon(Icons.people, size: 18),
              label: const Text(
                'Pasajeros', 
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2196F3),
                side: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _completeTrip(context, ref),
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text(
                'Completar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: const Size(0, 48),
                elevation: 2,
              ),
            ),
          ),
        ];

      case 'COMPLETED':
        // Viaje completado - solo ver
        return [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _viewTripDetails(context),
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text(
                'Ver Detalles',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
        ];

      default:
        // Fallback - botones por defecto
        return [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _editTrip(context),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text(
                'Editar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50),
                side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: const Size(0, 48),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _viewTripDetails(context),
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text(
                'Ver',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                minimumSize: const Size(0, 48),
                elevation: 2,
              ),
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
                        '${_getAvailableSeats()}/${trip.availableSeats}',
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
    print('🚗 DEBUG: _viewPassengers called for trip ${trip.id}');
    
    // Mostrar el modal inmediatamente - los datos se cargarán dentro del modal
    print('🚗 DEBUG: Showing modal immediately for trip ${trip.id}');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        print('🚗 DEBUG: Modal builder called');
        return _TripPassengersModal(trip: trip);
      },
    ).then((_) {
      print('🚗 DEBUG: Modal closed');
    });
  }

  /// Iniciar viaje
  void _startTrip(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Iniciar Viaje'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de que deseas iniciar este viaje?'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El viaje se moverá a la pestaña "En Curso"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                // Mostrar indicador de carga temporal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Iniciando viaje...'),
                      ],
                    ),
                    backgroundColor: Colors.blue,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                
                final success = await ref.read(driverTripsProvider.notifier).startTrip(trip.id);
                
                if (context.mounted) {
                  // Cerrar el snackbar de carga
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  
                  // Mostrar resultado
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            success ? Icons.check_circle : Icons.error,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(success 
                                ? '¡Viaje iniciado! Revisa la pestaña "En Curso"' 
                                : 'Error al iniciar el viaje. Intenta nuevamente'),
                          ),
                        ],
                      ),
                      backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  
                  // Si el viaje se inició exitosamente, notificar al padre para cambiar de pestaña
                  if (success && onTripStarted != null) {
                    print('🚗 DEBUG: Trip started successfully, notifying parent to switch tab');
                    // Agregar un pequeño delay para mejor UX
                    await Future.delayed(const Duration(milliseconds: 500));
                    onTripStarted!();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Iniciar'),
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
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Completar Viaje'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de que deseas completar este viaje?'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El viaje se marcará como completado',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                // Mostrar indicador de carga
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Completando viaje...'),
                      ],
                    ),
                    backgroundColor: Colors.blue,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                
                final success = await ref.read(driverTripsProvider.notifier).completeTrip(trip.id);
                
                if (context.mounted) {
                  // Cerrar el snackbar de carga
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  
                  // Mostrar resultado
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            success ? Icons.check_circle : Icons.error,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(success 
                                ? '¡Viaje completado exitosamente!' 
                                : 'Error al completar el viaje. Intenta nuevamente'),
                          ),
                        ],
                      ),
                      backgroundColor: success ? const Color(0xFF4CAF50) : Colors.red,
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.check_circle, size: 18),
              label: const Text('Completar'),
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
  
  const _TripPassengersModal({required this.trip});

  int _getAvailableSeats() {
    // Si hay realAvailableSeats del backend, usarlo (más confiable)
    if (trip.realAvailableSeats != null) {
      print('🚗 DEBUG Modal: Usando realAvailableSeats=${trip.realAvailableSeats}');
      return trip.realAvailableSeats!;
    }
    
    // Calcular basado en bookings confirmados
    int confirmedSeats = 0;
    if (trip.bookings != null) {
      for (var booking in trip.bookings!) {
        if (booking.status == 'CONFIRMED') {
          confirmedSeats += booking.seatsRequested;
        }
      }
    }
    
    final available = trip.availableSeats - confirmedSeats;
    print('🚗 DEBUG Modal: availableSeats=${trip.availableSeats}, confirmedSeats=$confirmedSeats, calculated=$available');
    return available.clamp(0, trip.availableSeats);
  }

  int _getReservedSeats() {
    int confirmedSeats = 0;
    if (trip.bookings != null) {
      for (var booking in trip.bookings!) {
        if (booking.status == 'CONFIRMED') {
          confirmedSeats += booking.seatsRequested;
        }
      }
    }
    return confirmedSeats;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(driverTripsProvider);
    
    print('🚗 DEBUG: Building _TripPassengersModal, isLoading: ${tripsState.isLoading}, passengers: ${tripsState.tripPassengers.length}');
    
    // Cargar pasajeros cuando se construye el modal por primera vez
    ref.listen(driverTripsProvider, (previous, next) {
      // Solo para debugging
      print('🚗 DEBUG: Modal state changed - isLoading: ${next.isLoading}, passengers: ${next.tripPassengers.length}');
    });
    
    // Cargar datos si no se han cargado aún
    if (tripsState.tripPassengers.isEmpty && !tripsState.isLoading) {
      // Ejecutar la carga en el siguiente frame para evitar problemas
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('🚗 DEBUG: Loading passengers in modal for trip ${trip.id}');
        ref.read(driverTripsProvider.notifier).loadTripPassengers(trip.id);
      });
    }
    
    // Modal profesional para conductores
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        minHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle del modal
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header del modal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pasajeros Confirmados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${trip.origin} → ${trip.destination}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${tripsState.tripPassengers.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Resumen de asientos para debug
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${trip.availableSeats}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${tripsState.tripPassengers.fold<int>(0, (sum, p) => sum + (p.seatsRequested))}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      'Reservados',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${_getAvailableSeats()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Disponibles',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contenido del modal
          if (tripsState.isLoading)
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue.shade600,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando pasajeros...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else if (tripsState.tripPassengers.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin pasajeros confirmados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aún no hay reservas confirmadas para este viaje',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tripsState.tripPassengers.length,
                itemBuilder: (context, index) {
                  final passenger = tripsState.tripPassengers[index];
                  return _buildPassengerCard(context, passenger);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(BuildContext context, passenger) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar del pasajero
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  passenger.passenger.fullName.isNotEmpty 
                      ? passenger.passenger.fullName.substring(0, 1).toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información del pasajero
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    passenger.passenger.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.airline_seat_recline_extra,
                        color: Colors.green.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${passenger.seatsRequested} asiento${passenger.seatsRequested != 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Botón de llamar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _callPassenger(context, passenger.passenger.phoneNumber),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text(
                  'Llamar',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callPassenger(BuildContext context, String phoneNumber) async {
    try {
      // Para testing en desarrollo, solo mostrar el número
      print('🚗 DEBUG: Calling passenger at $phoneNumber');
      
      // Por ahora, mostrar un diálogo informativo
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Llamar Pasajero'),
          content: Text('Se iniciará una llamada a:\n$phoneNumber'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Llamar'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error al intentar llamar: $e');
    }
  }
}