/// Constantes globales de la aplicación TaxiRuta
class AppConstants {
  // URLs de la API
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String authEndpoint = '/api/auth';
  static const String usersEndpoint = '/api/users';
  static const String tripsEndpoint = '/api/trips';
  static const String bookingsEndpoint = '/api/bookings';
  
  // Claves de almacenamiento seguro
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  
  // Configuración de la aplicación
  static const String appName = 'TaxiRuta';
  static const String appVersion = '1.0.0';
  
  // Configuración de timeouts
  static const int connectTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000; // 30 segundos
  
  // Configuración de paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Códigos de respuesta HTTP
  static const int httpOk = 200;
  static const int httpCreated = 201;
  static const int httpBadRequest = 400;
  static const int httpUnauthorized = 401;
  static const int httpForbidden = 403;
  static const int httpNotFound = 404;
  static const int httpInternalServerError = 500;
  
  // Formatos de fecha
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Patrones de validación
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[0-9]{10,15}$';
  
  // Límites de caracteres
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
}