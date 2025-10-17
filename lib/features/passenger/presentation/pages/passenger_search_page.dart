import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/passenger_trip_provider.dart';
import '../state/my_bookings_provider.dart';
import '../../../trips/data/models/trip_model.dart';

/// Pantalla de búsqueda de viajes para pasajeros
class PassengerSearchPage extends ConsumerStatefulWidget {
  const PassengerSearchPage({super.key});

  @override
  ConsumerState<PassengerSearchPage> createState() => _PassengerSearchPageState();
}

class _PassengerSearchPageState extends ConsumerState<PassengerSearchPage> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _useFilters = false;

  @override
  void initState() {
    super.initState();
    // Cargar todos los viajes disponibles al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(passengerTripProvider.notifier).loadAvailableTrips();
      // Cargar también las reservas del usuario para validación
      ref.read(myBookingsProvider.notifier).loadMyBookings();
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Viajes'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulario de búsqueda
            _buildSearchForm(),
            
            const SizedBox(height: 24),
            
            // Lista de viajes disponibles
            _buildAvailableTrips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buscar Viaje',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Campo origen
            TextField(
              controller: _originController,
              decoration: InputDecoration(
                labelText: 'Origen',
                prefixIcon: const Icon(Icons.location_on, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Campo destino
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Destino',
                prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Fecha y hora (opcionales)
            const Text(
              'Filtros opcionales:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Seleccionar fecha',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedDate != null ? Colors.black : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Seleccionar hora',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedTime != null ? Colors.black : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Botón de búsqueda
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _searchTrips,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buscar Viajes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTrips() {
    final tripState = ref.watch(passengerTripProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Viajes Disponibles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (tripState.error != null)
          Card(
            color: Colors.red[100],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                tripState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        else if (tripState.isLoading || tripState.isSearching)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (tripState.availableTrips.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No se encontraron viajes disponibles. Intenta modificar tu búsqueda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          // Lista de viajes reales
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tripState.availableTrips.length,
            itemBuilder: (context, index) {
              final trip = tripState.availableTrips[index];
              return _buildTripCard(trip);
            },
          ),
      ],
    );
  }

  Widget _buildTripCard(TripModel trip) {
    // Calcular asientos realmente disponibles
    final realAvailableSeats = ref.read(passengerTripProvider.notifier).calculateRealAvailableSeats(trip);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con conductor y rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        trip.driver.fullName[0],
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.driver.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Conductor verificado',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStarRating(4.5),
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
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$${trip.pricePerSeat.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Ruta
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trip.origin,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
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
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información adicional y botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          _formatDepartureTime(trip.departureTime),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event_seat, 
                          size: 16, 
                          color: realAvailableSeats > 0 ? Colors.green[600] : Colors.red[600]
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$realAvailableSeats asiento${realAvailableSeats == 1 ? '' : 's'} disponible${realAvailableSeats == 1 ? '' : 's'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: realAvailableSeats > 0 ? Colors.green[600] : Colors.red[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: realAvailableSeats > 0 ? () => _reserveTrip(trip) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: realAvailableSeats > 0 ? Colors.green[600] : Colors.grey[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(realAvailableSeats > 0 ? 'Reservar' : 'Sin asientos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _searchTrips() {
    // Si no hay filtros específicos, buscar por destino solamente si está lleno
    String? origin = _originController.text.isNotEmpty ? _originController.text : null;
    String? destination = _destinationController.text.isNotEmpty ? _destinationController.text : null;
    
    // Combinar fecha y hora seleccionadas
    DateTime? departureDateTime;
    if (_selectedDate != null && _selectedTime != null) {
      departureDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    } else if (_selectedDate != null) {
      departureDateTime = _selectedDate;
    }
    
    // Buscar viajes usando el provider
    ref.read(passengerTripProvider.notifier).searchTrips(
      origin: origin,
      destination: destination,
      departureDate: departureDateTime,
    );
  }

  void _reserveTrip(TripModel trip) {
    // Verificar si ya tiene una reserva activa para este viaje
    final hasActiveBooking = ref.read(myBookingsProvider.notifier).hasActiveBookingForTrip(trip.id);
    
    if (hasActiveBooking) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ya tienes una reserva activa para este viaje. Revisa tus reservas en "Mis Reservas".'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Ver Reservas',
            textColor: Colors.white,
            onPressed: () {
              // TODO: Navegar a la página de reservas
              Navigator.pushNamed(context, '/passenger/bookings');
            },
          ),
        ),
      );
      return;
    }
    
    // Calcular asientos realmente disponibles
    final realAvailableSeats = ref.read(passengerTripProvider.notifier).calculateRealAvailableSeats(trip);
    
    if (realAvailableSeats <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay asientos disponibles para este viaje'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    int selectedSeats = 1;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Reservar con ${trip.driver.fullName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del viaje
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.route, color: Colors.blue[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${trip.origin} → ${trip.destination}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.orange[600], size: 20),
                        const SizedBox(width: 8),
                        Text(_formatDepartureTime(trip.departureTime)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Selector de asientos
              Text(
                'Selecciona cantidad de asientos:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Disponibles: $realAvailableSeats',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Precio: \$${trip.pricePerSeat.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Selector de cantidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: selectedSeats > 1 
                              ? () => setDialogState(() => selectedSeats--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.blue[600],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedSeats.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: selectedSeats < realAvailableSeats 
                              ? () => setDialogState(() => selectedSeats++)
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.blue[600],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Total
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[800],
                            ),
                          ),
                          Text(
                            '\$${(trip.pricePerSeat * selectedSeats).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => _confirmBooking(trip, selectedSeats),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Reservar $selectedSeats asiento${selectedSeats > 1 ? 's' : ''}'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _confirmBooking(TripModel trip, int selectedSeats) async {
    Navigator.pop(context); // Cerrar diálogo
    
    try {
      final booking = await ref.read(passengerTripProvider.notifier).bookTrip(
        tripId: trip.id,
        seatsRequested: selectedSeats,
      );
      
      if (booking != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Reserva confirmada! $selectedSeats asiento${selectedSeats > 1 ? 's' : ''} con ${trip.driver.fullName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        // Actualizar la lista de viajes disponibles
        ref.read(passengerTripProvider.notifier).loadAvailableTrips();
      }
    } catch (e) {
      String errorMessage;
      
      if (e.toString().contains('Ya tienes una reserva para este viaje')) {
        errorMessage = 'Ya tienes una reserva activa para este viaje. Revisa tus reservas existentes.';
      } else if (e.toString().contains('Asientos insuficientes')) {
        errorMessage = 'No hay suficientes asientos disponibles. Por favor, selecciona menos asientos.';
      } else if (e.toString().contains('Viaje no encontrado')) {
        errorMessage = 'Este viaje ya no está disponible. Actualizando lista de viajes...';
        ref.read(passengerTripProvider.notifier).loadAvailableTrips();
      } else {
        errorMessage = 'Error al realizar la reserva. Por favor, intenta nuevamente.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
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
}