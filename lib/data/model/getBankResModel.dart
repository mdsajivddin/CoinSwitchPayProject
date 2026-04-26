// To parse this JSON data, do
//
//     final getBankResModel = getBankResModelFromJson(jsonString);

import 'dart:convert';

GetBankResModel getBankResModelFromJson(String str) => GetBankResModel.fromJson(json.decode(str));

String getBankResModelToJson(GetBankResModel data) => json.encode(data.toJson());

class GetBankResModel {
    String? message;
    int? code;
    bool? error;
    List<Datum>? data;

    GetBankResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetBankResModel.fromJson(Map<String, dynamic> json) => GetBankResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? userId;
    String? accountHolderName;
    String? bankName;
    String? accountNumber;
    String? ifscCode;
    String? branchName;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;

    Datum({
        this.id,
        this.userId,
        this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.branchName,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        userId: json["userId"],
        accountHolderName: json["accountHolderName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
    };
}
