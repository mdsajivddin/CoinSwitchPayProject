// To parse this JSON data, do
//
//     final registerVerifyResModel = registerVerifyResModelFromJson(jsonString);

import 'dart:convert';

RegisterVerifyResModel registerVerifyResModelFromJson(String str) => RegisterVerifyResModel.fromJson(json.decode(str));

String registerVerifyResModelToJson(RegisterVerifyResModel data) => json.encode(data.toJson());

class RegisterVerifyResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    RegisterVerifyResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory RegisterVerifyResModel.fromJson(Map<String, dynamic> json) => RegisterVerifyResModel(
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
    String? id;
    String? name;
    String? email;

    Data({
        this.token,
        this.id,
        this.name,
        this.email,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "name": name,
        "email": email,
    };
}
