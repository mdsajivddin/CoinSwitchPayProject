// To parse this JSON data, do
//
//     final withdawResModel = withdawResModelFromJson(jsonString);

import 'dart:convert';

WithdawResModel withdawResModelFromJson(String str) => WithdawResModel.fromJson(json.decode(str));

String withdawResModelToJson(WithdawResModel data) => json.encode(data.toJson());

class WithdawResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    WithdawResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory WithdawResModel.fromJson(Map<String, dynamic> json) => WithdawResModel(
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
    String? walletType;
    String? txType;
    int? amount;
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
        this.walletType,
        this.txType,
        this.amount,
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
        walletType: json["walletType"],
        txType: json["txType"],
        amount: json["amount"],
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
        "walletType": walletType,
        "txType": txType,
        "amount": amount,
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
