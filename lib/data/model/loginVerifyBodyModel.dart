// To parse this JSON data, do
//
//     final loginVerifyBodyModel = loginVerifyBodyModelFromJson(jsonString);

import 'dart:convert';

LoginVerifyBodyModel loginVerifyBodyModelFromJson(String str) => LoginVerifyBodyModel.fromJson(json.decode(str));

String loginVerifyBodyModelToJson(LoginVerifyBodyModel data) => json.encode(data.toJson());

class LoginVerifyBodyModel {
    String? token;
    String? otp;

    LoginVerifyBodyModel({
        this.token,
        this.otp,
    });

    factory LoginVerifyBodyModel.fromJson(Map<String, dynamic> json) => LoginVerifyBodyModel(
        token: json["token"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "otp": otp,
    };
}
