// To parse this JSON data, do
//
//     final forgotPinVerifyBody = forgotPinVerifyBodyFromJson(jsonString);

import 'dart:convert';

ForgotPinVerifyBody forgotPinVerifyBodyFromJson(String str) => ForgotPinVerifyBody.fromJson(json.decode(str));

String forgotPinVerifyBodyToJson(ForgotPinVerifyBody data) => json.encode(data.toJson());

class ForgotPinVerifyBody {
    String? token;
    String? otp;
    String? newPin;
    String? confirmPin;

    ForgotPinVerifyBody({
        this.token,
        this.otp,
        this.newPin,
        this.confirmPin,
    });

    factory ForgotPinVerifyBody.fromJson(Map<String, dynamic> json) => ForgotPinVerifyBody(
        token: json["token"],
        otp: json["otp"],
        newPin: json["newPin"],
        confirmPin: json["confirmPin"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "otp": otp,
        "newPin": newPin,
        "confirmPin": confirmPin,
    };
}
