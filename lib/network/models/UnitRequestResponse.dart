class UnitRequestsResponse {
  List<UnitRequestDataBean>? data;
  Meta? meta;

  UnitRequestsResponse({this.data, this.meta});

  UnitRequestsResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'] != null
      ? List<UnitRequestDataBean>.from(json['data'].map((x) => UnitRequestDataBean.fromJson(x)))
      : null,
        meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class UnitRequestDataBean {
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
  String? userRemarks;
  String? adminRemarks;
  String? createdAt;

  UnitRequestDataBean({
    this.id,
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
  });

  UnitRequestDataBean.fromJson(Map<String, dynamic> json)
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
        createdAt = json['created_at'];

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
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) : pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;
  Links? links;

  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.links,
  });

  Pagination.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        count = json['count'],
        perPage = json['per_page'],
        currentPage = json['current_page'],
        totalPages = json['total_pages'],
        links = json['links'] != null ? Links.fromJson(json['links']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = total;
    data['count'] = count;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }
}

class Links {
  String? next;

  Links({this.next});

  Links.fromJson(Map<String, dynamic> json) : next = json['next'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['next'] = next;
    return data;
  }
}
