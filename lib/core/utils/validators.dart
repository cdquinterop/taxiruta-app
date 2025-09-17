import '../../shared/constants/app_constants.dart';

/// Utilidades de validación para formularios
class Validators {
  /// Validar email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    
    final emailRegExp = RegExp(AppConstants.emailPattern);
    if (!emailRegExp.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    
    return null;
  }

  /// Validar contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'La contraseña debe tener al menos ${AppConstants.minPasswordLength} caracteres';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'La contraseña no puede exceder ${AppConstants.maxPasswordLength} caracteres';
    }
    
    return null;
  }

  /// Validar nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return 'El nombre no puede exceder ${AppConstants.maxNameLength} caracteres';
    }
    
    return null;
  }

  /// Validar teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    
    final phoneRegExp = RegExp(AppConstants.phonePattern);
    if (!phoneRegExp.hasMatch(value)) {
      return 'Ingresa un teléfono válido';
    }
    
    return null;
  }

  /// Validar precio
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es requerido';
    }
    
    final price = double.tryParse(value);
    if (price == null) {
      return 'Ingresa un precio válido';
    }
    
    if (price <= 0) {
      return 'El precio debe ser mayor a 0';
    }
    
    if (price > 10000) {
      return 'El precio no puede exceder \$10,000';
    }
    
    return null;
  }

  /// Validar número de asientos
  static String? validateSeats(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de asientos es requerido';
    }
    
    final seats = int.tryParse(value);
    if (seats == null) {
      return 'Ingresa un número válido';
    }
    
    if (seats <= 0) {
      return 'Debe haber al menos 1 asiento';
    }
    
    if (seats > 8) {
      return 'No puede exceder 8 asientos';
    }
    
    return null;
  }

  /// Validar origen/destino
  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'La ubicación es requerida';
    }
    
    if (value.length < 3) {
      return 'La ubicación debe tener al menos 3 caracteres';
    }
    
    if (value.length > 100) {
      return 'La ubicación no puede exceder 100 caracteres';
    }
    
    return null;
  }

  /// Validar fecha
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'La fecha es requerida';
    }
    
    final now = DateTime.now();
    if (value.isBefore(now)) {
      return 'La fecha no puede ser en el pasado';
    }
    
    final maxDate = now.add(const Duration(days: 365));
    if (value.isAfter(maxDate)) {
      return 'La fecha no puede ser mayor a un año';
    }
    
    return null;
  }

  /// Validar hora
  static String? validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'La hora es requerida';
    }
    
    // Validar formato HH:MM
    final timeRegExp = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegExp.hasMatch(value)) {
      return 'Ingresa una hora válida (HH:MM)';
    }
    
    return null;
  }

  /// Validar confirmación de contraseña
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }

  /// Validar campo requerido genérico
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Validar longitud mínima
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    
    if (value.length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }
    
    return null;
  }

  /// Validar longitud máxima
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName no puede exceder $maxLength caracteres';
    }
    
    return null;
  }
}