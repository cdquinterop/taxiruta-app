import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared/constants/app_constants.dart';
import '../core/utils/storage_utils.dart';

/// Servicio para manejar viajes del grupo
class GroupTripsService {
  static const String _baseUrl = '${AppConstants.baseUrl}/api/trips';

  /// Obtener viajes del grupo del día actual
  static Future<List<Map<String, dynamic>>> getGroupTripsToday() async {
    try {
      print('📊 GROUP_TRIPS_SERVICE: Fetching group trips for today...');
      
      final token = await StorageUtils.getToken();
      if (token == null) {
        throw Exception('Token de autenticación no encontrado');
      }

      final url = Uri.parse('$_baseUrl/group/today');
      print('📊 GROUP_TRIPS_SERVICE: URL: $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📊 GROUP_TRIPS_SERVICE: Status Code: ${response.statusCode}');
      print('📊 GROUP_TRIPS_SERVICE: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> tripsData = responseData['data'] ?? [];
          final List<Map<String, dynamic>> trips = tripsData
              .map((trip) => Map<String, dynamic>.from(trip))
              .toList();
          
          print('📊 GROUP_TRIPS_SERVICE: Successfully loaded ${trips.length} trips');
          return trips;
        } else {
          throw Exception(responseData['message'] ?? 'Error al obtener viajes del grupo');
        }
      } else if (response.statusCode == 404) {
        print('📊 GROUP_TRIPS_SERVICE: No trips found for today');
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada. Por favor inicia sesión nuevamente.');
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error del servidor');
      }
    } catch (e) {
      print('❌ GROUP_TRIPS_SERVICE: Error fetching group trips: $e');
      
      if (e.toString().contains('SocketException') || 
          e.toString().contains('Connection')) {
        throw Exception('Sin conexión a internet');
      }
      
      rethrow;
    }
  }

  /// Formatear estado del viaje para mostrar
  static String formatTripStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Curso';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  /// Obtener color del estado
  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'orange';
      case 'in_progress':
        return 'blue';
      case 'completed':
        return 'green';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
    }
  }
}