// To parse this JSON data, do
//
//     final forgotSendOtpResModel = forgotSendOtpResModelFromJson(jsonString);

import 'dart:convert';

ForgotSendOtpResModel forgotSendOtpResModelFromJson(String str) => ForgotSendOtpResModel.fromJson(json.decode(str));

String forgotSendOtpResModelToJson(ForgotSendOtpResModel data) => json.encode(data.toJson());

class ForgotSendOtpResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    ForgotSendOtpResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory ForgotSendOtpResModel.fromJson(Map<String, dynamic> json) => ForgotSendOtpResModel(
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


// To parse this JSON data, do
//
//     final forgotSendOtpBodyModel = forgotSendOtpBodyModelFromJson(jsonString);


ForgotSendOtpBodyModel forgotSendOtpBodyModelFromJson(String str) => ForgotSendOtpBodyModel.fromJson(json.decode(str));

String forgotSendOtpBodyModelToJson(ForgotSendOtpBodyModel data) => json.encode(data.toJson());

class ForgotSendOtpBodyModel {
    String? loginType;

    ForgotSendOtpBodyModel({
        this.loginType,
    });

    factory ForgotSendOtpBodyModel.fromJson(Map<String, dynamic> json) => ForgotSendOtpBodyModel(
        loginType: json["loginType"],
    );

    Map<String, dynamic> toJson() => {
        "loginType": loginType,
    };
}
