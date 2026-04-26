// To parse this JSON data, do
//
//     final forgotPassResModel = forgotPassResModelFromJson(jsonString);

import 'dart:convert';

ForgotPassResModel forgotPassResModelFromJson(String str) => ForgotPassResModel.fromJson(json.decode(str));

String forgotPassResModelToJson(ForgotPassResModel data) => json.encode(data.toJson());

class ForgotPassResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    ForgotPassResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory ForgotPassResModel.fromJson(Map<String, dynamic> json) => ForgotPassResModel(
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
