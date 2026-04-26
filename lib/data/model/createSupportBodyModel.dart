// To parse this JSON data, do
//
//     final createSupportTicketBodyModel = createSupportTicketBodyModelFromJson(jsonString);

import 'dart:convert';

CreateSupportTicketBodyModel createSupportTicketBodyModelFromJson(String str) => CreateSupportTicketBodyModel.fromJson(json.decode(str));

String createSupportTicketBodyModelToJson(CreateSupportTicketBodyModel data) => json.encode(data.toJson());

class CreateSupportTicketBodyModel {
    String? message;
    List<String>? reasonPath;

    CreateSupportTicketBodyModel({
        this.message,
        this.reasonPath,
    });

    factory CreateSupportTicketBodyModel.fromJson(Map<String, dynamic> json) => CreateSupportTicketBodyModel(
        message: json["message"],
        reasonPath: json["reasonPath"] == null ? [] : List<String>.from(json["reasonPath"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "reasonPath": reasonPath == null ? [] : List<dynamic>.from(reasonPath!.map((x) => x)),
    };
}
