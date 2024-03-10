class StatisticsResponse {
  int? status;
  Data? data;

  StatisticsResponse({this.status, this.data});

  StatisticsResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null ? Data.fromJson(json['data']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Claims? claims;
  ClaimColor? claimColor;
  List<AboutToExpireUnits>? aboutToExpireUnits;

  Data({this.claims, this.claimColor, this.aboutToExpireUnits});

  Data.fromJson(Map<String, dynamic> json)
      : claims = json['claims'] != null ? Claims.fromJson(json['claims']) : null,
        claimColor = json['claim_color'] != null ? ClaimColor.fromJson(json['claim_color']) : null,
        aboutToExpireUnits = json['aboutToExpireUnits'] != null
            ? List<AboutToExpireUnits>.from(json['aboutToExpireUnits'].map((x) => AboutToExpireUnits.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (claims != null) {
      data['claims'] = claims!.toJson();
    }
    if (claimColor != null) {
      data['claim_color'] = claimColor!.toJson();
    }
    if (aboutToExpireUnits != null) {
      data['aboutToExpireUnits'] = aboutToExpireUnits!.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

class Claims {
  int? all;
  int? newClaims;
  int? assigned;
  int? inProgress;
  int? completed;
  int? closed;
  int? cancelled;

  Claims({this.all, this.newClaims, this.assigned, this.inProgress, this.completed, this.closed, this.cancelled});

  Claims.fromJson(Map<String, dynamic> json)
      : all = json['all'],
        newClaims = json['new'],
        assigned = json['assigned'],
        inProgress = json['in_progress'],
        completed = json['completed'],
        closed = json['closed'],
        cancelled = json['cancelled'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['all'] = all;
    data['new'] = newClaims;
    data['assigned'] = assigned;
    data['in_progress'] = inProgress;
    data['completed'] = completed;
    data['closed'] = closed;
    data['cancelled'] = cancelled;
    return data;
  }
}

class ClaimColor {
  String? newClaims;
  String? assigned;
  String? started;
  String? completed;
  String? closed;
  String? cancelled;

  ClaimColor({this.newClaims, this.assigned, this.started, this.completed, this.closed, this.cancelled});

  ClaimColor.fromJson(Map<String, dynamic> json)
      : newClaims = json['new'],
        assigned = json['assigned'],
        started = json['started'],
        completed = json['completed'],
        closed = json['closed'],
        cancelled = json['cancelled'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['new'] = newClaims;
    data['assigned'] = assigned;
    data['started'] = started;
    data['completed'] = completed;
    data['closed'] = closed;
    data['cancelled'] = cancelled;
    return data;
  }
}

class AboutToExpireUnits {
  int? id;
  String? refCode;
  String? propertyName;
  String? queryCode;
  String? startAt;
  String? endAt;
  String? requestStartAt;
  String? requestEndAt;

  AboutToExpireUnits(
      {this.id,
        this.refCode,
        this.propertyName,
        this.queryCode,
        this.startAt,
        this.endAt,
        this.requestStartAt,
        this.requestEndAt});

  AboutToExpireUnits.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        refCode = json['ref_code'],
        propertyName = json['property_name'],
        queryCode = json['query_code'],
        startAt = json['start_at'],
        endAt = json['end_at'],
        requestStartAt = json['request_start_at'],
        requestEndAt = json['request_end_at'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['ref_code'] = refCode;
    data['property_name'] = propertyName;
    data['query_code'] = queryCode;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['request_start_at'] = requestStartAt;
    data['request_end_at'] = requestEndAt;
    return data;
  }
}
