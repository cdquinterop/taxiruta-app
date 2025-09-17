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
  int _currentIndex = 0;

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
    
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
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
          _navigateToRoute('/driver/trips');
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
}