import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/state/auth_provider.dart';
import '../../../features/auth/domain/entities/user.dart';

/// Bottom Navigation principal que se adapta según el rol del usuario
class MainNavigationPage extends ConsumerStatefulWidget {
  final Widget child;
  
  const MainNavigationPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    if (authState.isLoading) {
      return widget.child;
    }
    
    if (authState.user == null) {
      // Si no hay usuario, mostrar solo el contenido sin navigation
      return widget.child;
    }
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigation(authState.user!),
    );
  }

  Widget _buildBottomNavigation(User user) {
    final isDriver = user.role.toUpperCase() == 'DRIVER';
    final currentRoute = GoRouterState.of(context).uri.path;
    
    // Determinar el índice activo basándose en la ruta actual
    int activeIndex = _getActiveIndex(currentRoute, isDriver);
    
    return BottomNavigationBar(
      currentIndex: activeIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        _navigateToPage(index, isDriver);
      },
      items: _getNavigationItems(isDriver),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems(bool isDriver) {
    if (isDriver) {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Mis Viajes',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Reservas',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];
    } else {
      return [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Mis Reservas',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ];
    }
  }

  void _navigateToPage(int index, bool isDriver) {
    if (isDriver) {
      switch (index) {
        case 0:
          _navigateToRoute('/driver/dashboard');
          break;
        case 1:
          _navigateToRoute('/trips/management');
          break;
        case 2:
          _navigateToRoute('/driver/bookings');
          break;
        case 3:
          _navigateToRoute('/driver/profile');
          break;
      }
    } else {
      switch (index) {
        case 0:
          _navigateToRoute('/passenger/dashboard');
          break;
        case 1:
          _navigateToRoute('/passenger/search');
          break;
        case 2:
          _navigateToRoute('/passenger/bookings');
          break;
        case 3:
          _navigateToRoute('/passenger/profile');
          break;
      }
    }
  }

  void _navigateToRoute(String route) {
    context.go(route);
  }

  int _getActiveIndex(String currentRoute, bool isDriver) {
    if (isDriver) {
      if (currentRoute.startsWith('/driver/dashboard')) return 0;
      if (currentRoute.startsWith('/trips/management') || 
          currentRoute.startsWith('/trips/all') ||
          currentRoute.startsWith('/driver/trips')) return 1;
      if (currentRoute.startsWith('/driver/bookings')) return 2;
      if (currentRoute.startsWith('/driver/profile')) return 3;
    } else {
      if (currentRoute.startsWith('/passenger/dashboard')) return 0;
      if (currentRoute.startsWith('/passenger/search')) return 1;
      if (currentRoute.startsWith('/passenger/bookings')) return 2;
      if (currentRoute.startsWith('/passenger/profile')) return 3;
    }
    return 0; // Default to first tab
  }
}