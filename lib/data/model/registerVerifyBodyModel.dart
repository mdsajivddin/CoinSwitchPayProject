// To parse this JSON data, do
//
//     final registerVerifyBodyModel = registerVerifyBodyModelFromJson(jsonString);

import 'dart:convert';

RegisterVerifyBodyModel registerVerifyBodyModelFromJson(String str) => RegisterVerifyBodyModel.fromJson(json.decode(str));

String registerVerifyBodyModelToJson(RegisterVerifyBodyModel data) => json.encode(data.toJson());

class RegisterVerifyBodyModel {
    String? token;
    String? otp;

    RegisterVerifyBodyModel({
        this.token,
        this.otp,
    });

    factory RegisterVerifyBodyModel.fromJson(Map<String, dynamic> json) => RegisterVerifyBodyModel(
        token: json["token"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "otp": otp,
    };
}
