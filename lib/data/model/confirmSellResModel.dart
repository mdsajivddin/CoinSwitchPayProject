// To parse this JSON data, do
//
//     final confirmSellResModel = confirmSellResModelFromJson(jsonString);

import 'dart:convert';

ConfirmSellResModel confirmSellResModelFromJson(String str) =>
    ConfirmSellResModel.fromJson(json.decode(str));

String confirmSellResModelToJson(ConfirmSellResModel data) =>
    json.encode(data.toJson());

class ConfirmSellResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  ConfirmSellResModel({this.message, this.code, this.error, this.data});

  factory ConfirmSellResModel.fromJson(Map<String, dynamic> json) =>
      ConfirmSellResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        // data: json["data"] == null ? null : Data.fromJson(json["data"]),
        data:
            json["data"] is Map<String, dynamic>
                ? Data.fromJson(json["data"])
                : null,
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
  num? amount;
  num? rate;
  num? totalAmount;
  num? paidAmount;
  num? remainAmount;
  String? assetSymbol;
  // PaymentMethods? paymentMethods;
  List<PaymentMethods>? paymentMethods;
  String? status;
  bool? isDisable;
  bool? isDeleted;
  String? id;
  List<dynamic>? paidList;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  String? orderId;

  Data({
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
    this.id,
    this.paidList,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.orderId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"],
    walletType: json["walletType"],
    amount: json["amount"],
    // rate: json["rate"],
    rate: (json["rate"] as num?)?.toDouble(),
    totalAmount: json["totalAmount"],
    paidAmount: json["paidAmount"],
    remainAmount: json["remainAmount"],
    assetSymbol: json["assetSymbol"],
    // paymentMethods:
    //     json["paymentMethods"] == null
    //         ? null
    //         : PaymentMethods.fromJson(json["paymentMethods"]),
    paymentMethods:
        json["paymentMethods"] == null
            ? []
            : json["paymentMethods"] is List
            ? List<PaymentMethods>.from(
              json["paymentMethods"].map((x) => PaymentMethods.fromJson(x)),
            )
            : [PaymentMethods.fromJson(json["paymentMethods"])],
    status: json["status"],
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    id: json["_id"],
    paidList:
        json["paidList"] == null
            ? []
            : List<dynamic>.from(json["paidList"]!.map((x) => x)),
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    orderId: json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "walletType": walletType,
    "amount": amount,
    "rate": rate,
    "totalAmount": totalAmount,
    "paidAmount": paidAmount,
    "remainAmount": remainAmount,
    "assetSymbol": assetSymbol,
    // "paymentMethods": paymentMethods?.toJson(),
    "paymentMethods":
        paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
    "status": status,
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "_id": id,
    "paidList":
        paidList == null ? [] : List<dynamic>.from(paidList!.map((x) => x)),
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "orderId": orderId,
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
