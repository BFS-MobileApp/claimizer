class ClaimDetailsResponse {
  ClaimsDetailsDataBean? data;

  ClaimDetailsResponse({this.data});

  ClaimDetailsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? ClaimsDetailsDataBean.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ClaimsDetailsDataBean {
  int id;
  String referenceId;
  String status;
  String description;
  String availableDate;
  String availableTime;
  dynamic employeeId;
  String startDate;
  String endDate;
  String createdBy;
  String priority;
  dynamic rate;
  dynamic feedback;
  String createdAt;
  List<dynamic>? files;
  Unit? unit;
  Category? category;
  Category? subCategory;
  Category? type;
  Comments? comments;

  ClaimsDetailsDataBean({
    required this.id,
    required this.referenceId,
    required this.status,
    required this.description,
    required this.availableDate,
    required this.availableTime,
    this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.priority,
    this.rate,
    this.feedback,
    required this.createdAt,
    this.files,
    this.unit,
    this.category,
    this.subCategory,
    this.type,
    this.comments,
  });

  ClaimsDetailsDataBean.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        referenceId = json['reference_id'],
        status = json['status'] ,
        description = json['description'] ,
        availableDate = json['available_date'] ,
        availableTime = json['available_time'] ,
        employeeId = json['employee_id'],
        startDate = json['start_date'] ,
        endDate = json['end_date'] ,
        createdBy = json['created_by'] ,
        priority = json['priority'] ,
        rate = json['rate'],
        feedback = json['feedback'],
        createdAt = json['created_at'] ,
        files = (json['files'] as List<dynamic>?) ?? [],
        unit = json['unit'] != null ? Unit.fromJson(json['unit'] as Map<String, dynamic>) : null,
        category = json['category'] != null ? Category.fromJson(json['category'] as Map<String, dynamic>) : null,
        subCategory = json['subCategory'] != null ? Category.fromJson(json['subCategory'] as Map<String, dynamic>) : null,
        type = json['type'] != null ? Category.fromJson(json['type'] as Map<String, dynamic>) : null,
        comments = json['comments'] is List
            ? (json['comments'].isEmpty ? Comments(data: []) : Comments(data: (json['comments'] as List).map((item) => CommentsData.fromJson(item)).toList()))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'reference_id': referenceId,
      'status': status,
      'description': description,
      'available_date': availableDate,
      'available_time': availableTime,
      'employee_id': employeeId,
      'start_date': startDate,
      'end_date': endDate,
      'created_by': createdBy,
      'priority': priority,
      'rate': rate,
      'feedback': feedback,
      'created_at': createdAt,
      'files': files,
    };
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['subCategory'] = subCategory!.toJson();
    }
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (comments != null) {
      data['comments'] = comments!.toJson();
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

  Unit({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.building,
    required this.startAt,
    required this.endAt,
  });

  Unit.fromJson(Map<String, dynamic> json) :
        id = json['id'] ,
        code = json['code'] ,
        name = json['name'] ,
        type = json['type'] ,
        building = json['building'] ,
        startAt = json['start_at'] ,
        endAt = json['end_at'] ;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'type': type,
      'building': building,
      'start_at': startAt,
      'end_at': endAt,
    };
  }
}

class Category {
  int id;
  String code;
  String name;

  Category({
    required this.id,
    required this.code,
    required this.name,
  });

  Category.fromJson(Map<String, dynamic> json) :
        id = json['id'] ,
        code = json['code'] ,
        name = json['name'] ;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
    };
  }
}

class Comments {
  List<CommentsData> data;

  Comments({required this.data});

  Comments.fromJson(Map<String, dynamic> json) :
        data = (json['data'] )
            .map((dynamic e) => CommentsData.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.map((CommentsData v) => v.toJson()).toList(),
    };
  }
}

class CommentsData {
  int id;
  String comment;
  int user_id;
  String createdAt;
  String updated_at;

  CommentsData({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.user_id,
    required this.updated_at
  });

  CommentsData.fromJson(Map<String, dynamic> json) :
        id = json['id'] ??0,
        comment = json['comment'] ??'',
        createdAt = json['created_at']??'',
        updated_at = json['updated_at']??'',
        user_id = json['user_id']??0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'created_at': createdAt,
      'user_id':user_id,
      'updated_at':updated_at
    };
  }
}

class User {
  UserData data;

  User({required this.data});

  User.fromJson(Map<String, dynamic> json) :
        data = UserData.fromJson(json['data']);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.toJson(),
    };
  }
}

class UserData {
  int id;
  String refCode;
  String name;
  String email;
  String avatar;

  UserData({
    required this.id,
    required this.refCode,
    required this.name,
    required this.email,
    required this.avatar,
  });

  UserData.fromJson(Map<String, dynamic> json) :
        id = json['id'] ,
        refCode = json['ref_code'] ,
        name = json['name'] ,
        email = json['email'] ,
        avatar = json['avatar'] ;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ref_code': refCode,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }
}
