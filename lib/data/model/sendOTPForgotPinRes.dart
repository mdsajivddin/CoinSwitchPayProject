// To parse this JSON data, do
//
//     final SendOtPforgotInRes = SendOtPforgotInResFromJson(jsonString);

import 'dart:convert';

SendOtPforgotInRes SendOtPforgotInResFromJson(String str) => SendOtPforgotInRes.fromJson(json.decode(str));

String SendOtPforgotInResToJson(SendOtPforgotInRes data) => json.encode(data.toJson());

class SendOtPforgotInRes {
    String? message;
    int? code;
    bool? error;
    Data? data;

    SendOtPforgotInRes({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory SendOtPforgotInRes.fromJson(Map<String, dynamic> json) => SendOtPforgotInRes(
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
    String? token;

    Data({
        this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
