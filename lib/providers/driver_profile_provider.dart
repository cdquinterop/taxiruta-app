import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/driver_profile_models.dart';
import '../models/vehicle_models.dart';
import '../models/change_password_models.dart';
import '../services/driver_profile_service.dart';

/// Estado del perfil del conductor
class DriverProfileState {
  final DriverProfile? profile;
  final Vehicle? vehicle;
  final bool isLoading;
  final String? error;

  const DriverProfileState({
    this.profile,
    this.vehicle,
    this.isLoading = false,
    this.error,
  });

  DriverProfileState copyWith({
    DriverProfile? profile,
    Vehicle? vehicle,
    bool? isLoading,
    String? error,
  }) {
    return DriverProfileState(
      profile: profile ?? this.profile,
      vehicle: vehicle ?? this.vehicle,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notificador del estado del perfil del conductor
class DriverProfileNotifier extends StateNotifier<DriverProfileState> {
  DriverProfileNotifier() : super(const DriverProfileState());

  /// Carga todos los datos del conductor (perfil y vehículo)
  Future<void> loadDriverData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Cargar perfil y vehículo en paralelo
      final results = await Future.wait([
        DriverProfileService.getMyProfile(),
        DriverProfileService.getMyVehicle(),
      ]);

      final profile = results[0] as DriverProfile?;
      final vehicle = results[1] as Vehicle?;

      state = state.copyWith(
        profile: profile,
        vehicle: vehicle,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando datos del conductor: $e',
      );
    }
  }

  /// Crea un perfil de conductor
  Future<bool> createProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await DriverProfileService.createProfile();
      if (profile != null) {
        state = state.copyWith(
          profile: profile,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Error creando perfil del conductor',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error creando perfil: $e',
      );
      return false;
    }
  }

  /// Actualiza el perfil del conductor
  Future<bool> updateProfile(DriverProfileUpdateRequest request) async {
    print('🏠 PROFILE_PROVIDER: Iniciando actualización de perfil');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🏠 PROFILE_PROVIDER: Llamando al servicio de actualización');
      final updatedProfile = await DriverProfileService.updateProfile(request);
      
      if (updatedProfile != null) {
        print('✅ PROFILE_PROVIDER: Perfil actualizado exitosamente');
        state = state.copyWith(
          profile: updatedProfile,
          isLoading: false,
        );
        return true;
      } else {
        print('❌ PROFILE_PROVIDER: El servicio retornó null');
        state = state.copyWith(
          isLoading: false,
          error: 'Error actualizando perfil del conductor',
        );
        return false;
      }
    } catch (e) {
      print('❌ PROFILE_PROVIDER: Excepción actualizando perfil: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error actualizando perfil: $e',
      );
      return false;
    }
  }



  // ===== VEHÍCULO =====

  /// Registra un nuevo vehículo
  Future<bool> registerVehicle(VehicleCreateRequest request) async {
    print('🚗 PROVIDER: Iniciando registro de vehículo');
    print('🚗 PROVIDER: Request data: ${request.toJson()}');
    
    state = state.copyWith(isLoading: true, error: null);

    try {
      final vehicle = await DriverProfileService.createVehicle(request);
      if (vehicle != null) {
        print('🚗 PROVIDER: Vehículo registrado exitosamente: ${vehicle.id}');
        state = state.copyWith(
          vehicle: vehicle,
          isLoading: false,
        );
        return true;
      } else {
        print('🚗 PROVIDER: Error - servicio retornó null');
        state = state.copyWith(
          isLoading: false,
          error: 'Error registrando vehículo',
        );
        return false;
      }
    } catch (e) {
      print('🚗 PROVIDER: Exception durante registro: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error registrando vehículo: $e',
      );
      return false;
    }
  }

  /// Actualiza el vehículo del conductor
  Future<bool> updateVehicle(VehicleUpdateRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedVehicle = await DriverProfileService.updateVehicle(request);
      if (updatedVehicle != null) {
        state = state.copyWith(
          vehicle: updatedVehicle,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Error actualizando vehículo',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error actualizando vehículo: $e',
      );
      return false;
    }
  }

  /// Elimina el vehículo del conductor
  Future<bool> deleteVehicle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await DriverProfileService.deleteVehicle();
      if (success) {
        state = state.copyWith(
          vehicle: null,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Error eliminando vehículo',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error eliminando vehículo: $e',
      );
      return false;
    }
  }

  /// Refresca los datos desde el servidor
  Future<void> refresh() async {
    await loadDriverData();
  }

  /// Limpia el estado de error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Establece el estado de carga manualmente
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Limpia completamente el perfil (para logout)
  void clearProfile() {
    state = DriverProfileState();
  }

  /// Cambia la contraseña del usuario
  Future<bool> changePassword(ChangePasswordRequest request) async {
    print('🏠 PROFILE_PROVIDER: Iniciando cambio de contraseña');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🏠 PROFILE_PROVIDER: Llamando al servicio de cambio de contraseña');
      final success = await DriverProfileService.changePassword(request);
      
      if (success) {
        print('✅ PROFILE_PROVIDER: Contraseña cambiada exitosamente');
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        print('❌ PROFILE_PROVIDER: El servicio retornó false');
        state = state.copyWith(
          isLoading: false,
          error: 'Error cambiando contraseña',
        );
        return false;
      }
    } catch (e) {
      print('❌ PROFILE_PROVIDER: Excepción cambiando contraseña: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error cambiando contraseña: $e',
      );
      return false;
    }
  }
}

/// Provider del notificador del perfil del conductor
final driverProfileNotifierProvider = StateNotifierProvider<DriverProfileNotifier, DriverProfileState>(
  (ref) => DriverProfileNotifier(),
);

/// Provider del perfil del conductor actual
final driverProfileProvider = Provider<DriverProfile?>((ref) {
  return ref.watch(driverProfileNotifierProvider).profile;
});

/// Provider del vehículo del conductor actual
final driverVehicleProvider = Provider<Vehicle?>((ref) {
  return ref.watch(driverProfileNotifierProvider).vehicle;
});

/// Provider del estado de carga
final driverProfileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(driverProfileNotifierProvider).isLoading;
});

/// Provider del error actual
final driverProfileErrorProvider = Provider<String?>((ref) {
  return ref.watch(driverProfileNotifierProvider).error;
});