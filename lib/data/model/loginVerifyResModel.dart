// To parse this JSON data, do
//
//     final loginVerifyResModel = loginVerifyResModelFromJson(jsonString);

import 'dart:convert';

LoginVerifyResModel loginVerifyResModelFromJson(String str) => LoginVerifyResModel.fromJson(json.decode(str));

String loginVerifyResModelToJson(LoginVerifyResModel data) => json.encode(data.toJson());

class LoginVerifyResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    LoginVerifyResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory LoginVerifyResModel.fromJson(Map<String, dynamic> json) => LoginVerifyResModel(
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
    String? name;
    String? email;
    String? id;

    Data({
        this.token,
        this.name,
        this.email,
        this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        name: json["name"],
        email: json["email"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "name": name,
        "email": email,
        "id": id,
    };
}
