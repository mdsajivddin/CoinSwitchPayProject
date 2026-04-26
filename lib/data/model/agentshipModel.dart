// To parse this JSON data, do
//
//     final agentshipModel = agentshipModelFromJson(jsonString);

import 'dart:convert';

AgentshipModel agentshipModelFromJson(String str) => AgentshipModel.fromJson(json.decode(str));

String agentshipModelToJson(AgentshipModel data) => json.encode(data.toJson());

class AgentshipModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    AgentshipModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory AgentshipModel.fromJson(Map<String, dynamic> json) => AgentshipModel(
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
    String? id;
    String? applicantUserId;
    String? telegramId;
    List<TeamMember>? teamMembers;
    int? commissionPercent;
    String? status;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;

    Data({
        this.id,
        this.applicantUserId,
        this.telegramId,
        this.teamMembers,
        this.commissionPercent,
        this.status,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        applicantUserId: json["applicantUserId"],
        telegramId: json["telegramId"],
        teamMembers: json["teamMembers"] == null ? [] : List<TeamMember>.from(json["teamMembers"]!.map((x) => TeamMember.fromJson(x))),
        commissionPercent: json["commissionPercent"],
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "applicantUserId": applicantUserId,
        "telegramId": telegramId,
        "teamMembers": teamMembers == null ? [] : List<dynamic>.from(teamMembers!.map((x) => x.toJson())),
        "commissionPercent": commissionPercent,
        "status": status,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
    };
}

class TeamMember {
    String? userId;
    String? imageUrl;
    String? status;
    String? id;

    TeamMember({
        this.userId,
        this.imageUrl,
        this.status,
        this.id,
    });

    factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        userId: json["userId"],
        imageUrl: json["imageUrl"],
        status: json["status"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "imageUrl": imageUrl,
        "status": status,
        "_id": id,
    };
}
