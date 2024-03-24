import 'dart:convert';

SocialMedialLogin socialMedialLoginFromJson(String str) =>
    SocialMedialLogin.fromJson(json.decode(str));

String socialMedialLoginToJson(SocialMedialLogin data) =>
    json.encode(data.toJson());

class SocialMedialLogin {
  final String token;
  final User user;

  SocialMedialLogin({
    required this.token,
    required this.user,
  });

  factory SocialMedialLogin.fromJson(Map<String, dynamic> json) =>
      SocialMedialLogin(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  final int? id;
  final String? refCode;
  final int? companyId;
  final dynamic falconCustomerId;
  final String? name;
  final String? email;
  final dynamic username;
  final dynamic fcmToken;
  final dynamic timezone;
  final dynamic image;
  final dynamic mobile;
  final String? gender;
  final String? locale;
  final String? status;
  final String? login;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? superAdmin;
  final dynamic emailVerificationCode;
  final String? socialToken;
  final int? emailNotifications;
  final dynamic countryId;
  final dynamic cityId;
  final dynamic stateId;
  final DateTime? emailVerifiedAt;
  final dynamic secondaryEmail;
  final int? secondaryEmailVerified;
  final dynamic deletedAt;
  final String? theme;
  final String? imageUrl;
  final List<String>? modules;
  final List<dynamic>? properties;
  final String? currentRoleName;
  final List<Role>? roles;

  User({
    this.id,
    this.refCode,
    this.companyId,
    this.falconCustomerId,
    this.name,
    this.email,
    this.username,
    this.fcmToken,
    this.timezone,
    this.image,
    this.mobile,
    this.gender,
    this.locale,
    this.status,
    this.login,
    this.createdAt,
    this.updatedAt,
    this.superAdmin,
    this.emailVerificationCode,
    this.socialToken,
    this.emailNotifications,
    this.countryId,
    this.cityId,
    this.stateId,
    this.emailVerifiedAt,
    this.secondaryEmail,
    this.secondaryEmailVerified,
    this.deletedAt,
    this.theme,
    this.imageUrl,
    this.modules,
    this.properties,
    this.currentRoleName,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    refCode: json["ref_code"],
    companyId: json["company_id"],
    falconCustomerId: json["falcon_customer_id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
    fcmToken: json["fcm_token"],
    timezone: json["timezone"],
    image: json["image"],
    mobile: json["mobile"],
    gender: json["gender"],
    locale: json["locale"],
    status: json["status"],
    login: json["login"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
    superAdmin: json["super_admin"],
    emailVerificationCode: json["email_verification_code"],
    socialToken: json["social_token"],
    emailNotifications: json["email_notifications"],
    countryId: json["country_id"],
    cityId: json["city_id"],
    stateId: json["state_id"],
    emailVerifiedAt: json["email_verified_at"] != null
        ? DateTime.parse(json["email_verified_at"])
        : null,
    secondaryEmail: json["secondary_email"],
    secondaryEmailVerified: json["secondary_email_verified"],
    deletedAt: json["deleted_at"],
    theme: json["theme"],
    imageUrl: json["image_url"],
    modules: List<String>.from(json["modules"].map((x) => x)),
    properties: List<dynamic>.from(json["properties"].map((x) => x)),
    currentRoleName: json["current_role_name"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ref_code": refCode,
    "company_id": companyId,
    "falcon_customer_id": falconCustomerId,
    "name": name,
    "email": email,
    "username": username,
    "fcm_token": fcmToken,
    "timezone": timezone,
    "image": image,
    "mobile": mobile,
    "gender": gender,
    "locale": locale,
    "status": status,
    "login": login,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "super_admin": superAdmin,
    "email_verification_code": emailVerificationCode,
    "social_token": socialToken,
    "email_notifications": emailNotifications,
    "country_id": countryId,
    "city_id": cityId,
    "state_id": stateId,
    "email_verified_at": emailVerifiedAt?.toIso8601String(),
    "secondary_email": secondaryEmail,
    "secondary_email_verified": secondaryEmailVerified,
    "deleted_at": deletedAt,
    "theme": theme,
    "image_url": imageUrl,
    "modules": modules,
    "properties": properties,
    "current_role_name": currentRoleName,
    "roles": roles?.map((x) => x.toJson()).toList(),
  };
}

class Role {
  final int? id;
  final int? companyId;
  final String? name;
  final String? displayName;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pivot? pivot;

  Role({
    this.id,
    this.companyId,
    this.name,
    this.displayName,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    companyId: json["company_id"],
    name: json["name"],
    displayName: json["display_name"],
    description: json["description"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
  "id": id,
  "company_id": companyId,
  "name": name,
  "display_name": displayName,
  "description": description,
  "created_at": createdAt?.toIso8601String(),
  "updated_at": updatedAt?.toIso8601String(),
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  final int? userId;
  final int? roleId;

  Pivot({
    this.userId,
    this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    userId: json["user_id"],
    roleId: json["role_id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "role_id": roleId,
  };
}

