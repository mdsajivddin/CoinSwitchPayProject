// To parse this JSON data, do
//
//     final getUserAllTicketListModel = getUserAllTicketListModelFromJson(jsonString);

import 'dart:convert';

GetUserAllTicketListModel getUserAllTicketListModelFromJson(String str) =>
    GetUserAllTicketListModel.fromJson(json.decode(str));

String getUserAllTicketListModelToJson(GetUserAllTicketListModel data) =>
    json.encode(data.toJson());

class GetUserAllTicketListModel {
  String? message;
  int? code;
  bool? error;
  List<Datum>? data;

  GetUserAllTicketListModel({this.message, this.code, this.error, this.data});

  factory GetUserAllTicketListModel.fromJson(Map<String, dynamic> json) =>
      GetUserAllTicketListModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "error": error,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? userId;
  List<String>? reasonPath;
  bool? issueResolved;
  String? status; // ← Changed to String
  String? priority;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  int? v;
  String? closeReason;
  String? resolutionReason;

  Datum({
    this.id,
    this.userId,
    this.reasonPath,
    this.issueResolved,
    this.status,
    this.priority,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.closeReason,
    this.resolutionReason,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    // userId: userIdValues.map[json["userId"]]!,
    userId: json["userId"]?.toString(),
    // reasonPath:
    //     json["reasonPath"] == null
    //         ? []
    //         : List<String>.from(json["reasonPath"]!.map((x) => x)),
    reasonPath:
        (json["reasonPath"] as List?)?.map((e) => e.toString()).toList() ?? [],
    issueResolved: json["issueResolved"],
    status: json["status"],
    priority: json["priority"],
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    closeReason: json["closeReason"],
    resolutionReason: json["resolutionReason"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userIdValues.reverse[userId],
    // "reasonPath":
    //     reasonPath == null
    //         ? []
    //         : List<dynamic>.from(
    //           reasonPath!.map((x) => reasonPathValues.reverse[x]),
    //         ),
    "reasonPath": reasonPath ?? [],
    "issueResolved": issueResolved,
    "status": statusValues.reverse[status],
    "priority": priorityValues.reverse[priority],
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "closeReason": closeReason,
    "resolutionReason": resolutionReason,
  };
}

enum Priority { MEDIUM }

final priorityValues = EnumValues({"medium": Priority.MEDIUM});

enum ReasonPath {
  BACK,
  DEPOSIT_ISSUE,
  DEPOSIT_PENDING,
  INR_DEPOSIT_ISSUE,
  NO_STILL_PENDING,
  USDT_DEPOSIT_ISSUE,
}

final reasonPathValues = EnumValues({
  "⬅️ Back": ReasonPath.BACK,
  "\ud83d\udce5 Deposit Issue": ReasonPath.DEPOSIT_ISSUE,
  "Deposit Pending": ReasonPath.DEPOSIT_PENDING,
  "INR Deposit Issue": ReasonPath.INR_DEPOSIT_ISSUE,
  "❌ No, still pending": ReasonPath.NO_STILL_PENDING,
  "USDT Deposit Issue": ReasonPath.USDT_DEPOSIT_ISSUE,
});

enum Status { CLOSED, OPEN, RESOLVED }

final statusValues = EnumValues({
  "closed": Status.CLOSED,
  "open": Status.OPEN,
  "resolved": Status.RESOLVED,
});

enum UserId { THE_69_A92_ADF6_B167_B42_C0_D3_ED46 }

final userIdValues = EnumValues({
  "69a92adf6b167b42c0d3ed46": UserId.THE_69_A92_ADF6_B167_B42_C0_D3_ED46,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
