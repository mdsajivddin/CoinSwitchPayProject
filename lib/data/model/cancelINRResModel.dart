// To parse this JSON data, do
//
//     final cancelInrDepositeResModel = cancelInrDepositeResModelFromJson(jsonString);

import 'dart:convert';

CancelInrDepositeResModel cancelInrDepositeResModelFromJson(String str) => CancelInrDepositeResModel.fromJson(json.decode(str));

String cancelInrDepositeResModelToJson(CancelInrDepositeResModel data) => json.encode(data.toJson());

class CancelInrDepositeResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    CancelInrDepositeResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory CancelInrDepositeResModel.fromJson(Map<String, dynamic> json) => CancelInrDepositeResModel(
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
