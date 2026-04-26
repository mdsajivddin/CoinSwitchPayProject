// To parse this JSON data, do
//
//     final updateBankStatuResModel = updateBankStatuResModelFromJson(jsonString);

import 'dart:convert';

UpdateBankStatuResModel updateBankStatuResModelFromJson(String str) => UpdateBankStatuResModel.fromJson(json.decode(str));

String updateBankStatuResModelToJson(UpdateBankStatuResModel data) => json.encode(data.toJson());

class UpdateBankStatuResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    UpdateBankStatuResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory UpdateBankStatuResModel.fromJson(Map<String, dynamic> json) => UpdateBankStatuResModel(
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

    Data({
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
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    };
}
