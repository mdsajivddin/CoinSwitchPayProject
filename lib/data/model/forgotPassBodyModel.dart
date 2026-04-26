// To parse this JSON data, do
//
//     final forgotPassBodyModel = forgotPassBodyModelFromJson(jsonString);

import 'dart:convert';

ForgotPassBodyModel forgotPassBodyModelFromJson(String str) => ForgotPassBodyModel.fromJson(json.decode(str));

String forgotPassBodyModelToJson(ForgotPassBodyModel data) => json.encode(data.toJson());

class ForgotPassBodyModel {
    String? token;
    String? otp;
    String? newPassword;
    String? confirmPassword;

    ForgotPassBodyModel({
        this.token,
        this.otp,
        this.newPassword,
        this.confirmPassword,
    });

    factory ForgotPassBodyModel.fromJson(Map<String, dynamic> json) => ForgotPassBodyModel(
        token: json["token"],
        otp: json["otp"],
        newPassword: json["newPassword"],
        confirmPassword: json["confirmPassword"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "otp": otp,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
    };
}
