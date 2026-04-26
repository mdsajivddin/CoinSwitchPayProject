// To parse this JSON data, do
//
//     final createSupportTicketResModel = createSupportTicketResModelFromJson(jsonString);

import 'dart:convert';

CreateSupportTicketResModel createSupportTicketResModelFromJson(String str) => CreateSupportTicketResModel.fromJson(json.decode(str));

String createSupportTicketResModelToJson(CreateSupportTicketResModel data) => json.encode(data.toJson());

class CreateSupportTicketResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    CreateSupportTicketResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory CreateSupportTicketResModel.fromJson(Map<String, dynamic> json) => CreateSupportTicketResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data?.toJson(),
    };
}

class Data {
    String? userId;
    List<String>? reasonPath;
    bool? issueResolved;
    String? status;
    String? priority;
    bool? isDisable;
    bool? isDeleted;
    String? id;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    Data({
        this.userId,
        this.reasonPath,
        this.issueResolved,
        this.status,
        this.priority,
        this.isDisable,
        this.isDeleted,
        this.id,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        reasonPath: json["reasonPath"] == null ? [] : List<String>.from(json["reasonPath"]!.map((x) => x)),
        issueResolved: json["issueResolved"],
        status: json["status"],
        priority: json["priority"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        id: json["_id"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "reasonPath": reasonPath == null ? [] : List<dynamic>.from(reasonPath!.map((x) => x)),
        "issueResolved": issueResolved,
        "status": status,
        "priority": priority,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "_id": id,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
