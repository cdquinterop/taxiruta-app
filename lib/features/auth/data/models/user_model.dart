import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Modelo de datos para User desde/hacia la API
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    @JsonKey(name: 'firstName') required String firstName,
    @JsonKey(name: 'lastName') required String lastName,
    required String email,
    required String phone,
    required String role,
    required bool active,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Extensión para convertir entre UserModel y User entity
extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
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
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}