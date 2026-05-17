class GlobalSettingsResponse {
  int? id;
  String? companyName;
  String? companyEmail;
  String? companyPhone;
  String? logo;
  String? logoFront;
  String? address;
  String? website;
  int? companiesSignup;
  String? activeSignupMessage;
  int? maxFileSize;

  GlobalSettingsResponse({
    this.id,
    this.companyName,
    this.companyEmail,
    this.companyPhone,
    this.logo,
    this.logoFront,
    this.address,
    this.website,
    this.companiesSignup,
    this.activeSignupMessage,
    this.maxFileSize,
  });

  GlobalSettingsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    companyEmail = json['company_email'];
    companyPhone = json['company_phone'];
    logo = json['logo'];
    logoFront = json['logo_front'];
    address = json['address'];
    website = json['website'];
    companiesSignup = json['companies_signup'];
    activeSignupMessage = json['active_signup_message'];
    if (json['max_file_size'] != null) {
      maxFileSize = int.tryParse(json['max_file_size'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['company_email'] = companyEmail;
    data['company_phone'] = companyPhone;
    data['logo'] = logo;
    data['logo_front'] = logoFront;
    data['address'] = address;
    data['website'] = website;
    data['companies_signup'] = companiesSignup;
    data['active_signup_message'] = activeSignupMessage;
    data['max_file_size'] = maxFileSize;
    return data;
  }
}
