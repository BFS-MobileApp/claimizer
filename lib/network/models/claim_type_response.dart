class ClaimTypeResponse {
  List<ClaimTypeDataBean>? data;

  ClaimTypeResponse({this.data});

  ClaimTypeResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ClaimTypeDataBean>[];
      json['data'].forEach((v) {
        data!.add(ClaimTypeDataBean.fromJson(v));
      });
    }
  }
}

class ClaimTypeDataBean {
  int? id;
  String? referenceId;
  String? name;

  ClaimTypeDataBean({this.id, this.referenceId, this.name});

  ClaimTypeDataBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceId = json['reference_id'];
    name = json['name'];
  }
}
