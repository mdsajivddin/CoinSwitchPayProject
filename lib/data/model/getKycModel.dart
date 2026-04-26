// To parse this JSON data, do
//
//     final getKycModel = getKycModelFromJson(jsonString);

import 'dart:convert';

GetKycModel getKycModelFromJson(String str) => GetKycModel.fromJson(json.decode(str));

String getKycModelToJson(GetKycModel data) => json.encode(data.toJson());

class GetKycModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetKycModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetKycModel.fromJson(Map<String, dynamic> json) => GetKycModel(
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
    String? userId;
    String? back;
    String? front;
    String? image;
    String? name;
    String? status;
    String? amount;
    String? hash;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    String? rejectReason;

    Data({
        this.id,
        this.userId,
        this.back,
        this.front,
        this.image,
        this.name,
        this.status,
        this.amount,
        this.hash,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.rejectReason,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        userId: json["userId"],
        back: json["back"],
        front: json["front"],
        image: json["image"],
        name: json["name"],
        status: json["status"],
        amount: json['amount'],
        hash: json['hash'],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        rejectReason: json["rejectReason"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "back": back,
        "front": front,
        "image": image,
        "name": name,
        "status": status,
        "amount": amount,
        "hash": hash,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "rejectReason": rejectReason,
    };
}
