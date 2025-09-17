// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: (json['id'] as num).toInt(),
      tripId: (json['tripId'] as num).toInt(),
      passenger: UserModel.fromJson(json['passenger'] as Map<String, dynamic>),
      seatsRequested: (json['seatsRequested'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      confirmedDate: json['confirmedDate'] == null
          ? null
          : DateTime.parse(json['confirmedDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'passenger': instance.passenger,
      'seatsRequested': instance.seatsRequested,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'confirmedDate': instance.confirmedDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
