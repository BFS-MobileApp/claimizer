class ProfileResponse {
  ProfileDataBean? profileDataBean;

  ProfileResponse({this.profileDataBean});

  ProfileResponse.fromJson(Map<String, dynamic> json)
      : profileDataBean = json['data'] != null ? ProfileDataBean.fromJson(json['data']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (profileDataBean != null) {
      data['data'] = profileDataBean!.toJson();
    }
    return data;
  }
}

class ProfileDataBean {
  int id;
  String refCode;
  String name;
  String email;
  String avatar;
  Profile? profile;

  ProfileDataBean(
      {required this.id,
        required this.refCode,
        required this.name,
        required this.email,
        required this.avatar,
        this.profile});

  ProfileDataBean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        refCode = json['ref_code'],
        name = json['name']??'',
        email = json['email'],
        avatar = json['avatar'],
        profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['ref_code'] = refCode;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? timezone;
  String? mobile;
  String? gender;
  String? locale;
  String? status;
  dynamic emailNotifications;
  bool? emailVerified;
  dynamic secondaryEmail;
  dynamic secondaryEmailVerified;

  Profile(
      {this.timezone,
        this.mobile,
        this.gender,
        this.locale,
        this.status,
        this.emailNotifications,
        this.emailVerified,
        this.secondaryEmail,
        this.secondaryEmailVerified});

  Profile.fromJson(Map<String, dynamic> json)
      : timezone = json['timezone'],
        mobile = json['mobile']??'',
        gender = json['gender'],
        locale = json['locale'],
        status = json['status'],
        emailNotifications = json['email_notifications'],
        emailVerified = json['email_verified'],
        secondaryEmail = json['secondary_email'],
        secondaryEmailVerified = json['secondary_email_verified'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['timezone'] = timezone;
    data['mobile'] = mobile;
    data['gender'] = gender;
    data['locale'] = locale;
    data['status'] = status;
    data['email_notifications'] = emailNotifications;
    data['email_verified'] = emailVerified;
    data['secondary_email'] = secondaryEmail;
    data['secondary_email_verified'] = secondaryEmailVerified;
    return data;
  }
}
