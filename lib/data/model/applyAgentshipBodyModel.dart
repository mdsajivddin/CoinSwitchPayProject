// To parse this JSON data, do
//
//     final applyAgentshipBodyModel = applyAgentshipBodyModelFromJson(jsonString);

import 'dart:convert';

ApplyAgentshipBodyModel applyAgentshipBodyModelFromJson(String str) => ApplyAgentshipBodyModel.fromJson(json.decode(str));

String applyAgentshipBodyModelToJson(ApplyAgentshipBodyModel data) => json.encode(data.toJson());

class ApplyAgentshipBodyModel {
    String? applicantUserId;
    String? telegramId;
    List<TeamMember>? teamMembers;

    ApplyAgentshipBodyModel({
        this.applicantUserId,
        this.telegramId,
        this.teamMembers,
    });

    factory ApplyAgentshipBodyModel.fromJson(Map<String, dynamic> json) => ApplyAgentshipBodyModel(
        applicantUserId: json["applicantUserId"],
        telegramId: json["telegramId"],
        teamMembers: json["teamMembers"] == null ? [] : List<TeamMember>.from(json["teamMembers"]!.map((x) => TeamMember.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "applicantUserId": applicantUserId,
        "telegramId": telegramId,
        "teamMembers": teamMembers == null ? [] : List<dynamic>.from(teamMembers!.map((x) => x.toJson())),
    };
}

class TeamMember {
    String? userId;
    String? imageUrl;

    TeamMember({
        this.userId,
        this.imageUrl,
    });

    factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        userId: json["userId"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "imageUrl": imageUrl,
    };
}
