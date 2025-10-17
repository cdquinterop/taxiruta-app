import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/driver_profile_models.dart';
import '../models/vehicle_models.dart';
import '../models/driver_document_models.dart';
import '../models/change_password_models.dart';
import '../shared/constants/app_constants.dart';

class DriverProfileService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/drivers';
  static const String usersBaseUrl = 'http://10.0.2.2:8080/api/users';
  static const _storage = FlutterSecureStorage();

  /// Método de prueba para verificar el token
  static Future<void> testToken() async {
    try {
      print('🔍 TEST_TOKEN: Iniciando verificación de token');
      final token = await _storage.read(key: AppConstants.tokenKey);
      
      if (token != null) {
        print('✅ TEST_TOKEN: Token encontrado: ${token.substring(0, 20)}...');
        
        // Probar con endpoint simple
        final headers = await _getHeaders();
        final response = await http.get(
          Uri.parse('$usersBaseUrl/profile'),
          headers: headers,
        );
        
        print('🔍 TEST_TOKEN: Respuesta del endpoint /users/profile: ${response.statusCode}');
        if (response.statusCode == 401) {
          print('❌ TEST_TOKEN: Token inválido o expirado');
        } else if (response.statusCode == 200) {
          print('✅ TEST_TOKEN: Token válido');
        }
      } else {
        print('❌ TEST_TOKEN: No se encontró token');
      }
    } catch (e) {
      print('❌ TEST_TOKEN: Error: $e');
    }
  }

  // Headers con autenticación
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    print('🔑 DRIVER_SERVICE: Token recuperado: ${token != null ? "${token.substring(0, 20)}..." : "null"}');
    
    // Verificar si el token existe y es válido
    if (token == null || token.isEmpty) {
      print('❌ DRIVER_SERVICE: ALERTA - Token no encontrado o vacío');
      
      // Debug: Listar todas las claves almacenadas
      try {
        final allKeys = await _storage.readAll();
        print('🔍 DRIVER_SERVICE: Claves almacenadas: ${allKeys.keys.toList()}');
      } catch (e) {
        print('❌ DRIVER_SERVICE: Error listando claves: $e');
      }
    }
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // ===== PERFIL DEL CONDUCTOR =====

  /// Verifica el perfil del usuario actual para debug
  static Future<void> debugUserProfile() async {
    try {
      final headers = await _getHeaders();
      print('🐛 DEBUG: Verificando perfil del usuario actual');
      
      final response = await http.get(
        Uri.parse('$usersBaseUrl/profile'),
        headers: headers,
      );

      print('🐛 DEBUG: Respuesta perfil usuario - Status: ${response.statusCode}');
      print('🐛 DEBUG: Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final userData = data['data'];
          print('🐛 DEBUG: Usuario ID: ${userData['id']}');
          print('🐛 DEBUG: Usuario Email: ${userData['email']}');
          print('🐛 DEBUG: Usuario Rol: ${userData['role']}');
          print('🐛 DEBUG: Usuario Activo: ${userData['active']}');
        }
      }
    } catch (e) {
      print('🐛 DEBUG: Error obteniendo perfil de usuario: $e');
    }
  }

  /// Obtiene el perfil del conductor autenticado
  static Future<DriverProfile?> getMyProfile() async {
    try {
      // Primero verificar el perfil del usuario para debug
      await debugUserProfile();
      
      final headers = await _getHeaders();
      print('🌐 DRIVER_SERVICE: Realizando petición GET a: $baseUrl/profile');
      print('📤 DRIVER_SERVICE: Headers enviados: $headers');
      
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
      );

      print('📥 DRIVER_SERVICE: Respuesta recibida - Status: ${response.statusCode}');
      print('📥 DRIVER_SERVICE: Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ DRIVER_SERVICE: Perfil obtenido exitosamente');
          try {
            return DriverProfile.fromJson(data['data']);
          } catch (e) {
            print('❌ DRIVER_SERVICE: Error parseando perfil: $e');
            print('📊 DRIVER_SERVICE: Datos recibidos: ${data['data']}');
            return null;
          }
        } else {
          print('⚠️ DRIVER_SERVICE: Respuesta sin datos válidos: $data');
        }
      } else if (response.statusCode == 401) {
        print('❌ DRIVER_SERVICE: Error 401 - Token inválido o no autorizado');
      } else if (response.statusCode == 403) {
        print('❌ DRIVER_SERVICE: Error 403 - No tienes permisos de conductor');
      } else if (response.statusCode == 404) {
        print('⚠️ DRIVER_SERVICE: Error 404 - Perfil no encontrado');
      } else {
        print('❌ DRIVER_SERVICE: Error HTTP ${response.statusCode}: ${response.body}');
      }
      return null;
    } catch (e) {
      print('❌ DRIVER_SERVICE: Error obteniendo perfil del conductor: $e');
      return null;
    }
  }

  /// Crea un nuevo perfil de conductor
  static Future<DriverProfile?> createProfile() async {
    try {
      // Primero verificar el perfil del usuario para debug
      await debugUserProfile();
      
      final headers = await _getHeaders();
      print('🌐 DRIVER_SERVICE: Realizando petición POST para crear perfil: $baseUrl/profile');
      print('📤 DRIVER_SERVICE: Headers enviados: $headers');
      
      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
      );

      print('📥 DRIVER_SERVICE: Respuesta crear perfil - Status: ${response.statusCode}');
      print('📥 DRIVER_SERVICE: Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ DRIVER_SERVICE: Perfil creado exitosamente');
          try {
            return DriverProfile.fromJson(data['data']);
          } catch (e) {
            print('❌ DRIVER_SERVICE: Error parseando respuesta del perfil: $e');
            print('📊 DRIVER_SERVICE: Datos recibidos: ${data['data']}');
            return null;
          }
        } else {
          print('⚠️ DRIVER_SERVICE: Respuesta sin datos válidos al crear: $data');
        }
      } else if (response.statusCode == 401) {
        print('❌ DRIVER_SERVICE: Error 401 - Token inválido al crear perfil');
      } else if (response.statusCode == 403) {
        print('❌ DRIVER_SERVICE: Error 403 - No tienes permisos de conductor');
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        print('❌ DRIVER_SERVICE: Error 400 - ${data['message'] ?? 'Datos inválidos'}');
      } else if (response.statusCode == 500) {
        final data = json.decode(response.body);
        print('❌ DRIVER_SERVICE: Error 500 del servidor - ${data['message'] ?? 'Error interno'}');
      } else {
        print('❌ DRIVER_SERVICE: Error HTTP ${response.statusCode} al crear perfil: ${response.body}');
      }
      return null;
    } catch (e) {
      print('❌ DRIVER_SERVICE: Error creando perfil del conductor: $e');
      return null;
    }
  }

  /// Actualiza el perfil del conductor
  static Future<DriverProfile?> updateProfile(DriverProfileUpdateRequest request) async {
    try {
      print('🔄 DRIVER_SERVICE: Iniciando actualización de perfil');
      
      // Verificar token antes de proceder
      await testToken();
      
      final headers = await _getHeaders();
      print('🔄 DRIVER_SERVICE: Headers obtenidos para actualización');
      
      final url = '$baseUrl/profile';
      final body = json.encode(request.toJson());
      
      print('🔄 DRIVER_SERVICE: URL: $url');
      print('🔄 DRIVER_SERVICE: Body: $body');
      
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('🔄 DRIVER_SERVICE: Respuesta actualización - Status: ${response.statusCode}');
      print('🔄 DRIVER_SERVICE: Respuesta actualización - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ DRIVER_SERVICE: Perfil actualizado exitosamente');
          return DriverProfile.fromJson(data['data']);
        }
      } else if (response.statusCode == 401) {
        print('❌ DRIVER_SERVICE: Token inválido o expirado al actualizar perfil');
      }
      
      print('❌ DRIVER_SERVICE: Error al actualizar perfil');
      return null;
    } catch (e) {
      print('❌ DRIVER_SERVICE: Excepción actualizando perfil del conductor: $e');
      return null;
    }
  }

  /// Actualiza el estado online del conductor
  static Future<bool> updateOnlineStatus(bool isOnline) async {
    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/status/online?isOnline=$isOnline'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizando estado online: $e');
      return false;
    }
  }

  /// Actualiza el estado de disponibilidad del conductor
  static Future<bool> updateAvailabilityStatus(bool isAvailable) async {
    try {
      final headers = await _getHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/status/availability?isAvailable=$isAvailable'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizando disponibilidad: $e');
      return false;
    }
  }

  // ===== VEHÍCULO =====

  /// Obtiene el vehículo del conductor
  static Future<Vehicle?> getMyVehicle() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/vehicle'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Vehicle.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error obteniendo vehículo: $e');
      return null;
    }
  }

  /// Registra un nuevo vehículo
  static Future<Vehicle?> createVehicle(VehicleCreateRequest request) async {
    try {
      final headers = await _getHeaders();
      final requestBody = json.encode(request.toJson());
      
      print('🚗 CREATE_VEHICLE: Enviando request a $baseUrl/vehicle');
      print('🚗 CREATE_VEHICLE: Headers: $headers');
      print('🚗 CREATE_VEHICLE: Body: $requestBody');
      
      final response = await http.post(
        Uri.parse('$baseUrl/vehicle'),
        headers: headers,
        body: requestBody,
      );

      print('🚗 CREATE_VEHICLE: Status Code: ${response.statusCode}');
      print('🚗 CREATE_VEHICLE: Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('🚗 CREATE_VEHICLE: Vehículo creado exitosamente');
          return Vehicle.fromJson(data['data']);
        } else {
          print('🚗 CREATE_VEHICLE: Respuesta sin éxito: $data');
        }
      } else {
        print('🚗 CREATE_VEHICLE: Error HTTP ${response.statusCode}: ${response.body}');
      }
      return null;
    } catch (e) {
      print('🚗 CREATE_VEHICLE: Exception: $e');
      return null;
    }
  }

  /// Actualiza el vehículo del conductor
  static Future<Vehicle?> updateVehicle(VehicleUpdateRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/vehicle'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Vehicle.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error actualizando vehículo: $e');
      return null;
    }
  }

  /// Elimina el vehículo del conductor
  static Future<bool> deleteVehicle() async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/vehicle'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminando vehículo: $e');
      return false;
    }
  }

  // ===== DOCUMENTOS =====

  /// Obtiene todos los documentos del conductor
  static Future<List<DriverDocument>> getMyDocuments() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/documents'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => DriverDocument.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error obteniendo documentos: $e');
      return [];
    }
  }

  /// Crea un nuevo documento
  static Future<DriverDocument?> createDocument(DriverDocumentCreateRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/documents'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return DriverDocument.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error creando documento: $e');
      return null;
    }
  }

  /// Actualiza un documento
  static Future<DriverDocument?> updateDocument(
      int documentId, DriverDocumentUpdateRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/documents/$documentId'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return DriverDocument.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error actualizando documento: $e');
      return null;
    }
  }

  /// Elimina un documento
  static Future<bool> deleteDocument(int documentId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/documents/$documentId'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminando documento: $e');
      return false;
    }
  }

  /// Obtiene documentos próximos a vencer
  static Future<List<DriverDocument>> getExpiringDocuments({int days = 30}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/documents/expiring?days=$days'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => DriverDocument.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error obteniendo documentos por vencer: $e');
      return [];
    }
  }

  // ===== CAMBIO DE CONTRASEÑA =====

  /// Cambia la contraseña del usuario autenticado
  static Future<bool> changePassword(ChangePasswordRequest request) async {
    try {
      print('🔐 DRIVER_SERVICE: Iniciando cambio de contraseña');
      
      // Verificar token antes de proceder
      await testToken();
      
      final headers = await _getHeaders();
      print('🔐 DRIVER_SERVICE: Headers obtenidos para cambio de contraseña');
      
      final url = '$usersBaseUrl/change-password';
      final body = json.encode(request.toJson());
      
      print('🔐 DRIVER_SERVICE: URL: $url');
      print('🔐 DRIVER_SERVICE: Body: ${body.replaceAll(RegExp(r'"[^"]*password[^"]*":"[^"]*"'), '"***":"***"')}'); // Ocultar contraseñas en logs
      
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('🔐 DRIVER_SERVICE: Respuesta cambio contraseña - Status: ${response.statusCode}');
      print('🔐 DRIVER_SERVICE: Respuesta cambio contraseña - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ DRIVER_SERVICE: Contraseña cambiada exitosamente');
          return true;
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        print('❌ DRIVER_SERVICE: Error de validación: ${data['message']}');
        throw Exception(data['message'] ?? 'Error validando datos');
      } else if (response.statusCode == 401) {
        print('❌ DRIVER_SERVICE: Token inválido o expirado al cambiar contraseña');
        throw Exception('Sesión expirada');
      }
      
      print('❌ DRIVER_SERVICE: Error al cambiar contraseña');
      return false;
    } catch (e) {
      print('❌ DRIVER_SERVICE: Excepción cambiando contraseña: $e');
      throw e;
    }
  }
}