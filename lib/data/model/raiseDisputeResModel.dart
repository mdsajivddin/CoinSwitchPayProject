// To parse this JSON data, do
//
//     final raiseDsiputeResModel = raiseDsiputeResModelFromJson(jsonString);

import 'dart:convert';

RaiseDsiputeResModel raiseDsiputeResModelFromJson(String str) => RaiseDsiputeResModel.fromJson(json.decode(str));

String raiseDsiputeResModelToJson(RaiseDsiputeResModel data) => json.encode(data.toJson());

class RaiseDsiputeResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    RaiseDsiputeResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory RaiseDsiputeResModel.fromJson(Map<String, dynamic> json) => RaiseDsiputeResModel(
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
