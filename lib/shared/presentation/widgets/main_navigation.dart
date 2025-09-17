import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/state/auth_provider.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/driver/presentation/pages/driver_dashboard_page.dart';
import '../../../features/passenger/presentation/pages/passenger_dashboard_page.dart';

/// Widget de navegación principal que se adapta según el rol del usuario
class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDriver = ref.watch(isDriverProvider);

    // Mostrar pantalla de carga si está autenticando
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Si no está autenticado, mostrar login
    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    // Navegación principal según el rol
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: isDriver ? _driverPages : _passengerPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: isDriver ? _driverBottomNavItems : _passengerBottomNavItems,
      ),
    );
  }

  // Páginas para conductores
  static const List<Widget> _driverPages = [
    DriverDashboardPage(),
    DriverTripsPage(),
    DriverEarningsPage(),
    DriverProfilePage(),
  ];

  // Páginas para pasajeros
  static const List<Widget> _passengerPages = [
    PassengerDashboardPage(),
    PassengerTripsPage(),
    PassengerBookingsPage(),
    PassengerProfilePage(),
  ];

  // Items de navegación para conductores
  static const List<BottomNavigationBarItem> _driverBottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_car),
      label: 'Viajes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on),
      label: 'Ganancias',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  // Items de navegación para pasajeros
  static const List<BottomNavigationBarItem> _passengerBottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'Viajes',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book_online),
      label: 'Reservas',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];
}

// Páginas placeholder que necesitamos implementar

class DriverTripsPage extends StatelessWidget {
  const DriverTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Viajes del Conductor - Por implementar'),
      ),
    );
  }
}

class DriverEarningsPage extends StatelessWidget {
  const DriverEarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Ganancias del Conductor - Por implementar'),
      ),
    );
  }
}

class DriverProfilePage extends StatelessWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Perfil del Conductor - Por implementar'),
      ),
    );
  }
}



class PassengerTripsPage extends StatelessWidget {
  const PassengerTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Viajes del Pasajero - Por implementar'),
      ),
    );
  }
}

class PassengerBookingsPage extends StatelessWidget {
  const PassengerBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Reservas del Pasajero - Por implementar'),
      ),
    );
  }
}

class PassengerProfilePage extends StatelessWidget {
  const PassengerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Perfil del Pasajero - Por implementar'),
      ),
    );
  }
}