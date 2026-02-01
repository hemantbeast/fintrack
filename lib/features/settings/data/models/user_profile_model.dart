import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel extends HiveObject {
  UserProfileModel({
    this.id,
    this.name,
    this.email,
    this.avatar,
  });

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
    );
  }

  factory UserProfileModel.fromJson(JSON json) => _$UserProfileModelFromJson(json);

  JSON toJson() => _$UserProfileModelToJson(this);

  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'avatar')
  String? avatar;

  UserProfile toEntity() {
    return UserProfile(
      id: id ?? '',
      name: name ?? '',
      email: email ?? '',
      avatar: avatar,
    );
  }
}
