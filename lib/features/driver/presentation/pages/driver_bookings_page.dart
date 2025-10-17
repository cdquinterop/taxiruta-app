import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../state/driver_bookings_provider.dart';
import '../state/driver_trips_provider.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../trips/data/models/trip_model.dart';
import 'package:intl/intl.dart';

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
              Tab(text: 'En Progreso', icon: Icon(Icons.directions_car)),
              Tab(text: 'Historial', icon: Icon(Icons.history)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NewBookingsTab(),
            _ScheduledBookingsTab(),
            _InProgressTripsTab(),
            _BookingHistoryTab(),
          ],
        ),
      ),
    );
  }
}

/// Tab de nuevas reservas (pendientes de confirmación)
class _NewBookingsTab extends ConsumerStatefulWidget {
  const _NewBookingsTab();

  @override
  ConsumerState<_NewBookingsTab> createState() => _NewBookingsTabState();
}

class _NewBookingsTabState extends ConsumerState<_NewBookingsTab> {
  @override
  void initState() {
    super.initState();
    // Cargar reservas pendientes al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverBookingsProvider.notifier).loadPendingBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingsState = ref.watch(driverBookingsProvider);
    
    if (bookingsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      );
    }

    if (bookingsState.error != null) {
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
              'Error al cargar reservas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bookingsState.error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(driverBookingsProvider.notifier).loadPendingBookings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (bookingsState.pendingBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notification_important_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay reservas pendientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Las nuevas reservas de pasajeros\naparecerán aquí para su confirmación',
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
        await ref.read(driverBookingsProvider.notifier).loadPendingBookings();
      },
      color: Colors.green[600],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookingsState.pendingBookings.length,
        itemBuilder: (context, index) {
          final booking = bookingsState.pendingBookings[index];
          return _buildBookingCard(context, booking, ref);
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking, WidgetRef ref) {
    // Formatear fecha y hora
    final bookingDate = DateFormat('dd MMM yyyy').format(booking.bookingDate);
    final bookingTime = DateFormat('HH:mm').format(booking.bookingDate);

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
                    booking.passenger.fullName.isNotEmpty 
                        ? booking.passenger.fullName.substring(0, 1).toUpperCase() 
                        : 'U',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    booking.passenger.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
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
            
            // Fecha y hora de la reserva
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
                    bookingDate,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    bookingTime,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Información de la reserva
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ruta del viaje
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${booking.tripOrigin ?? 'Origen no disponible'} → ${booking.tripDestination ?? 'Destino no disponible'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Asientos solicitados
                  Row(
                    children: [
                      Icon(Icons.event_seat, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${booking.seatsRequested} ${booking.seatsRequested == 1 ? 'asiento' : 'asientos'} solicitados',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Teléfono del pasajero
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        booking.passenger.phoneNumber,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Email del pasajero (información adicional)
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking.passenger.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tarifa y botones de acción
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precio Total',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${booking.totalPrice.toStringAsFixed(0)}',
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
                  onPressed: () => _rejectBooking(context, booking, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                  ),
                  child: const Text('Rechazar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _acceptBooking(context, booking, ref),
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

  Future<void> _acceptBooking(BuildContext context, BookingModel booking, WidgetRef ref) async {
    try {
      final success = await ref.read(driverBookingsProvider.notifier).acceptBooking(booking);
      
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reserva de ${booking.passenger.fullName} aceptada exitosamente'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (context.mounted) {
          final errorState = ref.read(driverBookingsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorState.error ?? 'Error al aceptar la reserva'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _rejectBooking(BuildContext context, BookingModel booking, WidgetRef ref) async {
    try {
      final success = await ref.read(driverBookingsProvider.notifier).rejectBooking(booking);
      
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reserva de ${booking.passenger.fullName} rechazada'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (context.mounted) {
          final errorState = ref.read(driverBookingsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorState.error ?? 'Error al rechazar la reserva'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

/// Tab de reservas programadas (confirmadas)
class _ScheduledBookingsTab extends ConsumerStatefulWidget {
  const _ScheduledBookingsTab();

  @override
  ConsumerState<_ScheduledBookingsTab> createState() => _ScheduledBookingsTabState();
}

class _ScheduledBookingsTabState extends ConsumerState<_ScheduledBookingsTab> {
  @override
  void initState() {
    super.initState();
    // Cargar viajes del conductor al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverTripsProvider.notifier).loadMyTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(driverTripsProvider);
    
    if (tripsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      );
    }

    if (tripsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar viajes',
              style: TextStyle(fontSize: 18, color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            Text(
              tripsState.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(driverTripsProvider.notifier).loadMyTrips();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (tripsState.activeTrips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tienes viajes programados',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Los viajes con reservas confirmadas aparecerán aquí',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(driverTripsProvider.notifier).loadMyTrips(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tripsState.activeTrips.length,
        itemBuilder: (context, index) {
          final trip = tripsState.activeTrips[index];
          return _buildScheduledTripCard(trip);
        },
      ),
    );
  }

  Widget _buildScheduledTripCard(TripModel trip) {
    // Calcular asientos reservados confirmados
    final confirmedSeats = trip.bookings?.where((b) => b.status == 'CONFIRMED')
        .fold<int>(0, (sum, booking) => sum + booking.seatsRequested) ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado del viaje
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, color: Colors.green[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'PROGRAMADO',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Viaje #${trip.id}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$confirmedSeats/${trip.availableSeats} asientos',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Ruta del viaje
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${trip.origin} → ${trip.destination}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Fecha y hora
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
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
                        _formatDate(trip.departureTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                        _formatTime(trip.departureTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Precio por asiento
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '\$${trip.pricePerSeat.toStringAsFixed(0)} por asiento',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showTripPassengers(trip),
                    icon: const Icon(Icons.people, size: 18),
                    label: const Text('Ver Pasajeros'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: confirmedSeats > 0 
                        ? () => _startTripConfirm(trip.id)
                        : null,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Iniciar Viaje'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Mañana';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showTripPassengers(TripModel trip) async {
    // Cargar pasajeros del viaje
    await ref.read(driverTripsProvider.notifier).loadTripPassengers(trip.id);
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _TripPassengersModal(trip: trip),
    );
  }

  void _startTripConfirm(int tripId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar Viaje'),
        content: const Text('¿Estás seguro de que deseas iniciar este viaje? Una vez iniciado, no podrás cancelarlo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );

    if (result == true) {
      final success = await ref.read(driverTripsProvider.notifier).startTrip(tripId);
      
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Viaje iniciado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

/// Modal para mostrar pasajeros de un viaje
class _TripPassengersModal extends ConsumerWidget {
  final TripModel trip;
  
  const _TripPassengersModal({required this.trip});

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

  Widget _buildPassengerCard(BookingModel booking) {
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

/// Tab de viajes en progreso
class _InProgressTripsTab extends ConsumerStatefulWidget {
  const _InProgressTripsTab();

  @override
  ConsumerState<_InProgressTripsTab> createState() => _InProgressTripsTabState();
}

class _InProgressTripsTabState extends ConsumerState<_InProgressTripsTab> {
  @override
  void initState() {
    super.initState();
    // Cargar viajes del conductor al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverTripsProvider.notifier).loadMyTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(driverTripsProvider);
    
    if (tripsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      );
    }

    if (tripsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar viajes',
              style: TextStyle(fontSize: 18, color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            Text(
              tripsState.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(driverTripsProvider.notifier).loadMyTrips();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (tripsState.inProgressTrips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tienes viajes en progreso',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Los viajes iniciados aparecerán aquí',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(driverTripsProvider.notifier).loadMyTrips(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tripsState.inProgressTrips.length,
        itemBuilder: (context, index) {
          final trip = tripsState.inProgressTrips[index];
          return _buildInProgressTripCard(trip);
        },
      ),
    );
  }

  Widget _buildInProgressTripCard(TripModel trip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado del viaje
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car, color: Colors.blue[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'EN PROGRESO',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Viaje #${trip.id}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Ruta del viaje
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${trip.origin} → ${trip.destination}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Fecha y hora
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(trip.departureTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPassengersList(trip),
                    icon: const Icon(Icons.people, size: 18),
                    label: const Text('Ver Pasajeros'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: ref.watch(driverTripsProvider).isCompletingTrip
                        ? null
                        : () => _completeTrip(trip.id),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Completar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      return 'Hoy ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Mañana ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showPassengersList(TripModel trip) async {
    // Cargar pasajeros del viaje
    await ref.read(driverTripsProvider.notifier).loadTripPassengers(trip.id);
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _PassengersListModal(trip: trip),
    );
  }

  void _completeTrip(int tripId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Completar Viaje'),
        content: const Text('¿Estás seguro de que deseas marcar este viaje como completado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
            ),
            child: const Text('Completar'),
          ),
        ],
      ),
    );

    if (result == true) {
      final success = await ref.read(driverTripsProvider.notifier).completeTrip(tripId);
      
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Viaje completado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}

/// Modal para mostrar la lista de pasajeros de un viaje
class _PassengersListModal extends ConsumerWidget {
  final TripModel trip;
  
  const _PassengersListModal({required this.trip});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(driverTripsProvider);
    final passengers = tripsState.tripPassengers;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
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
                Icon(Icons.people, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pasajeros del Viaje #${trip.id}',
                    style: const TextStyle(
                      fontSize: 18,
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
          Expanded(
            child: tripsState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4CAF50),
                    ),
                  )
                : passengers.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay pasajeros confirmados',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: passengers.length,
                        itemBuilder: (context, index) {
                          final passenger = passengers[index];
                          return _buildPassengerCard(context, passenger, index + 1);
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPassengerCard(BuildContext context, BookingModel passenger, int number) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              radius: 25,
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${passenger.seatsRequested} asiento${passenger.seatsRequested > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    passenger.passenger.phoneNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón de llamar
            ElevatedButton.icon(
              onPressed: () => _makePhoneCall(passenger.passenger.phoneNumber),
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
  
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Handle error - could show a snackbar or dialog
      debugPrint('Could not launch phone call to $phoneNumber');
    }
  }
}