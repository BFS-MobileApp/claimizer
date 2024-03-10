class NewLinkListRequestResponse {
  String status;
  NewLinkListRequestDataBean? data;

  NewLinkListRequestResponse({required this.status, this.data});

  NewLinkListRequestResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null ? NewLinkListRequestDataBean.fromJson(json['data']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NewLinkListRequestDataBean {
  String building;
  String company;
  List<UnitsList>? units;

  NewLinkListRequestDataBean({required this.building, required this.company, this.units});

  NewLinkListRequestDataBean.fromJson(Map<String, dynamic> json)
      : building = json['building'],
        company = json['company'],
        units = json['units'] != null
            ? List<UnitsList>.from(json['units'].map((x) => UnitsList.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['building'] = this.building;
    data['company'] = this.company;
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnitsList {
  int id;
  String code;
  String propertyName;

  UnitsList({required this.id, required this.code, required this.propertyName});

  UnitsList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        propertyName = json['property_name'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['property_name'] = this.propertyName;
    return data;
  }
}
