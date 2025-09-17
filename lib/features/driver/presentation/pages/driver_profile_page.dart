import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo de datos para información del vehículo
class VehicleInfo {
  final String make;
  final String model;
  final String year;
  final String color;
  final String plate;
  final String type;
  final int capacity;

  VehicleInfo({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.plate,
    required this.type,
    required this.capacity,
  });
}

/// Modelo de datos para documentos del conductor
class DriverDocument {
  final String name;
  final String status;
  final String expiryDate;
  final IconData icon;

  DriverDocument({
    required this.name,
    required this.status,
    required this.expiryDate,
    required this.icon,
  });
}

/// Pantalla de perfil del conductor
class DriverProfilePage extends ConsumerWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildStatsCards(context),
            const SizedBox(height: 24),
            _buildVehicleInfo(context),
            const SizedBox(height: 24),
            _buildDocumentsSection(context),
            const SizedBox(height: 24),
            _buildEarningsSection(context),
            const SizedBox(height: 24),
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  /// Encabezado del perfil con foto y información básica
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.green[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green[100],
              child: Text(
                'CM',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Carlos Mendoza',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Conductor Profesional',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      '4.8',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.verified, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Verificado',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tarjetas de estadísticas del conductor
  Widget _buildStatsCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Viajes',
            value: '1,247',
            icon: Icons.directions_car,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Años',
            value: '3.5',
            icon: Icons.calendar_today,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Rating',
            value: '4.8',
            icon: Icons.star,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
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
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Información del vehículo
  Widget _buildVehicleInfo(BuildContext context) {
    final vehicle = VehicleInfo(
      make: 'Toyota',
      model: 'Corolla',
      year: '2022',
      color: 'Blanco',
      plate: 'ABC-123',
      type: 'Sedán',
      capacity: 4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Información del Vehículo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _editVehicle(context),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_car,
                      color: Colors.blue[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${vehicle.make} ${vehicle.model}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${vehicle.year} • ${vehicle.color} • ${vehicle.type}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildVehicleDetail('Placa', vehicle.plate),
                  ),
                  Expanded(
                    child: _buildVehicleDetail('Capacidad', '${vehicle.capacity} pasajeros'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Sección de documentos
  Widget _buildDocumentsSection(BuildContext context) {
    final documents = [
      DriverDocument(
        name: 'Licencia de Conducir',
        status: 'Vigente',
        expiryDate: '15 Mar 2026',
        icon: Icons.credit_card,
      ),
      DriverDocument(
        name: 'SOAT',
        status: 'Vigente',
        expiryDate: '20 Dic 2025',
        icon: Icons.security,
      ),
      DriverDocument(
        name: 'Tecnomecánica',
        status: 'Vigente',
        expiryDate: '10 Feb 2026',
        icon: Icons.build,
      ),
      DriverDocument(
        name: 'Tarjeta de Propiedad',
        status: 'Vigente',
        expiryDate: 'N/A',
        icon: Icons.description,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Documentos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: documents.asMap().entries.map((entry) {
              final index = entry.key;
              final doc = entry.value;
              final isLast = index == documents.length - 1;
              
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        doc.icon,
                        color: Colors.green[600],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      doc.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      doc.expiryDate != 'N/A' 
                          ? 'Vence: ${doc.expiryDate}'
                          : 'Sin vencimiento',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        doc.status,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast) Divider(height: 1, color: Colors.grey[200]),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Sección de ganancias
  Widget _buildEarningsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Ganancias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _viewDetailedEarnings(context),
              child: const Text('Ver detalles'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEarningsCard(
                title: 'Hoy',
                amount: '\$127,500',
                subtitle: '8 viajes',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEarningsCard(
                title: 'Esta Semana',
                amount: '\$845,200',
                subtitle: '42 viajes',
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEarningsCard(
                title: 'Este Mes',
                amount: '\$3,420,800',
                subtitle: '167 viajes',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEarningsCard(
                title: 'Total',
                amount: '\$28,567,300',
                subtitle: '1,247 viajes',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsCard({
    required String title,
    required String amount,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// Sección de configuraciones
  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuración',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildSettingItem(
                icon: Icons.notifications,
                title: 'Notificaciones',
                subtitle: 'Gestionar notificaciones',
                onTap: () => _manageNotifications(context),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.location_on,
                title: 'Ubicación',
                subtitle: 'Configurar servicios de ubicación',
                onTap: () => _manageLocation(context),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.payment,
                title: 'Métodos de Pago',
                subtitle: 'Gestionar forma de cobro',
                onTap: () => _managePaymentMethods(context),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.help,
                title: 'Ayuda y Soporte',
                subtitle: 'Centro de ayuda',
                onTap: () => _getHelp(context),
              ),
              const Divider(height: 1),
              _buildSettingItem(
                icon: Icons.logout,
                title: 'Cerrar Sesión',
                subtitle: 'Salir de la aplicación',
                onTap: () => _logout(context),
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red[600] : Colors.grey[600],
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red[600] : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  // Métodos de acción
  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo editor de perfil...')),
    );
  }

  void _editVehicle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo editor de vehículo...')),
    );
  }

  void _viewDetailedEarnings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mostrando detalles de ganancias...')),
    );
  }

  void _manageNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo configuración de notificaciones...')),
    );
  }

  void _manageLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo configuración de ubicación...')),
    );
  }

  void _managePaymentMethods(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo métodos de pago...')),
    );
  }

  void _getHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Abriendo centro de ayuda...')),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implementar lógica de logout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cerrando sesión...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}