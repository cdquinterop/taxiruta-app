/// Entidad de dominio para el usuario
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  /// Nombre completo del usuario
  String get fullName => '$firstName $lastName';

  /// Verificar si es conductor
  bool get isDriver => role.toUpperCase() == 'DRIVER';

  /// Verificar si es pasajero
  bool get isPassenger => role.toUpperCase() == 'PASSENGER';

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.role == role &&
        other.active == active &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      firstName,
      lastName,
      email,
      phone,
      role,
      active,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, role: $role, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}