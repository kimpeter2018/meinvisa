import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    String? nationality,
    String? occupation,
    String? purposeOfStay,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);

  factory UserModel.empty() => const UserModel(
    id: '',
    email: '',
    name: null,
    avatarUrl: null,
    nationality: null,
    occupation: null,
    purposeOfStay: null,
    createdAt: null,
  );
}
