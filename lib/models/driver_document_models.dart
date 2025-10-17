/// Modelo para documentos del conductor
class DriverDocument {
  final int id;
  final int driverProfileId;
  final DocumentType type;
  final String documentNumber;
  final DateTime issueDate;
  final DateTime expiryDate;
  final String issuingAuthority;
  final DocumentStatus status;
  final String? imageUrl;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverDocument({
    required this.id,
    required this.driverProfileId,
    required this.type,
    required this.documentNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.issuingAuthority,
    required this.status,
    this.imageUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverDocument.fromJson(Map<String, dynamic> json) {
    return DriverDocument(
      id: json['id'] ?? 0,
      driverProfileId: json['driverProfileId'] ?? 0,
      type: DocumentType.values.firstWhere(
        (e) => e.name.toUpperCase() == (json['type'] ?? '').toString().toUpperCase(),
        orElse: () => DocumentType.DRIVERS_LICENSE,
      ),
      documentNumber: json['documentNumber'] ?? '',
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      issuingAuthority: json['issuingAuthority'] ?? '',
      status: DocumentStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == (json['status'] ?? '').toString().toUpperCase(),
        orElse: () => DocumentStatus.PENDING,
      ),
      imageUrl: json['imageUrl'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverProfileId': driverProfileId,
      'type': type.name,
      'documentNumber': documentNumber,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'issuingAuthority': issuingAuthority,
      'status': status.name,
      'imageUrl': imageUrl,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  DriverDocument copyWith({
    int? id,
    int? driverProfileId,
    DocumentType? type,
    String? documentNumber,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? issuingAuthority,
    DocumentStatus? status,
    String? imageUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverDocument(
      id: id ?? this.id,
      driverProfileId: driverProfileId ?? this.driverProfileId,
      type: type ?? this.type,
      documentNumber: documentNumber ?? this.documentNumber,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      issuingAuthority: issuingAuthority ?? this.issuingAuthority,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Verifica si el documento está próximo a vencer
  bool isExpiringSoon({int days = 30}) {
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    return daysUntilExpiry <= days && daysUntilExpiry >= 0;
  }

  /// Verifica si el documento está vencido
  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  /// Obtiene los días restantes hasta el vencimiento
  int get daysUntilExpiry {
    return expiryDate.difference(DateTime.now()).inDays;
  }
}

/// Enum para tipos de documento
enum DocumentType {
  DRIVERS_LICENSE,
  VEHICLE_REGISTRATION,
  SOAT,
  TECHNICAL_INSPECTION,
  CRIMINAL_BACKGROUND_CHECK,
  MEDICAL_CERTIFICATE,
  TAXI_PERMIT,
  INSURANCE_POLICY,
  OTHER
}

/// Extensión para obtener nombres legibles de tipos de documento
extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.DRIVERS_LICENSE:
        return 'Licencia de Conducir';
      case DocumentType.VEHICLE_REGISTRATION:
        return 'Tarjeta de Propiedad';
      case DocumentType.SOAT:
        return 'SOAT';
      case DocumentType.TECHNICAL_INSPECTION:
        return 'Revisión Técnica';
      case DocumentType.CRIMINAL_BACKGROUND_CHECK:
        return 'Antecedentes Penales';
      case DocumentType.MEDICAL_CERTIFICATE:
        return 'Certificado Médico';
      case DocumentType.TAXI_PERMIT:
        return 'Permiso de Taxi';
      case DocumentType.INSURANCE_POLICY:
        return 'Póliza de Seguros';
      case DocumentType.OTHER:
        return 'Otro';
    }
  }

  String get description {
    switch (this) {
      case DocumentType.DRIVERS_LICENSE:
        return 'Licencia válida para conducir vehículos';
      case DocumentType.VEHICLE_REGISTRATION:
        return 'Documento que acredita la propiedad del vehículo';
      case DocumentType.SOAT:
        return 'Seguro Obligatorio de Accidentes de Tránsito';
      case DocumentType.TECHNICAL_INSPECTION:
        return 'Certificado de revisión técnica vehicular';
      case DocumentType.CRIMINAL_BACKGROUND_CHECK:
        return 'Certificado de antecedentes penales';
      case DocumentType.MEDICAL_CERTIFICATE:
        return 'Certificado médico de aptitud';
      case DocumentType.TAXI_PERMIT:
        return 'Permiso municipal para operar como taxi';
      case DocumentType.INSURANCE_POLICY:
        return 'Póliza de seguros del vehículo';
      case DocumentType.OTHER:
        return 'Otro tipo de documento';
    }
  }
}

/// Enum para estados de documento
enum DocumentStatus {
  PENDING,
  APPROVED,
  REJECTED,
  EXPIRED,
  UNDER_REVIEW
}

/// Extensión para obtener nombres legibles de estados de documento
extension DocumentStatusExtension on DocumentStatus {
  String get displayName {
    switch (this) {
      case DocumentStatus.PENDING:
        return 'Pendiente';
      case DocumentStatus.APPROVED:
        return 'Aprobado';
      case DocumentStatus.REJECTED:
        return 'Rechazado';
      case DocumentStatus.EXPIRED:
        return 'Vencido';
      case DocumentStatus.UNDER_REVIEW:
        return 'En Revisión';
    }
  }

  String get description {
    switch (this) {
      case DocumentStatus.PENDING:
        return 'Documento en espera de revisión';
      case DocumentStatus.APPROVED:
        return 'Documento aprobado y válido';
      case DocumentStatus.REJECTED:
        return 'Documento rechazado';
      case DocumentStatus.EXPIRED:
        return 'Documento vencido';
      case DocumentStatus.UNDER_REVIEW:
        return 'Documento siendo revisado';
    }
  }
}

/// Modelo para solicitudes de creación de documento
class DriverDocumentCreateRequest {
  final DocumentType type;
  final String documentNumber;
  final DateTime issueDate;
  final DateTime expiryDate;
  final String issuingAuthority;
  final String? imageUrl;
  final String? notes;

  DriverDocumentCreateRequest({
    required this.type,
    required this.documentNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.issuingAuthority,
    this.imageUrl,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'documentNumber': documentNumber,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'issuingAuthority': issuingAuthority,
      'imageUrl': imageUrl,
      'notes': notes,
    };
  }
}

/// Modelo para solicitudes de actualización de documento
class DriverDocumentUpdateRequest {
  final DocumentType? type;
  final String? documentNumber;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String? issuingAuthority;
  final DocumentStatus? status;
  final String? imageUrl;
  final String? notes;

  DriverDocumentUpdateRequest({
    this.type,
    this.documentNumber,
    this.issueDate,
    this.expiryDate,
    this.issuingAuthority,
    this.status,
    this.imageUrl,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (type != null) data['type'] = type!.name;
    if (documentNumber != null) data['documentNumber'] = documentNumber;
    if (issueDate != null) data['issueDate'] = issueDate!.toIso8601String();
    if (expiryDate != null) data['expiryDate'] = expiryDate!.toIso8601String();
    if (issuingAuthority != null) data['issuingAuthority'] = issuingAuthority;
    if (status != null) data['status'] = status!.name;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    if (notes != null) data['notes'] = notes;
    
    return data;
  }
}