/// Modelo para representar un viaje del grupo
class GroupTripModel {
  final int id;
  final DriverInfo driver;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final int availableSeats;
  final int remainingSeats;
  final double pricePerSeat;
  final String? description;
  final TripStatus status;
  final DateTime createdAt;
  final List<BookingInfo> bookings;

  GroupTripModel({
    required this.id,
    required this.driver,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.remainingSeats,
    required this.pricePerSeat,
    this.description,
    required this.status,
    required this.createdAt,
    this.bookings = const [],
  });

  factory GroupTripModel.fromJson(Map<String, dynamic> json) {
    return GroupTripModel(
      id: json['id'] ?? 0,
      driver: DriverInfo.fromJson(json['driver'] ?? {}),
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: DateTime.tryParse(json['departureTime'] ?? '') ?? DateTime.now(),
      availableSeats: json['availableSeats'] ?? 0,
      remainingSeats: json['remainingSeats'] ?? 0,
      pricePerSeat: (json['pricePerSeat'] ?? 0.0).toDouble(),
      description: json['description'],
      status: TripStatus.fromString(json['status'] ?? 'pending'),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      bookings: (json['bookings'] as List<dynamic>? ?? [])
          .map((booking) => BookingInfo.fromJson(booking))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver': driver.toJson(),
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
      'availableSeats': availableSeats,
      'remainingSeats': remainingSeats,
      'pricePerSeat': pricePerSeat,
      'description': description,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'bookings': bookings.map((booking) => booking.toJson()).toList(),
    };
  }

  /// Obtener tiempo formateado de salida
  String get formattedDepartureTime {
    return '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}';
  }

  /// Obtener fecha formateada
  String get formattedDate {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${departureTime.day} ${months[departureTime.month - 1]}';
  }

  /// Verificar si el viaje es del día actual
  bool get isToday {
    final now = DateTime.now();
    return departureTime.year == now.year &&
           departureTime.month == now.month &&
           departureTime.day == now.day;
  }
}

/// Información del conductor
class DriverInfo {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  DriverInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };
  }

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';
}

/// Información de reserva
class BookingInfo {
  final int id;
  final String passengerName;
  final String status;
  final DateTime createdAt;

  BookingInfo({
    required this.id,
    required this.passengerName,
    required this.status,
    required this.createdAt,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      id: json['id'] ?? 0,
      passengerName: json['passengerName'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passengerName': passengerName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Estados del viaje
enum TripStatus {
  pending('PENDING', 'Pendiente'),
  inProgress('IN_PROGRESS', 'En Curso'),
  completed('COMPLETED', 'Completado'),
  cancelled('CANCELLED', 'Cancelado');

  const TripStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static TripStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return TripStatus.pending;
      case 'IN_PROGRESS':
        return TripStatus.inProgress;
      case 'COMPLETED':
        return TripStatus.completed;
      case 'CANCELLED':
        return TripStatus.cancelled;
      default:
        return TripStatus.pending;
    }
  }
}