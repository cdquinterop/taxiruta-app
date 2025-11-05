import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../shared/presentation/pages/main_navigation_page.dart';
import '../../features/trip/presentation/pages/trip_search_page.dart';
import '../../features/passenger/presentation/pages/passenger_dashboard_page.dart';
import '../../features/passenger/presentation/pages/passenger_search_page.dart';
import '../../features/passenger/presentation/pages/passenger_bookings_page.dart';
import '../../features/passenger/presentation/pages/passenger_profile_page.dart';
import '../../features/driver/presentation/pages/driver_dashboard_page.dart';
import '../../features/driver/presentation/pages/driver_trips_page.dart';
import '../../features/driver/presentation/pages/driver_bookings_page.dart';
import '../../features/driver/presentation/pages/driver_profile_page_improved.dart';
import '../../features/driver/presentation/pages/create_trip_page.dart';
import '../../features/driver/presentation/pages/group_trips_page.dart';
import '../../features/trips/presentation/pages/trip_management_page.dart';
import '../../features/trips/presentation/pages/all_trips_page.dart';
import '../../features/trips/presentation/pages/edit_trip_page.dart';
import '../../features/trips/data/models/trip_model.dart';

/// Configuración de rutas de la aplicación TaxiRuta
class AppRoutes {
  // Rutas de autenticación
  static const String login = '/login';
  static const String register = '/register';
  
  // Rutas principales
  static const String home = '/home';
  static const String tripSearch = '/trip-search';
  
  // Rutas para pasajeros
  static const String passengerDashboard = '/passenger/dashboard';
  static const String passengerSearch = '/passenger/search';
  static const String passengerBookings = '/passenger/bookings';
  static const String passengerProfile = '/passenger/profile';
  
  // Rutas para conductores
  static const String driverDashboard = '/driver/dashboard';
  static const String driverTrips = '/driver/trips';
  static const String driverBookings = '/driver/bookings';
  static const String driverProfile = '/driver/profile';
  static const String driverCreateTrip = '/driver/create-trip';
  static const String driverGroupTrips = '/driver/group-trips';
  static const String tripManagement = '/trips/management';
  static const String allTrips = '/trips/all';
  static const String editTrip = '/trips/edit';

  /// Configuración del router principal
  static GoRouter get router => _router;
  
  static final _router = GoRouter(
    initialLocation: login,
    routes: [
      // Autenticación
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Página principal con navegación (redirige al dashboard del pasajero)
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainNavigationPage(
          child: PassengerDashboardPage(),
        ),
      ),
      
      // Búsqueda de viajes
      GoRoute(
        path: tripSearch,
        name: 'trip-search',
        builder: (context, state) => const TripSearchPage(),
      ),
      
      // Rutas para pasajeros
      GoRoute(
        path: passengerDashboard,
        name: 'passenger-dashboard',
        builder: (context, state) => const MainNavigationPage(
          child: PassengerDashboardPage(),
        ),
      ),
      GoRoute(
        path: passengerSearch,
        name: 'passenger-search',
        builder: (context, state) => const MainNavigationPage(
          child: PassengerSearchPage(),
        ),
      ),
      GoRoute(
        path: passengerBookings,
        name: 'passenger-bookings',
        builder: (context, state) => const MainNavigationPage(
          child: PassengerBookingsPage(),
        ),
      ),
      GoRoute(
        path: passengerProfile,
        name: 'passenger-profile',
        builder: (context, state) => const MainNavigationPage(
          child: PassengerProfilePage(),
        ),
      ),
      
      // Rutas para conductores
      GoRoute(
        path: driverDashboard,
        name: 'driver-dashboard',
        builder: (context, state) => const MainNavigationPage(
          child: DriverDashboardPage(),
        ),
      ),
      GoRoute(
        path: driverTrips,
        name: 'driver-trips',
        builder: (context, state) => const MainNavigationPage(
          child: DriverTripsPage(),
        ),
      ),
      GoRoute(
        path: driverBookings,
        name: 'driver-bookings',
        builder: (context, state) => const MainNavigationPage(
          child: DriverBookingsPage(),
        ),
      ),
      GoRoute(
        path: driverProfile,
        name: 'driver-profile',
        builder: (context, state) => const MainNavigationPage(
          child: DriverProfilePage(),
        ),
      ),
      GoRoute(
        path: driverGroupTrips,
        name: 'driver-group-trips',
        builder: (context, state) => const MainNavigationPage(
          child: GroupTripsPage(),
        ),
      ),
      GoRoute(
        path: driverCreateTrip,
        name: 'driver-create-trip',
        builder: (context, state) => const CreateTripPage(),
      ),
      GoRoute(
        path: tripManagement,
        name: 'trip-management',
        builder: (context, state) => const MainNavigationPage(
          child: TripManagementPage(),
        ),
      ),
      GoRoute(
        path: allTrips,
        name: 'all-trips',
        builder: (context, state) => const MainNavigationPage(
          child: AllTripsPage(),
        ),
      ),
      GoRoute(
        path: editTrip,
        name: 'edit-trip',
        builder: (context, state) {
          final trip = state.extra as TripModel;
          return EditTripPage(trip: trip);
        },
      ),
    ],
    redirect: (context, state) {
      // TODO: Implementar lógica de redirección basada en autenticación
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La página que buscas no existe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}