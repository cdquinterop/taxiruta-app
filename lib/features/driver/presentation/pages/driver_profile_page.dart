import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/driver_profile_models.dart';
import '../../../../providers/driver_profile_provider.dart';
import '../../../../models/vehicle_models.dart';

/// Nueva pantalla de perfil del conductor con información básica editable
class DriverProfilePage extends ConsumerStatefulWidget {
  const DriverProfilePage({super.key});

  @override
  ConsumerState<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends ConsumerState<DriverProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos editables
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _yearsExperienceController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDriverData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _yearsExperienceController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadDriverData() async {
    await ref.read(driverProfileNotifierProvider.notifier).loadDriverData();
    _populateFields();
  }

  void _populateFields() {
    final state = ref.read(driverProfileNotifierProvider);
    if (state.profile != null) {
      final profile = state.profile!;
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
      _yearsExperienceController.text = profile.yearsExperience.toString();
      _licenseNumberController.text = profile.licenseNumber ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverState = ref.watch(driverProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _cancelEdit(),
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => _saveChanges(),
            ),
          ],
        ],
      ),
      body: driverState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : driverState.profile == null
              ? _buildCreateProfileView()
              : _buildProfileView(driverState.profile!),
    );
  }

  Widget _buildCreateProfileView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.person_add,
                size: 48,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Perfil de Conductor No Encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Necesitas crear tu perfil de conductor para comenzar.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _createProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Crear Perfil de Conductor'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView(DriverProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 24),
            _buildStatsCards(profile),
            const SizedBox(height: 24),
            _buildBasicInfoSection(profile),
            const SizedBox(height: 24),
            _buildVehicleSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(DriverProfile profile) {
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
              backgroundImage: profile.profileImageUrl != null 
                  ? NetworkImage(profile.profileImageUrl!) 
                  : null,
              child: profile.profileImageUrl == null
                  ? Text(
                      '${profile.firstName.isNotEmpty ? profile.firstName[0] : ''}${profile.lastName.isNotEmpty ? profile.lastName[0] : ''}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: const TextStyle(
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
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      profile.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      profile.isVerified ? Icons.verified : Icons.pending,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.isVerified ? 'Verificado' : 'Pendiente',
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

  Widget _buildStatsCards(DriverProfile profile) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Viajes',
            value: profile.totalTrips.toString(),
            icon: Icons.directions_car,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Experiencia',
            value: '${profile.yearsExperience} años',
            icon: Icons.calendar_today,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Ganancias',
            value: 'S/. ${profile.totalEarnings.toStringAsFixed(2)}',
            icon: Icons.monetization_on,
            color: Colors.green,
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(DriverProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.green[600]),
              const SizedBox(width: 8),
              const Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'Nombre',
            controller: _firstNameController,
            enabled: _isEditing,
            validator: (value) => value?.isEmpty == true ? 'El nombre es requerido' : null,
          ),
          const SizedBox(height: 12),
          _buildInfoField(
            label: 'Apellido',
            controller: _lastNameController,
            enabled: _isEditing,
            validator: (value) => value?.isEmpty == true ? 'El apellido es requerido' : null,
          ),
          const SizedBox(height: 12),
          _buildInfoField(
            label: 'Email',
            controller: _emailController,
            enabled: _isEditing,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty == true) return 'El email es requerido';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                return 'Email inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildInfoField(
            label: 'Teléfono',
            controller: _phoneController,
            enabled: _isEditing,
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty == true ? 'El teléfono es requerido' : null,
          ),
          const SizedBox(height: 12),
          _buildInfoField(
            label: 'Años de Experiencia',
            controller: _yearsExperienceController,
            enabled: _isEditing,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty == true) return 'La experiencia es requerida';
              if (int.tryParse(value!) == null) return 'Debe ser un número válido';
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildInfoField(
            label: 'Número de Licencia',
            controller: _licenseNumberController,
            enabled: _isEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            border: enabled 
                ? const OutlineInputBorder()
                : const UnderlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: !enabled,
            fillColor: enabled ? null : Colors.grey[50],
          ),
          style: TextStyle(
            fontSize: 14,
            fontWeight: enabled ? FontWeight.normal : FontWeight.w600,
            color: enabled ? null : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSection() {
    final driverState = ref.watch(driverProfileNotifierProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: Colors.green[600]),
              const SizedBox(width: 8),
              const Text(
                'Mi Vehículo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (driverState.vehicle != null)
            _buildVehicleInfo(driverState.vehicle!)
          else
            _buildNoVehicleView(),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(Vehicle vehicle) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildVehicleDetailRow('Marca', vehicle.make),
            ),
            Expanded(
              child: _buildVehicleDetailRow('Modelo', vehicle.model),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildVehicleDetailRow('Año', vehicle.year.toString()),
            ),
            Expanded(
              child: _buildVehicleDetailRow('Color', vehicle.color),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildVehicleDetailRow('Placa', vehicle.licensePlate),
            ),
            Expanded(
              child: _buildVehicleDetailRow('Capacidad', '${vehicle.capacity} personas'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _editVehicle(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
          child: const Text('Editar Vehículo'),
        ),
      ],
    );
  }

  Widget _buildNoVehicleView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No tienes vehículo registrado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _registerVehicle(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text('Registrar Vehículo'),
        ),
      ],
    );
  }

  Widget _buildVehicleDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Métodos de acción
  Future<void> _createProfile() async {
    final success = await ref.read(driverProfileNotifierProvider.notifier).createProfile();
    
    if (success) {
      _populateFields();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil creado exitosamente')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el perfil')),
        );
      }
    }
  }

  void _cancelEdit() {
    _populateFields(); // Restaurar valores originales
    setState(() => _isEditing = false);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final request = DriverProfileUpdateRequest(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      yearsExperience: int.tryParse(_yearsExperienceController.text),
      licenseNumber: _licenseNumberController.text.isEmpty ? null : _licenseNumberController.text,
    );

    final success = await ref.read(driverProfileNotifierProvider.notifier).updateProfile(request);

    if (success) {
      setState(() => _isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado exitosamente')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el perfil')),
        );
      }
    }
  }

  void _registerVehicle() {
    // TODO: Implementar navegación a la pantalla de registro de vehículo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de registro de vehículo')),
    );
  }

  void _editVehicle() {
    // TODO: Implementar navegación a la pantalla de edición de vehículo  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de edición de vehículo')),
    );
  }
}