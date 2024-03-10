class NotificationResponse {
  String status;
  List<NotificationDataBean>? data;

  NotificationResponse({required this.status, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        data = json['data'] != null
            ? List<NotificationDataBean>.from(json['data'].map((x) => NotificationDataBean.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationDataBean {
  dynamic date;
  dynamic diffDate;
  List<Items>? items;

  NotificationDataBean({this.date, this.diffDate, this.items});

  NotificationDataBean.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        diffDate = json['diff_date'],
        items = json['items'] != null
            ? List<Items>.from(json['items'].map((x) => Items.fromJson(x)))
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['diff_date'] = this.diffDate;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  dynamic model;
  dynamic modelId;
  dynamic url;
  dynamic title;

  Items({this.model, this.modelId, this.url, this.title});

  Items.fromJson(Map<String, dynamic> json)
      : model = json['model'],
        modelId = json['model_id'],
        url = json['url'],
        title = json['title'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['model'] = this.model;
    data['model_id'] = this.modelId;
    data['url'] = this.url;
    data['title'] = this.title;
    return data;
  }
}
