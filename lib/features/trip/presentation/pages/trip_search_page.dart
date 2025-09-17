import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/custom_card.dart';

/// Pantalla para buscar y filtrar viajes disponibles
class TripSearchPage extends ConsumerStatefulWidget {
  const TripSearchPage({super.key});

  @override
  ConsumerState<TripSearchPage> createState() => _TripSearchPageState();
}

class _TripSearchPageState extends ConsumerState<TripSearchPage> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _passengerCount = 1;
  String _selectedFilter = 'Todos';

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Viajes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Formulario de búsqueda
          _buildSearchForm(),
          
          // Filtros rápidos
          _buildQuickFilters(),
          
          // Lista de viajes encontrados
          Expanded(
            child: _buildTripsList(),
          ),
        ],
      ),
    );
  }

  /// Construye el formulario de búsqueda
  Widget _buildSearchForm() {
    return CustomCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Origen
          TextField(
            controller: _originController,
            decoration: InputDecoration(
              labelText: 'Desde',
              hintText: 'Punto de partida',
              prefixIcon: const Icon(Icons.location_on, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 12),
          
          // Destino
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              labelText: 'Hasta',
              hintText: 'Destino',
              prefixIcon: const Icon(Icons.location_on, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 12),
          
          // Fecha y hora
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    hintText: 'Seleccionar fecha',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Hora',
                    hintText: 'Seleccionar hora',
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onTap: _selectTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Número de pasajeros
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 8),
              const Text('Pasajeros:'),
              const Spacer(),
              IconButton(
                onPressed: _passengerCount > 1
                    ? () => setState(() => _passengerCount--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                '$_passengerCount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _passengerCount < 6
                    ? () => setState(() => _passengerCount++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Botón de búsqueda
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Buscar Viajes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye los filtros rápidos
  Widget _buildQuickFilters() {
    final filters = ['Todos', 'Más baratos', 'Más rápidos', 'Mejor valorados', 'Salida próxima'];
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = selected ? filter : 'Todos';
                });
                _applyFilter(filter);
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  /// Construye la lista de viajes
  Widget _buildTripsList() {
    // Datos simulados - TODO: conectar con el backend
    final trips = _getSimulatedTrips();
    
    if (trips.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No se encontraron viajes',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Intenta ajustar tus criterios de búsqueda',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripCard(context, trip);
      },
    );
  }

  /// Construye una tarjeta de viaje
  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con conductor y rating
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  trip['driverName'].toString().split(' ')[0][0],
                  style: const TextStyle(
                    color: Colors.white,
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
                      trip['driverName'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (starIndex) => Icon(
                            Icons.star,
                            size: 16,
                            color: starIndex < (trip['rating'] as int)
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${trip['rating']}.0 (${trip['reviews']} reseñas)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
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
                  Text(
                    'S/. ${trip['price']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'por persona',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Ruta y horario
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            trip['origin'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            trip['destination'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(trip['departureTime'] as String),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 4),
                      Text('${trip['duration']} min'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Información adicional y botón
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${trip['availableSeats']} asientos',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trip['vehicleType'] as String,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _showTripDetails(context, trip),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Reservar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Selecciona la fecha
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  /// Selecciona la hora
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  /// Realiza la búsqueda
  void _performSearch() {
    if (_originController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa origen y destino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // TODO: Implementar búsqueda real con el backend
    setState(() {
      // Triggear rebuild para mostrar resultados simulados
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buscando viajes disponibles...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Aplica filtro seleccionado
  void _applyFilter(String filter) {
    // TODO: Implementar lógica de filtrado real
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filtro aplicado: $filter'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Muestra diálogo de filtros avanzados
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros Avanzados'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Implementar filtros avanzados
            const Text('Filtros avanzados próximamente'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra detalles del viaje
  void _showTripDetails(BuildContext context, Map<String, dynamic> trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Detalles del Viaje',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              // TODO: Implementar detalles completos del viaje
              const Text('Detalles completos del viaje próximamente'),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navegar a pantalla de reserva
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de reserva próximamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Reservar por S/. ${trip['price']}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Obtiene viajes simulados para prueba
  List<Map<String, dynamic>> _getSimulatedTrips() {
    return [
      {
        'driverName': 'Carlos Mendoza',
        'rating': 5,
        'reviews': 24,
        'price': '18.50',
        'origin': 'San Isidro, Lima',
        'destination': 'Miraflores, Lima',
        'departureTime': '15:30',
        'duration': 25,
        'availableSeats': 3,
        'vehicleType': 'Sedan',
      },
      {
        'driverName': 'Ana López',
        'rating': 4,
        'reviews': 18,
        'price': '22.00',
        'origin': 'La Molina, Lima',
        'destination': 'San Borja, Lima',
        'departureTime': '16:00',
        'duration': 30,
        'availableSeats': 2,
        'vehicleType': 'SUV',
      },
      {
        'driverName': 'Roberto Silva',
        'rating': 5,
        'reviews': 31,
        'price': '15.80',
        'origin': 'Surco, Lima',
        'destination': 'Centro de Lima',
        'departureTime': '16:15',
        'duration': 35,
        'availableSeats': 4,
        'vehicleType': 'Hatchback',
      },
    ];
  }
}