import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import '../../../../shared/presentation/widgets/custom_app_bar.dart';
import '../../data/models/trip_model.dart';

import '../state/trip_provider.dart';

/// Página para editar un viaje existente
class EditTripPage extends ConsumerStatefulWidget {
  final TripModel trip;

  const EditTripPage({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<EditTripPage> createState() => _EditTripPageState();
}

class _EditTripPageState extends ConsumerState<EditTripPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _priceController;
  late final TextEditingController _availableSeatsController;
  late final TextEditingController _descriptionController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los datos del viaje
    _fromController = TextEditingController(text: widget.trip.origin);
    _toController = TextEditingController(text: widget.trip.destination);
    _dateController = TextEditingController(text: _formatDate(widget.trip.departureTime));
    _timeController = TextEditingController(text: _formatTime(widget.trip.departureTime));
    _priceController = TextEditingController(text: widget.trip.pricePerSeat.toStringAsFixed(0));
    _availableSeatsController = TextEditingController(text: widget.trip.availableSeats.toString());
    _descriptionController = TextEditingController(text: widget.trip.description ?? '');
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    _availableSeatsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Viaje'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del viaje
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información del Viaje',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Origen
                      TextFormField(
                        controller: _fromController,
                        decoration: const InputDecoration(
                          labelText: 'Origen',
                          hintText: 'Punto de partida',
                          prefixIcon: Icon(Icons.location_on, color: Colors.green),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El origen es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Destino
                      TextFormField(
                        controller: _toController,
                        decoration: const InputDecoration(
                          labelText: 'Destino',
                          hintText: 'Punto de llegada',
                          prefixIcon: Icon(Icons.flag, color: Colors.red),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El destino es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Fecha y Hora
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha',
                                hintText: 'DD/MM/YYYY',
                                prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: widget.trip.departureTime,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  _dateController.text = _formatDate(date);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'La fecha es requerida';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText: 'Hora',
                                hintText: 'HH:MM',
                                prefixIcon: Icon(Icons.access_time, color: Colors.orange),
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(widget.trip.departureTime),
                                );
                                if (time != null) {
                                  _timeController.text = _formatTime(DateTime(2000, 1, 1, time.hour, time.minute));
                                }
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'La hora es requerida';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Detalles del viaje
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detalles del Viaje',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Precio y Asientos disponibles
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Precio (\$)',
                                hintText: '25000',
                                prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'El precio es requerido';
                                }
                                final price = double.tryParse(value);
                                if (price == null || price <= 0) {
                                  return 'Precio inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _availableSeatsController,
                              decoration: const InputDecoration(
                                labelText: 'Asientos',
                                hintText: '4',
                                prefixIcon: Icon(Icons.event_seat, color: Colors.blue),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Los asientos son requeridos';
                                }
                                final seats = int.tryParse(value);
                                if (seats == null || seats <= 0 || seats > 8) {
                                  return 'Asientos inválidos (1-8)';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción (Opcional)',
                          hintText: 'Información adicional sobre el viaje...',
                          prefixIcon: Icon(Icons.description, color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        maxLength: 500,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateTrip,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Actualizar Viaje'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Parsear fecha y hora
      final dateParts = _dateController.text.split('/');
      final timeParts = _timeController.text.split(':');
      
      final departureDate = DateTime(
        int.parse(dateParts[2]), // año
        int.parse(dateParts[1]), // mes
        int.parse(dateParts[0]), // día
        int.parse(timeParts[0]), // hora
        int.parse(timeParts[1]), // minuto
      );

      await ref.read(tripProvider.notifier).updateTrip(
        id: widget.trip.id,
        origin: _fromController.text.trim(),
        destination: _toController.text.trim(),
        departureTime: departureDate,
        pricePerSeat: double.parse(_priceController.text),
        availableSeats: int.parse(_availableSeatsController.text),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Viaje actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true); // Retornar true para indicar que se actualizó
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar viaje: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}