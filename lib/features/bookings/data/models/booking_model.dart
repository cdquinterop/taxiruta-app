import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/booking.dart';
import '../../../auth/data/models/user_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Modelo de datos para Booking desde/hacia la API
@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required int id,
    required int tripId,
    required UserModel passenger,
    required int seatsRequested,
    required double totalPrice,
    required String status,
    required DateTime bookingDate,
    DateTime? confirmedDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

/// Extensión para convertir entre BookingModel y Booking entity
extension BookingModelX on BookingModel {
  Booking toEntity() {
    return Booking(
      id: id,
      tripId: tripId,
      passenger: passenger.toEntity(),
      seatsRequested: seatsRequested,
      totalPrice: totalPrice,
      status: BookingStatusX.fromString(status),
      bookingDate: bookingDate,
      confirmedDate: confirmedDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension BookingX on Booking {
  BookingModel toModel() {
    return BookingModel(
      id: id,
      tripId: tripId,
      passenger: passenger.toModel(),
      seatsRequested: seatsRequested,
      totalPrice: totalPrice,
      status: status.name,
      bookingDate: bookingDate,
      confirmedDate: confirmedDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}