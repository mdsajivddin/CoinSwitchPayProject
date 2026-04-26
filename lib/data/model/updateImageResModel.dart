// To parse this JSON data, do
//
//     final updateImageResModel = updateImageResModelFromJson(jsonString);

import 'dart:convert';

UpdateImageResModel updateImageResModelFromJson(String str) => UpdateImageResModel.fromJson(json.decode(str));

String updateImageResModelToJson(UpdateImageResModel data) => json.encode(data.toJson());

class UpdateImageResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    UpdateImageResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory UpdateImageResModel.fromJson(Map<String, dynamic> json) => UpdateImageResModel(
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
    String? id;
    String? name;
    String? email;
    String? password;
    dynamic deviceId;
    String? referralCode;
    dynamic refByCode;
    dynamic referredBy;
    List<dynamic>? referralChain;
    bool? isKyc;
    String? tokenPin;
    dynamic inrPin;
    String? image;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    Data({
        this.id,
        this.name,
        this.email,
        this.password,
        this.deviceId,
        this.referralCode,
        this.refByCode,
        this.referredBy,
        this.referralChain,
        this.isKyc,
        this.tokenPin,
        this.inrPin,
        this.image,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        deviceId: json["deviceId"],
        referralCode: json["referralCode"],
        refByCode: json["refByCode"],
        referredBy: json["referredBy"],
        referralChain: json["referralChain"] == null ? [] : List<dynamic>.from(json["referralChain"]!.map((x) => x)),
        isKyc: json["isKyc"],
        tokenPin: json["tokenPin"],
        inrPin: json["inrPin"],
        image: json["image"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "deviceId": deviceId,
        "referralCode": referralCode,
        "refByCode": refByCode,
        "referredBy": referredBy,
        "referralChain": referralChain == null ? [] : List<dynamic>.from(referralChain!.map((x) => x)),
        "isKyc": isKyc,
        "tokenPin": tokenPin,
        "inrPin": inrPin,
        "image": image,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
