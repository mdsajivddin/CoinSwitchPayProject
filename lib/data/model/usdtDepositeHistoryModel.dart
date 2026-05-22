// To parse this JSON data, do
//
//     final usdtDepositeHisotryModel = usdtDepositeHisotryModelFromJson(jsonString);

import 'dart:convert';

UsdtDepositeHisotryModel usdtDepositeHisotryModelFromJson(String str) =>
    UsdtDepositeHisotryModel.fromJson(json.decode(str));

String usdtDepositeHisotryModelToJson(UsdtDepositeHisotryModel data) =>
    json.encode(data.toJson());

class UsdtDepositeHisotryModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  UsdtDepositeHisotryModel({this.message, this.code, this.error, this.data});

  factory UsdtDepositeHisotryModel.fromJson(Map<String, dynamic> json) =>
      UsdtDepositeHisotryModel(
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
  int? total;
  int? page;
  int? pages;
  List<Datum>? data;

  Data({this.total, this.page, this.pages, this.data});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    page: json["page"],
    pages: json["pages"],
    data:
        json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "pages": pages,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? userId;
  String? walletAddress;
  String? walletType;
  String? txType;
  num? amount;
  String? network;
  String? status;
  int? expiresAt;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  int? v;
  String? hash;
  String? image;
  String? orderId;
  String? rejectReason;

  Datum({
    this.id,
    this.userId,
    this.walletAddress,
    this.walletType,
    this.txType,
    this.amount,
    this.network,
    this.status,
    this.expiresAt,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.hash,
    this.image,
    this.orderId,
    this.rejectReason,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    userId: json["userId"],
    walletAddress: json["walletAddress"],
    walletType: json["walletType"],
    txType: json["txType"],
    amount: json["amount"],
    network: json["network"],
    status: json["status"],
    expiresAt: json["expiresAt"],
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    hash: json["hash"],
    image: json["image"],
    orderId: json["orderId"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "walletAddress": walletAddress,
    "walletType": walletType,
    "txType": txType,
    "amount": amount,
    "network": network,
    "status": status,
    "expiresAt": expiresAt,
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "hash": hash,
    "image": image,
    "orderId": orderId,
    "rejectReason": rejectReason,
  };
}
