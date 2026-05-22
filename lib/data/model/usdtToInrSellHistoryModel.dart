// To parse this JSON data, do
//
//     final usdtToInrSellHistoryModel = usdtToInrSellHistoryModelFromJson(jsonString);

import 'dart:convert';

UsdtToInrSellHistoryModel usdtToInrSellHistoryModelFromJson(String str) =>
    UsdtToInrSellHistoryModel.fromJson(json.decode(str));

String usdtToInrSellHistoryModelToJson(UsdtToInrSellHistoryModel data) =>
    json.encode(data.toJson());

class UsdtToInrSellHistoryModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  UsdtToInrSellHistoryModel({this.message, this.code, this.error, this.data});

  factory UsdtToInrSellHistoryModel.fromJson(Map<String, dynamic> json) =>
      UsdtToInrSellHistoryModel(
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
  List<ListElement>? list;

  Data({this.total, this.list});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    list:
        json["list"] == null
            ? []
            : List<ListElement>.from(
              json["list"]!.map((x) => ListElement.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "list":
        list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListElement {
  String? id;
  String? userId;
  String? walletType;
  num? amount;
  num? rate;
  num? totalAmount;
  String? assetSymbol;
  PaymentMethods? paymentMethods;
  String? status;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  int? v;
  String? rejectReason;

  ListElement({
    this.id,
    this.userId,
    this.walletType,
    this.amount,
    this.rate,
    this.totalAmount,
    this.assetSymbol,
    this.paymentMethods,
    this.status,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.rejectReason,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["_id"],
    userId: json["userId"],
    walletType: json["walletType"],
    amount: json["amount"],
    rate: json["rate"],
    totalAmount: json["totalAmount"],
    assetSymbol: json["assetSymbol"],
    paymentMethods:
        json["paymentMethods"] == null
            ? null
            : PaymentMethods.fromJson(json["paymentMethods"]),
    status: json["status"],
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "walletType": walletType,
    "amount": amount,
    "rate": rate,
    "totalAmount": totalAmount,
    "assetSymbol": assetSymbol,
    "paymentMethods": paymentMethods?.toJson(),
    "status": status,
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "rejectReason": rejectReason,
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

  Details({this.upiId});

  factory Details.fromJson(Map<String, dynamic> json) =>
      Details(upiId: json["upiId"]);

  Map<String, dynamic> toJson() => {"upiId": upiId};
}
