// To parse this JSON data, do
//
//     final applyAgentshipResModel = applyAgentshipResModelFromJson(jsonString);

import 'dart:convert';

ApplyAgentshipResModel applyAgentshipResModelFromJson(String str) => ApplyAgentshipResModel.fromJson(json.decode(str));

String applyAgentshipResModelToJson(ApplyAgentshipResModel data) => json.encode(data.toJson());

class ApplyAgentshipResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    ApplyAgentshipResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory ApplyAgentshipResModel.fromJson(Map<String, dynamic> json) => ApplyAgentshipResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data,
    };
}
