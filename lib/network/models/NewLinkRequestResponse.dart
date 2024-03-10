class NewLinkRequestResponse {
  String status;
  NewLinkRequestDataBean data;

  NewLinkRequestResponse({required this.status, required this.data});

  NewLinkRequestResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = NewLinkRequestDataBean.fromJson(json['data']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data.toJson();
    return data;
  }
}

class NewLinkRequestDataBean {
  String building;
  String company;
  String message;
  Units? units;

  NewLinkRequestDataBean({required this.building, required this.company, required this.message, this.units});

  NewLinkRequestDataBean.fromJson(Map<String, dynamic> json)
      : building = json['building'],
        company = json['company'],
        message = json['message'],
        units = json['units'] != null ? Units.fromJson(json['units']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['building'] = this.building;
    data['company'] = this.company;
    data['message'] = this.message;
    if (this.units != null) {
      data['units'] = this.units!.toJson();
    }
    return data;
  }
}

class Units {
  int id;
  String code;
  String propertyName;

  Units({required this.id, required this.code, required this.propertyName});

  Units.fromJson(Map<String, dynamic> json)
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
