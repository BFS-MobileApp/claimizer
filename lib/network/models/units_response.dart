class UnitsResponse {
  List<UnitsDataBean> data;
  Meta? meta;

  UnitsResponse({required this.data, this.meta});

  UnitsResponse.fromJson(Map<String, dynamic> json)
      : data = List<UnitsDataBean>.from(json['data'].map((x) => UnitsDataBean.fromJson(x))),
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

class UnitsDataBean {
  int id;
  String code;
  String name;
  String type;
  String company;
  int companyId;
  String building;
  String startAt;
  String endAt;

  UnitsDataBean({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.company,
    required this.companyId,
    required this.building,
    required this.startAt,
    required this.endAt,
  });

  UnitsDataBean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        name = json['name'],
        type = json['type'],
        company = json['company'],
        companyId = json['company_id'],
        building = json['building'],
        startAt = json['start_at'],
        endAt = json['end_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    data['company'] = this.company;
    data['company_id'] = this.companyId;
    data['building'] = this.building;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json)
      : pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;

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
  Links? links;

  Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
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
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    return data;
  }
}

class Links {
  String next;

  Links({required this.next});

  Links.fromJson(Map<String, dynamic> json) : next = json['next'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['next'] = this.next;
    return data;
  }
}
