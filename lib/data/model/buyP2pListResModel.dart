// To parse this JSON data, do
//
//     final buyP2PListResModel = buyP2PListResModelFromJson(jsonString);

import 'dart:convert';

BuyP2PListResModel buyP2PListResModelFromJson(String str) =>
    BuyP2PListResModel.fromJson(json.decode(str));

String buyP2PListResModelToJson(BuyP2PListResModel data) =>
    json.encode(data.toJson());

class BuyP2PListResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  BuyP2PListResModel({this.message, this.code, this.error, this.data});

  factory BuyP2PListResModel.fromJson(Map<String, dynamic> json) =>
      BuyP2PListResModel(
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
  String? name;
  List<PaymentMethod>? paymentMethods;
  String? walletType;
  double? amount;
  double? rate;
  int? createdAt;

  ListElement({
    this.id,
    this.name,
    this.paymentMethods,
    this.walletType,
    this.amount,
    this.rate,
    this.createdAt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["_id"],
    name: json["name"],
    paymentMethods:
        json["paymentMethods"] == null
            ? []
            : List<PaymentMethod>.from(
              json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x)),
            ),
    walletType: json["walletType"],
    // amount: json["amount"],
    amount:
        json["amount"] is int
            ? (json["amount"] as int).toDouble()
            : (json["amount"] as double? ?? 0.0),
    rate: json["rate"]?.toDouble(),
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "paymentMethods":
        paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
    "walletType": walletType,
    "amount": amount,
    "rate": rate,
    "createdAt": createdAt,
  };
}

class PaymentMethod {
  String? methodType;
  String? label;
  Details? details;
  bool? isPrimary;
  String? id;

  PaymentMethod({
    this.methodType,
    this.label,
    this.details,
    this.isPrimary,
    this.id,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    methodType: json["methodType"],
    label: json["label"],
    details: json["details"] == null ? null : Details.fromJson(json["details"]),
    isPrimary: json["isPrimary"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "methodType": methodType,
    "label": label,
    "details": details?.toJson(),
    "isPrimary": isPrimary,
    "_id": id,
  };
}

class Details {
  String? upiId;
  String? accountNumberdsds;

  Details({this.upiId, this.accountNumberdsds});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    upiId: json["upiId"],
    accountNumberdsds: json["accountNumberdsds"],
  );

  Map<String, dynamic> toJson() => {
    "upiId": upiId,
    "accountNumberdsds": accountNumberdsds,
  };
}
