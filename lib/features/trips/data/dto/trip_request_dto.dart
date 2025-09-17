import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_request_dto.freezed.dart';
part 'trip_request_dto.g.dart';

/// DTO para request de creación de viaje
@freezed
class TripRequestDto with _$TripRequestDto {
  const factory TripRequestDto({
    required String origin,
    required String destination,
    required DateTime departureTime,
    required int availableSeats,
    required double pricePerSeat,
    String? description,
  }) = _TripRequestDto;

  factory TripRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TripRequestDtoFromJson(json);
}