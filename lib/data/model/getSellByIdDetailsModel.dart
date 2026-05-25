// To parse this JSON data, do
//
//     final getSellByIdDetailsModel = getSellByIdDetailsModelFromJson(jsonString);

import 'dart:convert';

GetSellByIdDetailsModel getSellByIdDetailsModelFromJson(String str) =>
    GetSellByIdDetailsModel.fromJson(json.decode(str));

String getSellByIdDetailsModelToJson(GetSellByIdDetailsModel data) =>
    json.encode(data.toJson());

class GetSellByIdDetailsModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetSellByIdDetailsModel({this.message, this.code, this.error, this.data});

  factory GetSellByIdDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetSellByIdDetailsModel(
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
  String? walletType;
  num? amount;
  num? rate;
  num? totalAmount;
  num? paidAmount;
  num? remainAmount;
  String? assetSymbol;
  PaymentMethods? paymentMethods;
  String? status;
  bool? isDisable;
  bool? isDeleted;
  List<PaidList>? paidList;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  String? orderId;
  int? v;

  Data({
    this.id,
    this.userId,
    this.walletType,
    this.amount,
    this.rate,
    this.totalAmount,
    this.paidAmount,
    this.remainAmount,
    this.assetSymbol,
    this.paymentMethods,
    this.status,
    this.isDisable,
    this.isDeleted,
    this.paidList,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["_id"],
    userId: json["userId"],
    walletType: json["walletType"],
    amount: json["amount"],
    rate: json["rate"],
    totalAmount: json["totalAmount"],
    paidAmount: json["paidAmount"],
    remainAmount: json["remainAmount"],
    assetSymbol: json["assetSymbol"],
    paymentMethods:
        json["paymentMethods"] == null
            ? null
            : PaymentMethods.fromJson(json["paymentMethods"]),
    status: json["status"],
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    paidList:
        json["paidList"] == null
            ? []
            : List<PaidList>.from(
              json["paidList"]!.map((x) => PaidList.fromJson(x)),
            ),
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    orderId: json["orderId"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "walletType": walletType,
    "amount": amount,
    "rate": rate,
    "totalAmount": totalAmount,
    "paidAmount": paidAmount,
    "remainAmount": remainAmount,
    "assetSymbol": assetSymbol,
    "paymentMethods": paymentMethods?.toJson(),
    "status": status,
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "paidList":
        paidList == null
            ? []
            : List<dynamic>.from(paidList!.map((x) => x.toJson())),
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "orderId": orderId,
    "__v": v,
  };
}

class PaidList {
  double? amount;
  String? hash;
  int? createdAt;
  String? id;

  PaidList({this.amount, this.hash, this.createdAt, this.id});

  factory PaidList.fromJson(Map<String, dynamic> json) => PaidList(
    amount:
        json["amount"] != null
            ? double.tryParse(json["amount"].toString())
            : null,
    hash: json["hash"],
    createdAt: json["createdAt"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "hash": hash,
    "createdAt": createdAt,
    "_id": id,
  };
}

class PaymentMethods {
  String? methodType;
  String? label;
  Details? details;
  bool? isPrimary;

  PaymentMethods({this.methodType, this.label, this.details, this.isPrimary});

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
    methodType: json["methodType"],
    label: json["label"],
    details: json["details"] == null ? null : Details.fromJson(json["details"]),
    isPrimary: json["isPrimary"],
  );

  Map<String, dynamic> toJson() => {
    "methodType": methodType,
    "label": label,
    "details": details?.toJson(),
    "isPrimary": isPrimary,
  };
}

class Details {
  String? upiId;
  String? accountNumber;
  String? ifsc;
  String? accountHolderName;

  Details({this.upiId, this.accountNumber, this.ifsc, this.accountHolderName});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    upiId: json["upiId"],
    accountNumber: json["accountNumber"],
    ifsc: json["ifsc"],
    accountHolderName: json["accountHolderName"],
  );

  Map<String, dynamic> toJson() => {
    "upiId": upiId,
    "accountNumber": accountNumber,
    "ifsc": ifsc,
    "accountHolderName": accountHolderName,
  };
}
