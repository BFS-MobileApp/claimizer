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
            ? json['aboutToExpireUnits'] is Map<String, dynamic>
            ? (json['aboutToExpireUnits'] as Map<String, dynamic>)
            .values
            .map((x) => AboutToExpireUnits.fromJson(x))
            .toList()
            : [] // it's an empty list
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
  int? userId;
  int? unitId;
  String? startAt;
  String? endAt;
  String? createdAt;
  String? updatedAt;
  String? contractNumber;
  String? contractAttach;
  String? clientGovId;
  String? remarks;
  String? status;
  String? requestRemarks;
  String? statusNote;
  String? canceledAt;
  String? cancelReason;
  int? breaker;
  dynamic unit; // assuming `unit` is null or dynamic for now

  AboutToExpireUnits({
    this.id,
    this.refCode,
    this.userId,
    this.unitId,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
    this.contractNumber,
    this.contractAttach,
    this.clientGovId,
    this.remarks,
    this.status,
    this.requestRemarks,
    this.statusNote,
    this.canceledAt,
    this.cancelReason,
    this.breaker,
    this.unit,
  });

  AboutToExpireUnits.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        refCode = json['ref_code'],
        userId = json['user_id'],
        unitId = json['unit_id'],
        startAt = json['start_at'],
        endAt = json['end_at'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        contractNumber = json['contract_number'],
        contractAttach = json['contract_attach'],
        clientGovId = json['client_gov_id'],
        remarks = json['remarks'],
        status = json['status'],
        requestRemarks = json['request_remarks'],
        statusNote = json['status_note'],
        canceledAt = json['canceled_at'],
        cancelReason = json['cancel_reason'],
        breaker = json['breaker'],
        unit = json['unit']; // keep this dynamic until structure is known

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['ref_code'] = refCode;
    data['user_id'] = userId;
    data['unit_id'] = unitId;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['contract_number'] = contractNumber;
    data['contract_attach'] = contractAttach;
    data['client_gov_id'] = clientGovId;
    data['remarks'] = remarks;
    data['status'] = status;
    data['request_remarks'] = requestRemarks;
    data['status_note'] = statusNote;
    data['canceled_at'] = canceledAt;
    data['cancel_reason'] = cancelReason;
    data['breaker'] = breaker;
    data['unit'] = unit;
    return data;
  }
}

