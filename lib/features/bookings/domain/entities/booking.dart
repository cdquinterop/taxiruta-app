import '../../../auth/domain/entities/user.dart';

/// Entidad Booking para el dominio de la aplicación
class Booking {
  final int id;
  final int tripId;
  final User passenger;
  final int seatsRequested;
  final double totalPrice;
  final BookingStatus status;
  final DateTime bookingDate;
  final DateTime? confirmedDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.tripId,
    required this.passenger,
    required this.seatsRequested,
    required this.totalPrice,
    required this.status,
    required this.bookingDate,
    this.confirmedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Booking copyWith({
    int? id,
    int? tripId,
    User? passenger,
    int? seatsRequested,
    double? totalPrice,
    BookingStatus? status,
    DateTime? bookingDate,
    DateTime? confirmedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      passenger: passenger ?? this.passenger,
      seatsRequested: seatsRequested ?? this.seatsRequested,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      confirmedDate: confirmedDate ?? this.confirmedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Confirma la reserva
  Booking confirm() {
    return copyWith(
      status: BookingStatus.confirmed,
      confirmedDate: DateTime.now(),
    );
  }

  /// Rechaza la reserva
  Booking reject() {
    return copyWith(status: BookingStatus.rejected);
  }

  /// Cancela la reserva
  Booking cancel() {
    return copyWith(status: BookingStatus.cancelled);
  }

  /// Verifica si está pendiente
  bool get isPending => status == BookingStatus.pending;

  /// Verifica si está confirmada
  bool get isConfirmed => status == BookingStatus.confirmed;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Booking(id: $id, tripId: $tripId, seatsRequested: $seatsRequested, totalPrice: $totalPrice, status: $status)';
  }
}

/// Estados posibles de una reserva
enum BookingStatus {
  pending,
  confirmed,
  rejected,
  cancelled,
}

/// Extensión para convertir entre string y enum
extension BookingStatusX on BookingStatus {
  String get name {
    switch (this) {
      case BookingStatus.pending:
        return 'PENDING';
      case BookingStatus.confirmed:
        return 'CONFIRMED';
      case BookingStatus.rejected:
        return 'REJECTED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static BookingStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return BookingStatus.pending;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'REJECTED':
        return BookingStatus.rejected;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      default:
        throw ArgumentError('Invalid booking status: $status');
    }
  }
}