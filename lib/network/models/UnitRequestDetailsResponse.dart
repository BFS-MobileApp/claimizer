class UnitRequestDetailsResponse {
  UnitRequestDetailsDataBean? data;

  UnitRequestDetailsResponse({this.data});

  UnitRequestDetailsResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'] != null ? UnitRequestDetailsDataBean.fromJson(json['data']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UnitRequestDetailsDataBean {
  int? id;
  String? refCode;
  int? userId;
  int? unitId;
  String? unitName;
  String? buildingName;
  String? unitType;
  String? company;
  String? startAt;
  String? endAt;
  String? contractNumber;
  String? contractAttach;
  String? clientGovId;
  String? status;
  dynamic userRemarks;
  dynamic adminRemarks;
  String? createdAt;
  UnitRequestDetailsResponse? user;
  List<Comments>? comments;

  UnitRequestDetailsDataBean(
      {this.id,
        this.refCode,
        this.userId,
        this.unitId,
        this.unitName,
        this.buildingName,
        this.unitType,
        this.company,
        this.startAt,
        this.endAt,
        this.contractNumber,
        this.contractAttach,
        this.clientGovId,
        this.status,
        this.userRemarks,
        this.adminRemarks,
        this.createdAt,
        this.user,
        this.comments});

  UnitRequestDetailsDataBean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        refCode = json['ref_code'],
        userId = json['user_id'],
        unitId = json['unit_id'],
        unitName = json['unit_name'],
        buildingName = json['building_name'],
        unitType = json['unit_type'],
        company = json['company'],
        startAt = json['start_at'],
        endAt = json['end_at'],
        contractNumber = json['contract_number'],
        contractAttach = json['contract_attach'],
        clientGovId = json['client_gov_id'],
        status = json['status'],
        userRemarks = json['user_remarks'],
        adminRemarks = json['admin_remarks'],
        createdAt = json['created_at'],
        user = json['user'] != null ? UnitRequestDetailsResponse.fromJson(json['user']) : null,
        comments = json['comments'] != null
            ? List<Comments>.from(json['comments'].map((x) => Comments.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['ref_code'] = refCode;
    data['user_id'] = userId;
    data['unit_id'] = unitId;
    data['unit_name'] = unitName;
    data['building_name'] = buildingName;
    data['unit_type'] = unitType;
    data['company'] = company;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['contract_number'] = contractNumber;
    data['contract_attach'] = contractAttach;
    data['client_gov_id'] = clientGovId;
    data['status'] = status;
    data['user_remarks'] = userRemarks;
    data['admin_remarks'] = adminRemarks;
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (comments != null) {
      data['comments'] = comments!.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  int? id;
  String? content;
  User? user;
  String? createdAt;
  List<String>? files;

  Comments({this.id, this.content, this.user, this.createdAt, this.files});

  Comments.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        user = json['user'] != null ? User.fromJson(json['user']) : null,
        createdAt = json['created_at'],
        files = json['files'] != null ? List<String>.from(json['files']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['content'] = content;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['created_at'] = createdAt;
    data['files'] = files;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? avatar;

  User({this.id, this.name, this.avatar});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}
