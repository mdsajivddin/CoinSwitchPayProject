// To parse this JSON data, do
//
//     final depositeInrListModel = depositeInrListModelFromJson(jsonString);

import 'dart:convert';

DepositeInrListModel depositeInrListModelFromJson(String str) =>
    DepositeInrListModel.fromJson(json.decode(str));

String depositeInrListModelToJson(DepositeInrListModel data) =>
    json.encode(data.toJson());

class DepositeInrListModel {
  String? message;
  int? code;
  bool? error;
  List<Datum>? data;

  DepositeInrListModel({this.message, this.code, this.error, this.data});

  factory DepositeInrListModel.fromJson(Map<String, dynamic> json) =>
      DepositeInrListModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "error": error,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? name;
  int? amount;
  double? percentage;
  String? upiId;
  String? status;
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
    this.name,
    this.amount,
    this.percentage,
    this.upiId,
    this.status,
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
    name: json["name"],
    amount: json["amount"],
    percentage:
        json["percentage"] == null
            ? null
            : (json["percentage"] as num).toDouble(),

    // 👆 Ye line important hai
    upiId: json["upiId"],
    status: json["status"],
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
    "name": name,
    "amount": amount,
    "percentage": percentage,
    "upiId": upiId,
    "status": status,
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
