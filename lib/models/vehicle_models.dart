/// Modelo para el vehículo
class Vehicle {
  final int id;
  final int driverProfileId;
  final String licensePlate;
  final String make;
  final String model;
  final int year;
  final String color;
  final VehicleType type;
  final int capacity;
  final bool hasAirConditioning;
  final bool hasGps;
  final bool hasBabySeat;
  final bool wheelchairAccessible;
  final String? description;
  final String? vehicleImageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.driverProfileId,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.type,
    required this.capacity,
    required this.hasAirConditioning,
    required this.hasGps,
    required this.hasBabySeat,
    required this.wheelchairAccessible,
    this.description,
    this.vehicleImageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      driverProfileId: json['driverProfileId'] ?? 0,
      licensePlate: json['licensePlate'] ?? '',
      make: json['make'] ?? '', // Corrected: backend sends 'make'
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      type: VehicleType.values.firstWhere(
        (e) => e.name.toUpperCase() == (json['type'] ?? '').toString().toUpperCase(),
        orElse: () => VehicleType.SEDAN,
      ),
      capacity: json['capacity'] ?? 4,
      hasAirConditioning: json['hasAirConditioning'] ?? false,
      hasGps: json['hasGps'] ?? false,
      hasBabySeat: json['hasBabySeat'] ?? false,
      wheelchairAccessible: json['wheelchairAccessible'] ?? false,
      description: json['description'],
      vehicleImageUrl: json['vehicleImageUrl'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverProfileId': driverProfileId,
      'licensePlate': licensePlate,
      'make': make, // Corrected: send 'make' to backend
      'model': model,
      'year': year,
      'color': color,
      'type': type.name,
      'capacity': capacity,
      'hasAirConditioning': hasAirConditioning,
      'hasGps': hasGps,
      'hasBabySeat': hasBabySeat,
      'wheelchairAccessible': wheelchairAccessible,
      'description': description,
      'vehicleImageUrl': vehicleImageUrl,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Vehicle copyWith({
    int? id,
    int? driverProfileId,
    String? licensePlate,
    String? make,
    String? model,
    int? year,
    String? color,
    VehicleType? type,
    int? capacity,
    bool? hasAirConditioning,
    bool? hasGps,
    bool? hasBabySeat,
    bool? wheelchairAccessible,
    String? description,
    String? vehicleImageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      driverProfileId: driverProfileId ?? this.driverProfileId,
      licensePlate: licensePlate ?? this.licensePlate,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
      hasAirConditioning: hasAirConditioning ?? this.hasAirConditioning,
      hasGps: hasGps ?? this.hasGps,
      hasBabySeat: hasBabySeat ?? this.hasBabySeat,
      wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
      description: description ?? this.description,
      vehicleImageUrl: vehicleImageUrl ?? this.vehicleImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum para tipos de vehículo
enum VehicleType {
  SEDAN,
  SUV,
  HATCHBACK,
  PICKUP,
  VAN,
  COUPE,
  CONVERTIBLE,
  WAGON,
  TRUCK,
  MOTORCYCLE
}

/// Extensión para obtener nombres legibles de tipos de vehículo
extension VehicleTypeExtension on VehicleType {
  String get displayName {
    switch (this) {
      case VehicleType.SEDAN:
        return 'Sedán';
      case VehicleType.SUV:
        return 'SUV';
      case VehicleType.HATCHBACK:
        return 'Hatchback';
      case VehicleType.PICKUP:
        return 'Pickup';
      case VehicleType.VAN:
        return 'Van';
      case VehicleType.COUPE:
        return 'Coupé';
      case VehicleType.CONVERTIBLE:
        return 'Convertible';
      case VehicleType.WAGON:
        return 'Station Wagon';
      case VehicleType.TRUCK:
        return 'Camión';
      case VehicleType.MOTORCYCLE:
        return 'Motocicleta';
    }
  }
}

/// Modelo para solicitudes de creación de vehículo
class VehicleCreateRequest {
  final String licensePlate;
  final String make;
  final String model;
  final int year;
  final String color;
  final VehicleType vehicleType;
  final int capacity;
  final bool hasAirConditioning;
  final bool hasGps;
  final bool hasBabySeat;
  final bool wheelchairAccessible;
  final String? description;
  final String? vehicleImageUrl;

  VehicleCreateRequest({
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.vehicleType,
    required this.capacity,
    this.hasAirConditioning = false,
    this.hasGps = false,
    this.hasBabySeat = false,
    this.wheelchairAccessible = false,
    this.description,
    this.vehicleImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'vehicleType': vehicleType.name,
      'capacity': capacity,
      'hasAirConditioning': hasAirConditioning,
      'hasGps': hasGps,
      'hasBabySeat': hasBabySeat,
      'wheelchairAccessible': wheelchairAccessible,
      if (description != null) 'description': description,
      if (vehicleImageUrl != null) 'vehicleImageUrl': vehicleImageUrl,
    };
  }
}

/// Modelo para solicitudes de actualización de vehículo
class VehicleUpdateRequest {
  final String? licensePlate;
  final String? make;
  final String? model;
  final int? year;
  final String? color;
  final VehicleType? vehicleType;
  final int? capacity;
  final bool? hasAirConditioning;
  final bool? hasGps;
  final bool? hasBabySeat;
  final bool? wheelchairAccessible;
  final String? description;
  final String? vehicleImageUrl;

  VehicleUpdateRequest({
    this.licensePlate,
    this.make,
    this.model,
    this.year,
    this.color,
    this.vehicleType,
    this.capacity,
    this.hasAirConditioning,
    this.hasGps,
    this.hasBabySeat,
    this.wheelchairAccessible,
    this.description,
    this.vehicleImageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (licensePlate != null) data['licensePlate'] = licensePlate;
    if (make != null) data['make'] = make;
    if (model != null) data['model'] = model;
    if (year != null) data['year'] = year;
    if (color != null) data['color'] = color;
    if (vehicleType != null) data['vehicleType'] = vehicleType!.name;
    if (capacity != null) data['capacity'] = capacity;
    if (hasAirConditioning != null) data['hasAirConditioning'] = hasAirConditioning;
    if (hasGps != null) data['hasGps'] = hasGps;
    if (hasBabySeat != null) data['hasBabySeat'] = hasBabySeat;
    if (wheelchairAccessible != null) data['wheelchairAccessible'] = wheelchairAccessible;
    if (description != null) data['description'] = description;
    if (vehicleImageUrl != null) data['vehicleImageUrl'] = vehicleImageUrl;
    
    return data;
  }
}