/// Modelo para el perfil del conductor
class DriverProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final double rating;
  final int totalTrips;
  final int yearsExperience;
  final bool isVerified;
  final bool isAvailable;
  final bool isOnline;
  final String? profileImageUrl;
  final String? licenseNumber;
  final DateTime? licenseExpiryDate;
  final double dailyEarnings;
  final double weeklyEarnings;
  final double monthlyEarnings;  
  final double totalEarnings;
  final bool notificationsEnabled;
  final bool locationSharingEnabled;
  final bool autoAcceptRides;
  final String? preferredPaymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fullName;

  DriverProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.rating,
    required this.totalTrips,
    required this.yearsExperience,
    required this.isVerified,
    required this.isAvailable,
    required this.isOnline,
    this.profileImageUrl,
    this.licenseNumber,
    this.licenseExpiryDate,
    required this.dailyEarnings,
    required this.weeklyEarnings,
    required this.monthlyEarnings,
    required this.totalEarnings,
    required this.notificationsEnabled,
    required this.locationSharingEnabled,
    required this.autoAcceptRides,
    this.preferredPaymentMethod,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: _parseInt(json['id']) ?? 0,
      firstName: _parseString(json['firstName']) ?? '',
      lastName: _parseString(json['lastName']) ?? '',
      email: _parseString(json['email']) ?? '',
      phone: _parseString(json['phone']) ?? '',
      rating: _parseDouble(json['rating']) ?? 0.0,
      totalTrips: _parseInt(json['totalTrips']) ?? 0,
      yearsExperience: _parseInt(json['yearsExperience']) ?? 0,
      isVerified: _parseBool(json['isVerified']) ?? false,
      isAvailable: _parseBool(json['isAvailable']) ?? false,
      isOnline: _parseBool(json['isOnline']) ?? false,
      profileImageUrl: _parseString(json['profileImageUrl']),
      licenseNumber: _parseString(json['licenseNumber']),
      licenseExpiryDate: _parseDateTime(json['licenseExpiryDate']),
      dailyEarnings: _parseDouble(json['dailyEarnings']) ?? 0.0,
      weeklyEarnings: _parseDouble(json['weeklyEarnings']) ?? 0.0,
      monthlyEarnings: _parseDouble(json['monthlyEarnings']) ?? 0.0,
      totalEarnings: _parseDouble(json['totalEarnings']) ?? 0.0,
      notificationsEnabled: _parseBool(json['notificationsEnabled']) ?? true,
      locationSharingEnabled: _parseBool(json['locationSharingEnabled']) ?? true,
      autoAcceptRides: _parseBool(json['autoAcceptRides']) ?? false,
      preferredPaymentMethod: _parseString(json['preferredPaymentMethod']),
      createdAt: _parseDateTime(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt']) ?? DateTime.now(),
      fullName: _parseString(json['fullName']) ?? '',
    );
  }

  // Métodos auxiliares para parsing seguro
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('❌ Error parsing DateTime: $value - $e');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'rating': rating,
      'totalTrips': totalTrips,
      'yearsExperience': yearsExperience,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'isOnline': isOnline,
      'profileImageUrl': profileImageUrl,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': licenseExpiryDate?.toIso8601String(),
      'dailyEarnings': dailyEarnings,
      'weeklyEarnings': weeklyEarnings,
      'monthlyEarnings': monthlyEarnings,
      'totalEarnings': totalEarnings,
      'notificationsEnabled': notificationsEnabled,
      'locationSharingEnabled': locationSharingEnabled,
      'autoAcceptRides': autoAcceptRides,
      'preferredPaymentMethod': preferredPaymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'fullName': fullName,
    };
  }

  DriverProfile copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    double? rating,
    int? totalTrips,
    int? yearsExperience,
    bool? isVerified,
    bool? isAvailable,
    bool? isOnline,
    String? profileImageUrl,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    double? dailyEarnings,
    double? weeklyEarnings,
    double? monthlyEarnings,
    double? totalEarnings,
    bool? notificationsEnabled,
    bool? locationSharingEnabled,
    bool? autoAcceptRides,
    String? preferredPaymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fullName,
  }) {
    return DriverProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      dailyEarnings: dailyEarnings ?? this.dailyEarnings,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      monthlyEarnings: monthlyEarnings ?? this.monthlyEarnings,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationSharingEnabled: locationSharingEnabled ?? this.locationSharingEnabled,
      autoAcceptRides: autoAcceptRides ?? this.autoAcceptRides,
      preferredPaymentMethod: preferredPaymentMethod ?? this.preferredPaymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
    );
  }
}

/// Modelo para solicitudes de actualización de perfil
class DriverProfileUpdateRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? licenseNumber;
  final DateTime? licenseExpiryDate;
  final int? yearsExperience;
  final bool? isAvailable;
  final bool? isOnline;
  final String? profileImageUrl;

  DriverProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.licenseNumber,
    this.licenseExpiryDate,
    this.yearsExperience,
    this.isAvailable,
    this.isOnline,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (licenseNumber != null) data['licenseNumber'] = licenseNumber;
    if (licenseExpiryDate != null) data['licenseExpiryDate'] = licenseExpiryDate!.toIso8601String();
    if (yearsExperience != null) data['yearsExperience'] = yearsExperience;
    if (isAvailable != null) data['isAvailable'] = isAvailable;
    if (isOnline != null) data['isOnline'] = isOnline;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;
    
    return data;
  }
}