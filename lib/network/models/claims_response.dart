class ClaimsResponse {
  List<ClaimsDataBean> data;
  Meta? meta;

  ClaimsResponse({required this.data, this.meta});

  ClaimsResponse.fromJson(Map<String, dynamic> json)
      : data = List<ClaimsDataBean>.from(
      json['data'].map((x) => ClaimsDataBean.fromJson(x))),
        meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class ClaimsDataBean {
  int id;
  String referenceId;
  String description;
  String availableDate;
  String availableTime;
  dynamic employeeId;
  String startDate;
  String endDate;
  String createdBy;
  String priority;
  String status;
  String createdAt;
  Unit? unit;
  Category? category;
  Category? subCategory;
  Category? type;

  ClaimsDataBean(
      {required this.id,
        required this.referenceId,
        required this.description,
        required this.availableDate,
        required this.availableTime,
        this.employeeId,
        required this.startDate,
        required this.endDate,
        required this.createdBy,
        required this.priority,
        required this.status,
        required this.createdAt,
        this.unit,
        this.category,
        this.subCategory,
        this.type});

  ClaimsDataBean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        referenceId = json['reference_id'],
        description = json['description'],
        availableDate = json['available_date'],
        availableTime = json['available_time'],
        employeeId = json['employee_id'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        createdBy = json['created_by'],
        priority = json['priority'],
        status = json['status'],
        createdAt = json['created_at'],
        unit = json['unit'] != null ? Unit.fromJson(json['unit']) : null,
        category = json['category'] != null
            ? Category.fromJson(json['category'])
            : null,
        subCategory = json['subCategory'] != null
            ? Category.fromJson(json['subCategory'])
            : null,
        type = json['type'] != null ? Category.fromJson(json['type']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['reference_id'] = this.referenceId;
    data['description'] = this.description;
    data['available_date'] = this.availableDate;
    data['available_time'] = this.availableTime;
    data['employee_id'] = this.employeeId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_by'] = this.createdBy;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['subCategory'] = this.subCategory!.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    return data;
  }
}

class Unit {
  int id;
  String code;
  String name;
  String type;
  String building;
  String startAt;
  String endAt;

  Unit(
      {required this.id,
        required this.code,
        required this.name,
        required this.type,
        required this.building,
        required this.startAt,
        required this.endAt});

  Unit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        name = json['name'],
        type = json['type'],
        building = json['building'],
        startAt = json['start_at'],
        endAt = json['end_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    data['building'] = this.building;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    return data;
  }
}

class Category {
  int id;
  String code;
  String name;

  Category({required this.id, required this.code, required this.name});

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        name = json['name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json)
      : pagination =
  json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;

  Pagination(
      {required this.total,
        required this.count,
        required this.perPage,
        required this.currentPage,
        required this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        count = json['count'],
        perPage = json['per_page'],
        currentPage = json['current_page'],
        totalPages = json['total_pages'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    return data;
  }
}
