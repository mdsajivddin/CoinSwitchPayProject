// To parse this JSON data, do
//
//     final createOrUpdateKycResModel = createOrUpdateKycResModelFromJson(jsonString);

import 'dart:convert';

CreateOrUpdateKycResModel createOrUpdateKycResModelFromJson(String str) => CreateOrUpdateKycResModel.fromJson(json.decode(str));

String createOrUpdateKycResModelToJson(CreateOrUpdateKycResModel data) => json.encode(data.toJson());

class CreateOrUpdateKycResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    CreateOrUpdateKycResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory CreateOrUpdateKycResModel.fromJson(Map<String, dynamic> json) => CreateOrUpdateKycResModel(
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
    String? userId;
    String? back;
    String? front;
    String? name;
    String? amount;
    String? hash;
    String? image;
    String? status;
    bool? isDisable;
    bool? isDeleted;
    String? id;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    Data({
        this.userId,
        this.back,
        this.front,
        this.name,
        this.amount,
        this.hash,
        this.image,
        this.status,
        this.isDisable,
        this.isDeleted,
        this.id,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        back: json["back"],
        front: json["front"],
        name: json["name"],
        amount: json["amount"],
        hash: json["hash"],
        image: json["image"],
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        id: json["_id"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "back": back,
        "front": front,
        "name": name,
        "amount": amount,
        "hash": hash,
        "image": image,
        "status": status,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "_id": id,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}
