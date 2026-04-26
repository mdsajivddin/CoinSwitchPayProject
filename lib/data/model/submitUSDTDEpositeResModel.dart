// To parse this JSON data, do
//
//     final submitUsdtDepositeResModel = submitUsdtDepositeResModelFromJson(jsonString);

import 'dart:convert';

SubmitUsdtDepositeResModel submitUsdtDepositeResModelFromJson(String str) => SubmitUsdtDepositeResModel.fromJson(json.decode(str));

String submitUsdtDepositeResModelToJson(SubmitUsdtDepositeResModel data) => json.encode(data.toJson());

class SubmitUsdtDepositeResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    SubmitUsdtDepositeResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory SubmitUsdtDepositeResModel.fromJson(Map<String, dynamic> json) => SubmitUsdtDepositeResModel(
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
