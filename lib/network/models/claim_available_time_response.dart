class ClaimAvailableTimeResponse {
  List<ClaimAvailableTimeDataBean>? data;

  ClaimAvailableTimeResponse({this.data});

  ClaimAvailableTimeResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>)
          .map((dynamic e) => ClaimAvailableTimeDataBean.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((ClaimAvailableTimeDataBean v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimAvailableTimeDataBean {
  int id;
  String referenceId;
  String name;

  ClaimAvailableTimeDataBean({required this.id, required this.referenceId, required this.name});

  ClaimAvailableTimeDataBean.fromJson(Map<String, dynamic> json) :
        id = json['id'] as int,
        referenceId = json['reference_id'] as String,
        name = json['name'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference_id'] = referenceId;
    data['name'] = name;
    return data;
  }
}
