import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../bookings/data/models/booking_model.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

/// Modelo de datos para Trip desde/hacia la API
@freezed
class TripModel with _$TripModel {
  const factory TripModel({
    required int id,
    required UserModel driver,
    required String origin,
    required String destination,
    required DateTime departureTime,
    required int availableSeats,
    required int remainingSeats,
    int? realAvailableSeats, // Asientos disponibles considerando reservas pendientes
    required double pricePerSeat,
    String? description,
    required String status,
    List<BookingModel>? bookings,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);
}

/// Extensión para convertir entre TripModel y Trip entity
extension TripModelX on TripModel {
  Trip toEntity() {
    return Trip(
      id: id,
      driver: driver.toEntity(),
      origin: origin,
      destination: destination,
      departureTime: departureTime,
      availableSeats: availableSeats,
      pricePerSeat: pricePerSeat,
      description: description,
      status: TripStatusX.fromString(status),
      bookings: bookings?.map((booking) => booking.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt, // Puede ser null
    );
  }
}

extension TripX on Trip {
  TripModel toModel() {
    return TripModel(
      id: id,
      driver: driver.toModel(),
      origin: origin,
      destination: destination,
      departureTime: departureTime,
      availableSeats: availableSeats,
      remainingSeats: remainingSeats,
      pricePerSeat: pricePerSeat,
      description: description,
      status: status.name,
      bookings: bookings?.map((booking) => booking.toModel()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}