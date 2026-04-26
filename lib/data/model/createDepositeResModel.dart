// To parse this JSON data, do
//
//     final createDepositeResModel = createDepositeResModelFromJson(jsonString);

import 'dart:convert';

CreateDepositeResModel createDepositeResModelFromJson(String str) =>
    CreateDepositeResModel.fromJson(json.decode(str));

String createDepositeResModelToJson(CreateDepositeResModel data) =>
    json.encode(data.toJson());

class CreateDepositeResModel {
  String? message;
  int? code;
  bool? error;
  // Data? data;
  dynamic data;

  CreateDepositeResModel({this.message, this.code, this.error, this.data});

  factory CreateDepositeResModel.fromJson(Map<String, dynamic> json) =>
      CreateDepositeResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        // data: json["data"] == null ? null : Data.fromJson(json["data"]),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "error": error,
    // "data": data?.toJson(),
    "data" : data,
  };
}

class Data {
  String? userId;
  String? qrCodeId;
  String? walletType;
  String? txType;
  int? amount;
  String? status;
  String? hash;
  String? image;
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
    this.qrCodeId,
    this.walletType,
    this.txType,
    this.amount,
    this.status,
    this.hash,
    this.image,
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
    qrCodeId: json["qrCodeId"],
    walletType: json["walletType"],
    txType: json["txType"],
    amount: json["amount"],
    status: json["status"],
    hash: json["hash"],
    image: json["image"],
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
    "qrCodeId": qrCodeId,
    "walletType": walletType,
    "txType": txType,
    "amount": amount,
    "status": status,
    "hash": hash,
    "image": image,
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
