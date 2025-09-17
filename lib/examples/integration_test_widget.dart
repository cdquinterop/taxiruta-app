import 'package:flutter/material.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/trips/data/services/trip_service.dart';
// import '../features/bookings/data/services/booking_service.dart'; // Para uso futuro
import '../core/error/exceptions.dart';

/// Widget de ejemplo para probar la integración con el backend
class IntegrationTestWidget extends StatefulWidget {
  const IntegrationTestWidget({super.key});

  @override
  State<IntegrationTestWidget> createState() => _IntegrationTestWidgetState();
}

class _IntegrationTestWidgetState extends State<IntegrationTestWidget> {
  final AuthRepository _authRepository = AuthRepository();
  final TripService _tripService = TripService();
  // final BookingService _bookingService = BookingService(); // Para uso futuro
  
  String _status = 'Listo para probar la integración';
  bool _isLoading = false;

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
      _status = 'Probando login...';
    });

    try {
      final response = await _authRepository.login(
        email: 'test@example.com',
        password: 'password123',
      );
      
      setState(() {
        _status = 'Login exitoso! Token: ${response.data.token.substring(0, 20)}...';
      });
    } on ServerException catch (e) {
      setState(() {
        _status = 'Error en login: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testGetTrips() async {
    setState(() {
      _isLoading = true;
      _status = 'Obteniendo viajes...';
    });

    try {
      final trips = await _tripService.getAllTrips();
      
      setState(() {
        _status = 'Viajes obtenidos: ${trips.length} encontrados';
      });
    } on ServerException catch (e) {
      setState(() {
        _status = 'Error al obtener viajes: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testRegister() async {
    setState(() {
      _isLoading = true;
      _status = 'Probando registro...';
    });

    try {
      final response = await _authRepository.register(
        firstName: 'Usuario',
        lastName: 'Prueba',
        email: 'usuario.prueba@example.com',
        phone: '1234567890',
        password: 'password123',
        role: 'PASSENGER',
      );
      
      setState(() {
        _status = 'Registro exitoso! Usuario: ${response.data.user.email}';
      });
    } on ServerException catch (e) {
      setState(() {
        _status = 'Error en registro: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Integración Backend'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estado de la Integración:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pruebas Disponibles:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _testLogin,
              child: const Text('Probar Login'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testRegister,
              child: const Text('Probar Registro'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testGetTrips,
              child: const Text('Obtener Viajes'),
            ),
            const SizedBox(height: 20),
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Los modelos Flutter están sincronizados con el backend Java',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '• Los servicios API están configurados para todos los endpoints',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '• Se manejan las excepciones y errores apropiadamente',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '• La autenticación JWT está implementada',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}