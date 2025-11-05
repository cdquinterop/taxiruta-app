import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared/constants/app_constants.dart';
import '../models/group_model.dart';
import '../core/utils/storage_utils.dart';

/// Servicio para gestionar las operaciones de grupos de conductores
class GroupService {
  static const String _baseUrl = '${AppConstants.baseUrl}/api/groups';

  /// Obtener headers con autorización
  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageUtils.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Obtener el grupo actual del conductor autenticado
  static Future<GroupModel?> getMyGroup() async {
    try {
      print('🔍 GROUP_SERVICE: Getting current user group...');
      
      final headers = await _getHeaders();
      print('🔍 GROUP_SERVICE: Headers prepared, making request to $_baseUrl/my-group');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/my-group'),
        headers: headers,
      );

      print('🔍 GROUP_SERVICE: Response status: ${response.statusCode}');
      print('🔍 GROUP_SERVICE: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ GROUP_SERVICE: Group found: ${data['data']}');
          return GroupModel.fromJson(data['data']);
        } else {
          print('⚠️ GROUP_SERVICE: No group assigned to user');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('❌ GROUP_SERVICE: Error 401 - Token inválido');
        throw Exception('Token inválido o expirado');
      } else if (response.statusCode == 403) {
        print('❌ GROUP_SERVICE: Error 403 - No tienes permisos de conductor');
        throw Exception('No tienes permisos de conductor');
      } else {
        print('❌ GROUP_SERVICE: Error HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Error al obtener el grupo: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ GROUP_SERVICE: Error getting group: $e');
      throw Exception('Error de conexión al obtener grupo: $e');
    }
  }

  /// Unirse a un grupo usando el código del grupo
  static Future<bool> joinGroup(String groupCode) async {
    try {
      print('🔗 GROUP_SERVICE: Joining group with code: $groupCode');
      
      final headers = await _getHeaders();
      final body = json.encode({
        'groupCode': groupCode.toUpperCase(),
      });

      print('🔗 GROUP_SERVICE: Request body: $body');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/join'),
        headers: headers,
        body: body,
      );

      print('🔗 GROUP_SERVICE: Response status: ${response.statusCode}');
      print('🔗 GROUP_SERVICE: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ GROUP_SERVICE: Successfully joined group');
          return true;
        } else {
          final errorMessage = data['message'] ?? 'Error desconocido';
          print('❌ GROUP_SERVICE: Failed to join group: $errorMessage');
          throw Exception(errorMessage);
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        final errorMessage = data['message'] ?? 'Código de grupo inválido';
        print('❌ GROUP_SERVICE: Error 400 - $errorMessage');
        throw Exception(errorMessage);
      } else if (response.statusCode == 401) {
        print('❌ GROUP_SERVICE: Error 401 - Token inválido');
        throw Exception('Token inválido o expirado');
      } else if (response.statusCode == 403) {
        print('❌ GROUP_SERVICE: Error 403 - No tienes permisos de conductor');
        throw Exception('Solo los conductores pueden unirse a grupos');
      } else if (response.statusCode == 404) {
        print('❌ GROUP_SERVICE: Error 404 - Grupo no encontrado');
        throw Exception('No se encontró un grupo con el código: $groupCode');
      } else {
        print('❌ GROUP_SERVICE: Error HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Error al unirse al grupo: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ GROUP_SERVICE: Error joining group: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión al unirse al grupo: $e');
    }
  }

  /// Salir del grupo actual
  static Future<bool> leaveGroup() async {
    try {
      print('🚪 GROUP_SERVICE: Leaving current group...');
      
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$_baseUrl/leave'),
        headers: headers,
      );

      print('🚪 GROUP_SERVICE: Response status: ${response.statusCode}');
      print('🚪 GROUP_SERVICE: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ GROUP_SERVICE: Successfully left group');
          return true;
        } else {
          final errorMessage = data['message'] ?? 'Error desconocido';
          print('❌ GROUP_SERVICE: Failed to leave group: $errorMessage');
          throw Exception(errorMessage);
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        final errorMessage = data['message'] ?? 'No perteneces a ningún grupo';
        print('❌ GROUP_SERVICE: Error 400 - $errorMessage');
        throw Exception(errorMessage);
      } else if (response.statusCode == 401) {
        print('❌ GROUP_SERVICE: Error 401 - Token inválido');
        throw Exception('Token inválido o expirado');
      } else if (response.statusCode == 403) {
        print('❌ GROUP_SERVICE: Error 403 - No tienes permisos de conductor');
        throw Exception('No tienes permisos de conductor');
      } else {
        print('❌ GROUP_SERVICE: Error HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Error al salir del grupo: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ GROUP_SERVICE: Error leaving group: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión al salir del grupo: $e');
    }
  }

  /// Obtener los miembros del grupo actual
  static Future<List<Map<String, dynamic>>> getGroupMembers() async {
    try {
      print('👥 GROUP_SERVICE: Getting group members...');
      
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$_baseUrl/members'),
        headers: headers,
      );

      print('👥 GROUP_SERVICE: Response status: ${response.statusCode}');
      print('👥 GROUP_SERVICE: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('✅ GROUP_SERVICE: Members found: ${data['data']}');
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          print('⚠️ GROUP_SERVICE: No members found');
          return [];
        }
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        final errorMessage = data['message'] ?? 'No perteneces a ningún grupo';
        print('❌ GROUP_SERVICE: Error 400 - $errorMessage');
        throw Exception(errorMessage);
      } else if (response.statusCode == 401) {
        print('❌ GROUP_SERVICE: Error 401 - Token inválido');
        throw Exception('Token inválido o expirado');
      } else if (response.statusCode == 403) {
        print('❌ GROUP_SERVICE: Error 403 - No tienes permisos de conductor');
        throw Exception('No tienes permisos de conductor');
      } else {
        print('❌ GROUP_SERVICE: Error HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Error al obtener miembros del grupo: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ GROUP_SERVICE: Error getting group members: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión al obtener miembros: $e');
    }
  }
}