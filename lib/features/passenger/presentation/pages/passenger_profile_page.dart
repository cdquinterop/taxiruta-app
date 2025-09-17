import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/state/auth_provider.dart';

/// Pantalla de perfil del usuario
class PassengerProfilePage extends ConsumerWidget {
  const PassengerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context, user),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del perfil
            _buildProfileHeader(user),
            
            const SizedBox(height: 20),
            
            // Estadísticas del usuario
            _buildUserStats(),
            
            const SizedBox(height: 20),
            
            // Opciones del perfil
            _buildProfileOptions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue[600],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nombre del usuario
          Text(
            user.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Email
          Text(
            user.email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Rol
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.directions_car,
              title: 'Viajes Realizados',
              value: '23',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.schedule,
              title: 'Tiempo Activo',
              value: '3 meses',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Sección: Cuenta
          _buildSectionHeader('Mi Cuenta'),
          _buildOptionTile(
            icon: Icons.person_outline,
            title: 'Información Personal',
            subtitle: 'Editar datos personales',
            onTap: () => _editPersonalInfo(context),
          ),
          _buildOptionTile(
            icon: Icons.security,
            title: 'Seguridad',
            subtitle: 'Cambiar contraseña',
            onTap: () => _changePassword(context),
          ),
          _buildOptionTile(
            icon: Icons.payment,
            title: 'Métodos de Pago',
            subtitle: 'Gestionar tarjetas y pagos',
            onTap: () => _managePayments(context),
          ),
          
          const SizedBox(height: 20),
          
          // Sección: Preferencias
          _buildSectionHeader('Preferencias'),
          _buildOptionTile(
            icon: Icons.notifications,
            title: 'Notificaciones',
            subtitle: 'Configurar alertas',
            onTap: () => _configureNotifications(context),
          ),
          _buildOptionTile(
            icon: Icons.language,
            title: 'Idioma',
            subtitle: 'Español',
            onTap: () => _changeLanguage(context),
          ),
          _buildOptionTile(
            icon: Icons.dark_mode_outlined,
            title: 'Tema',
            subtitle: 'Claro',
            onTap: () => _changeTheme(context),
          ),
          
          const SizedBox(height: 20),
          
          // Sección: Soporte
          _buildSectionHeader('Soporte'),
          _buildOptionTile(
            icon: Icons.help_outline,
            title: 'Centro de Ayuda',
            subtitle: 'Preguntas frecuentes',
            onTap: () => _openHelpCenter(context),
          ),
          _buildOptionTile(
            icon: Icons.phone,
            title: 'Contactar Soporte',
            subtitle: 'Obtener ayuda',
            onTap: () => _contactSupport(context),
          ),
          _buildOptionTile(
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Versión 1.0.0',
            onTap: () => _showAbout(context),
          ),
          
          const SizedBox(height: 30),
          
          // Botón de cerrar sesión
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _logout(context, ref),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue[600],
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _editProfile(BuildContext context, user) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de edición en desarrollo')),
    );
  }

  void _editPersonalInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edición de información personal en desarrollo')),
    );
  }

  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambio de contraseña en desarrollo')),
    );
  }

  void _managePayments(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gestión de pagos en desarrollo')),
    );
  }

  void _configureNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuración de notificaciones en desarrollo')),
    );
  }

  void _changeLanguage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambio de idioma en desarrollo')),
    );
  }

  void _changeTheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambio de tema en desarrollo')),
    );
  }

  void _openHelpCenter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Centro de ayuda en desarrollo')),
    );
  }

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacto con soporte en desarrollo')),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TaxiRuta',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.local_taxi, color: Colors.blue[600]),
      children: [
        const Text('Aplicación para compartir viajes de manera segura y económica.'),
      ],
    );
  }

  void _logout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}