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
  List<Employee> employees;
  List<Logs> logs;
  List<Time> times;

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
    required this.times,
    required this.employees,
    required this.logs,
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
        comments = json['comments'] != null ? Comments.fromJson(json['comments']) : null,
        employees = json['employees'] != null
            ? List<Employee>.from((json['employees'] as List).map((e) => Employee.fromJson(e)))
            : [],
        times = json['times'] != null
            ? List<Time>.from((json['times'] as List).map((e) => Time.fromJson(e)))
            : [],
        logs = json['logs'] != null
            ? List<Logs>.from((json['logs'] as List).map((e) => Logs.fromJson(e)))
            : [];



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
class TimeCreatedBy {
  int id;
  String name;
  String avatar;

  TimeCreatedBy({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory TimeCreatedBy.fromJson(Map<String, dynamic> json) => TimeCreatedBy(
    id: json["id"]??0,
    name: json["name"]??'',
    avatar: json["avatar"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
  };
}
class CreatedBy {
  int id;
  String name;

  CreatedBy({
    required this.id,
    required this.name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["id"]??0,
    name: json["name"]??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
class Time {
  int id;
  String startOn;
  String endOn;
  TimeCreatedBy createdBy;

  Time({
    required this.id,
    required this.startOn,
    required this.endOn,
    required this.createdBy,
  });

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    id: json["id"]??0,
    startOn: json["start_on"]??'',
    endOn: json["end_on"]??'',
    createdBy: TimeCreatedBy.fromJson(json["created_by"]??''),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_on": startOn,
    "end_on": endOn,
    "created_by": createdBy.toJson(),
  };
}
class Logs {
  String name;
  dynamic badge;
  String createdAt;
  dynamic reason;
  CreatedBy createdBy;

  Logs({
    required this.name,
    required this.badge,
    required this.createdAt,
    required this.reason,
    required this.createdBy,
  });

  factory Logs.fromJson(Map<String, dynamic> json) => Logs(
    name: json["name"]??'',
    badge: json["badge"]??'',
    createdAt: json["created_at"]??'',
    reason: json["reason"]??'',
    createdBy: CreatedBy.fromJson(json["created_by"]??{}),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "badge": badge,
    "created_at": createdAt,
    "reason": reason,
    "created_by": createdBy.toJson(),
  };
}
class Employee {
  int id;
  String name;
  String imageUrl;
  String created_at;

  Employee({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.created_at
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    imageUrl: json["image_url"] ?? '',
    created_at: json["created_at"] ??'',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "created_at":created_at
  };
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

  Comments.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List<dynamic>)
      .map((e) => CommentsData.fromJson(e))
      .toList();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}
class CommentsData {
  int id;
  String comment;
  String createdAt;
  User user;
  List<dynamic>? files;

  CommentsData({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.user,
    required this.files
  });

  CommentsData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        comment = json['comment'] ?? '',
        createdAt = json['created_at'] ?? '',
        files = json['files'],
        user = User.fromJson(json['user']);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'created_at': createdAt,
      'user': user.toJson(),
      'files':files
    };
  }
}
class User {
  UserData data;

  User({required this.data});

  User.fromJson(Map<String, dynamic> json)
      : data = UserData.fromJson(json['data']);

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
        id = json['id'] ??0,
        refCode = json['ref_code'] ??'',
        name = json['name']??'' ,
        email = json['email'] ??'' ,
        avatar = json['avatar'] ??'' ;

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
