import '../../../auth/domain/entities/user.dart';
import '../../../bookings/domain/entities/booking.dart';

/// Entidad Trip para el dominio de la aplicación
class Trip {
  final int id;
  final User driver;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final int availableSeats;
  final double pricePerSeat;
  final String? description;
  final TripStatus status;
  final List<Booking>? bookings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Trip({
    required this.id,
    required this.driver,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    this.description,
    required this.status,
    this.bookings,
    required this.createdAt,
    this.updatedAt,
  });

  Trip copyWith({
    int? id,
    User? driver,
    String? origin,
    String? destination,
    DateTime? departureTime,
    int? availableSeats,
    double? pricePerSeat,
    String? description,
    TripStatus? status,
    List<Booking>? bookings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trip(
      id: id ?? this.id,
      driver: driver ?? this.driver,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      availableSeats: availableSeats ?? this.availableSeats,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      description: description ?? this.description,
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Obtiene el conteo de reservas confirmadas
  int get confirmedBookingsCount {
    if (bookings == null) return 0;
    return bookings!.where((booking) => booking.status == BookingStatus.confirmed).length;
  }

  /// Obtiene los asientos restantes disponibles
  int get remainingSeats {
    return availableSeats - confirmedBookingsCount;
  }

  /// Verifica si hay asientos disponibles
  bool get hasAvailableSeats {
    return remainingSeats > 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Trip && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Trip(id: $id, origin: $origin, destination: $destination, departureTime: $departureTime, availableSeats: $availableSeats, pricePerSeat: $pricePerSeat, status: $status)';
  }
}

/// Estados posibles de un viaje
enum TripStatus {
  active,
  inProgress,
  cancelled,
  completed,
}

/// Extensión para convertir entre string y enum
extension TripStatusX on TripStatus {
  String get name {
    switch (this) {
      case TripStatus.active:
        return 'ACTIVE';
      case TripStatus.inProgress:
        return 'IN_PROGRESS';
      case TripStatus.cancelled:
        return 'CANCELLED';
      case TripStatus.completed:
        return 'COMPLETED';
    }
  }

  static TripStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return TripStatus.active;
      case 'IN_PROGRESS':
        return TripStatus.inProgress;
      case 'CANCELLED':
        return TripStatus.cancelled;
      case 'COMPLETED':
        return TripStatus.completed;
      default:
        throw ArgumentError('Invalid trip status: $status');
    }
  }
}