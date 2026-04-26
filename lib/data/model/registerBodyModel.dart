// To parse this JSON data, do
//
//     final registerBodyModel = registerBodyModelFromJson(jsonString);

import 'dart:convert';

RegisterBodyModel registerBodyModelFromJson(String str) =>
    RegisterBodyModel.fromJson(json.decode(str));

String registerBodyModelToJson(RegisterBodyModel data) =>
    json.encode(data.toJson());

class RegisterBodyModel {
  String? name;
  String? email;
  String? mobile;
  String? transactionPin;
  String? deviceId;
  String? refByCode;
  String? password;
  String? confirmPassword;

  RegisterBodyModel({
    this.name,
    this.email,
    this.mobile,
    this.transactionPin,
    this.deviceId,
    this.refByCode,
    this.password,
    this.confirmPassword,
  });

  factory RegisterBodyModel.fromJson(Map<String, dynamic> json) =>
      RegisterBodyModel(
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        transactionPin: json["transactionPin"],
        deviceId: json["deviceId"],
        refByCode: json["refByCode"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "mobile": mobile,
    "transactionPin": transactionPin,
    "deviceId": deviceId,
    "refByCode": refByCode,
    "password": password,
    "confirmPassword": confirmPassword,
  };
}
