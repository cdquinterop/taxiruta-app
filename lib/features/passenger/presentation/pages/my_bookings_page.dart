import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../state/my_bookings_provider.dart';

/// Página para mostrar las reservas del usuario
class MyBookingsPage extends ConsumerStatefulWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends ConsumerState<MyBookingsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar las reservas al inicializar la página
    Future.microtask(() {
      ref.read(myBookingsProvider.notifier).loadMyBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingsState = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(myBookingsProvider.notifier).loadMyBookings(),
          ),
        ],
      ),
      body: bookingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingsState.error != null
              ? _buildErrorWidget(bookingsState.error!)
              : _buildBookingsList(bookingsState.bookings),
    );
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_seat_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes reservas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Busca viajes disponibles para hacer tu primera reserva',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Separar reservas por estado
    final pendingBookings = bookings.where((b) => BookingStatusX.fromString(b.status) == BookingStatus.pending).toList();
    final confirmedBookings = bookings.where((b) => BookingStatusX.fromString(b.status) == BookingStatus.confirmed).toList();
    final otherBookings = bookings.where((b) => 
      BookingStatusX.fromString(b.status) != BookingStatus.pending && 
      BookingStatusX.fromString(b.status) != BookingStatus.confirmed
    ).toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(myBookingsProvider.notifier).loadMyBookings(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (pendingBookings.isNotEmpty) ...[
            _buildSectionHeader('Pendientes', Colors.orange, Icons.pending_actions),
            ...pendingBookings.map((booking) => _buildBookingCard(booking)),
            const SizedBox(height: 16),
          ],
          if (confirmedBookings.isNotEmpty) ...[
            _buildSectionHeader('Confirmadas', Colors.green, Icons.check_circle),
            ...confirmedBookings.map((booking) => _buildBookingCard(booking)),
            const SizedBox(height: 16),
          ],
          if (otherBookings.isNotEmpty) ...[
            _buildSectionHeader('Historial', Colors.grey, Icons.history),
            ...otherBookings.map((booking) => _buildBookingCard(booking)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    final status = BookingStatusX.fromString(booking.status);
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);
    final canCancel = status == BookingStatus.pending;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  'ID: ${booking.id}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Información del viaje
            Row(
              children: [
                Icon(Icons.event_seat, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  '${booking.seatsRequested} asiento${booking.seatsRequested > 1 ? 's' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '\$${booking.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Fecha de reserva
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Reservado: ${_formatDate(booking.bookingDate)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            
            if (booking.confirmedDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Confirmado: ${_formatDate(booking.confirmedDate!)}',
                    style: TextStyle(color: Colors.green[600]),
                  ),
                ],
              ),
            ],
            
            // Botones de acción
            if (canCancel) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showCancelDialog(booking),
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    label: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.rejected:
        return Colors.red;
      case BookingStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'PENDIENTE';
      case BookingStatus.confirmed:
        return 'CONFIRMADA';
      case BookingStatus.rejected:
        return 'RECHAZADA';
      case BookingStatus.cancelled:
        return 'CANCELADA';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showCancelDialog(BookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: Text(
          '¿Estás seguro de que deseas cancelar tu reserva de ${booking.seatsRequested} asiento${booking.seatsRequested > 1 ? 's' : ''}?\n\n'
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, mantener'),
          ),
          ElevatedButton(
            onPressed: () => _cancelBooking(booking),
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

  Future<void> _cancelBooking(BookingModel booking) async {
    Navigator.pop(context); // Cerrar diálogo
    
    try {
      await ref.read(myBookingsProvider.notifier).cancelBooking(booking.tripId, booking.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reserva cancelada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cancelar la reserva: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar reservas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.read(myBookingsProvider.notifier).loadMyBookings(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}