import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Modelo de datos para User desde/hacia la API
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    String? username,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String role,
    required bool active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Extensión para convertir entre UserModel y User entity
extension UserModelX on UserModel {
  User toEntity() {
    // Dividir fullName en firstName y lastName
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phoneNumber,
      role: role,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserX on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      username: email, // Usar email como username
      fullName: '$firstName $lastName'.trim(),
      email: email,
      phoneNumber: phone,
      role: role,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}