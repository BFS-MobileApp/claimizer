import 'dart:convert';

EmergencyModel emergencyModelFromJson(String str) => EmergencyModel.fromJson(json.decode(str));

String emergencyModelToJson(EmergencyModel data) => json.encode(data.toJson());

class EmergencyModel {
  bool status;
  Data data;

  EmergencyModel({
    required this.status,
    required this.data,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic> json) => EmergencyModel(
    status: json["status"] ?? false,
    data: Data.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<Company> companies;

  Data({
    required this.companies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    companies: json["companies"] == null
        ? []
        : List<Company>.from(json["companies"].map((x) => Company.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companies": List<dynamic>.from(companies.map((x) => x.toJson())),
  };
}

class Company {
  String company;
  String availableFrom;
  String availableTo;
  List<EmergencyContact> emergencyContacts;

  Company({
    required this.company,
    required this.availableFrom,
    required this.availableTo,
    required this.emergencyContacts,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    company: json["company"] ?? '',
    availableFrom: json["available_from"]?? "10:00 AM",
    availableTo: json["available_to"] ?? "08:00 AM",
    emergencyContacts: json["emergency_contacts"] == null
        ? []
        : List<EmergencyContact>.from(json["emergency_contacts"].map((x) => EmergencyContact.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "company": company,
    "available_from": availableFrom,
    "available_to": availableTo,
    "emergency_contacts": List<dynamic>.from(emergencyContacts.map((x) => x.toJson())),
  };
}

class EmergencyContact {
  String title;
  String number;
  String availableFrom;
  String availableTo;

  EmergencyContact({
    required this.title,
    required this.number,
    required this.availableFrom,
    required this.availableTo,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) => EmergencyContact(
    title: json["title"] ?? '',
    number: json["number"] ?? '',
    availableFrom: json["available_from"] ?? '',
    availableTo: json["available_to"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "number": number,
    "available_from": availableFrom,
    "available_to": availableTo,
  };
}
