import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_ruta/core/config/app_routes.dart';

void main() {
  group('AppRoutes Tests', () {
    test('should have all required driver routes', () {
      // Verificar que todas las rutas de conductor están definidas
      expect(AppRoutes.driverDashboard, '/driver/dashboard');
      expect(AppRoutes.driverTrips, '/driver/trips');
      expect(AppRoutes.driverBookings, '/driver/bookings');
      expect(AppRoutes.driverProfile, '/driver/profile');
    });

    test('should have all required passenger routes', () {
      // Verificar que todas las rutas de pasajero están definidas
      expect(AppRoutes.passengerDashboard, '/passenger/dashboard');
      expect(AppRoutes.passengerSearch, '/passenger/search');
      expect(AppRoutes.passengerBookings, '/passenger/bookings');
      expect(AppRoutes.passengerProfile, '/passenger/profile');
    });

    test('should have authentication routes', () {
      // Verificar rutas de autenticación
      expect(AppRoutes.login, '/login');
      expect(AppRoutes.register, '/register');
    });

    test('router should be properly configured', () {
      // Verificar que el router se puede instanciar
      final router = AppRoutes.router;
      expect(router, isNotNull);
      expect(router.routerDelegate, isNotNull);
      expect(router.routeInformationParser, isNotNull);
    });
  });
}