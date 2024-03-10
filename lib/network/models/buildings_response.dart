class BuildingsResponse {
  List<BuildingsDataBean>? data;

  BuildingsResponse({this.data});

  BuildingsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>)
          .map((dynamic e) => BuildingsDataBean.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((BuildingsDataBean v) => v.toJson()).toList();
    }
    return data;
  }
}

class BuildingsDataBean {
  int? id;
  String? refCode;
  String? name;
  String? company;
  String? buildingCode;

  BuildingsDataBean({this.id, this.refCode, this.name, this.company, this.buildingCode});

  BuildingsDataBean.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    refCode = json['ref_code'] as String?;
    name = json['name'] as String?;
    company = json['company'] as String?;
    buildingCode = json['building_code'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ref_code'] = refCode;
    data['name'] = name;
    data['company'] = company;
    data['building_code'] = buildingCode;
    return data;
  }
}
