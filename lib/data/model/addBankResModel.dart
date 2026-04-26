// To parse this JSON data, do
//
//     final addBankResModel = addBankResModelFromJson(jsonString);

import 'dart:convert';

AddBankResModel addBankResModelFromJson(String str) => AddBankResModel.fromJson(json.decode(str));

String addBankResModelToJson(AddBankResModel data) => json.encode(data.toJson());

class AddBankResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    AddBankResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory AddBankResModel.fromJson(Map<String, dynamic> json) => AddBankResModel(
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
    String? accountHolderName;
    String? bankName;
    String? accountNumber;
    String? ifscCode;
    String? branchName;
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
        this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.branchName,
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
        accountHolderName: json["accountHolderName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
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
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
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
