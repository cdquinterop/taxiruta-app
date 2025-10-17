// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripModelImpl _$$TripModelImplFromJson(Map<String, dynamic> json) =>
    _$TripModelImpl(
      id: (json['id'] as num).toInt(),
      driver: UserModel.fromJson(json['driver'] as Map<String, dynamic>),
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      availableSeats: (json['availableSeats'] as num).toInt(),
      remainingSeats: (json['remainingSeats'] as num).toInt(),
      realAvailableSeats: (json['realAvailableSeats'] as num?)?.toInt(),
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      description: json['description'] as String?,
      status: json['status'] as String,
      bookings: (json['bookings'] as List<dynamic>?)
          ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver': instance.driver,
      'origin': instance.origin,
      'destination': instance.destination,
      'departureTime': instance.departureTime.toIso8601String(),
      'availableSeats': instance.availableSeats,
      'remainingSeats': instance.remainingSeats,
      'realAvailableSeats': instance.realAvailableSeats,
      'pricePerSeat': instance.pricePerSeat,
      'description': instance.description,
      'status': instance.status,
      'bookings': instance.bookings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
