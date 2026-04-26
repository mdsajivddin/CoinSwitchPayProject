// To parse this JSON data, do
//
//     final cancelUsdtDepositResModel = cancelUsdtDepositResModelFromJson(jsonString);

import 'dart:convert';

CancelUsdtDepositResModel cancelUsdtDepositResModelFromJson(String str) => CancelUsdtDepositResModel.fromJson(json.decode(str));

String cancelUsdtDepositResModelToJson(CancelUsdtDepositResModel data) => json.encode(data.toJson());

class CancelUsdtDepositResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    CancelUsdtDepositResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory CancelUsdtDepositResModel.fromJson(Map<String, dynamic> json) => CancelUsdtDepositResModel(
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
