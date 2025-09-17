// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingRequestDtoImpl _$$BookingRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingRequestDtoImpl(
      seatsRequested: (json['seatsRequested'] as num).toInt(),
    );

Map<String, dynamic> _$$BookingRequestDtoImplToJson(
        _$BookingRequestDtoImpl instance) =>
    <String, dynamic>{
      'seatsRequested': instance.seatsRequested,
    };
