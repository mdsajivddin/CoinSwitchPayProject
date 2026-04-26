// To parse this JSON data, do
//
//     final forgotPinVerifyRes = forgotPinVerifyResFromJson(jsonString);

import 'dart:convert';

ForgotPinVerifyRes forgotPinVerifyResFromJson(String str) => ForgotPinVerifyRes.fromJson(json.decode(str));

String forgotPinVerifyResToJson(ForgotPinVerifyRes data) => json.encode(data.toJson());

class ForgotPinVerifyRes {
    String? message;
    int? code;
    bool? error;
    int? data;

    ForgotPinVerifyRes({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory ForgotPinVerifyRes.fromJson(Map<String, dynamic> json) => ForgotPinVerifyRes(
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
