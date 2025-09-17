import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_request_dto.freezed.dart';
part 'booking_request_dto.g.dart';

/// DTO para request de reserva
@freezed
class BookingRequestDto with _$BookingRequestDto {
  const factory BookingRequestDto({
    required int seatsRequested,
  }) = _BookingRequestDto;

  factory BookingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$BookingRequestDtoFromJson(json);
}