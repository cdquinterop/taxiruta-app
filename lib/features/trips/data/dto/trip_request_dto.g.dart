// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripRequestDtoImpl _$$TripRequestDtoImplFromJson(Map<String, dynamic> json) =>
    _$TripRequestDtoImpl(
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      availableSeats: (json['availableSeats'] as num).toInt(),
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TripRequestDtoImplToJson(
        _$TripRequestDtoImpl instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'departureTime': instance.departureTime.toIso8601String(),
      'availableSeats': instance.availableSeats,
      'pricePerSeat': instance.pricePerSeat,
      'description': instance.description,
    };
