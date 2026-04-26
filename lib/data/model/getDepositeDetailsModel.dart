import 'dart:convert';

GetDepositeDetaislModel getDepositeDetaislModelFromJson(String str) =>
    GetDepositeDetaislModel.fromJson(json.decode(str));

String getDepositeDetaislModelToJson(GetDepositeDetaislModel data) =>
    json.encode(data.toJson());

class GetDepositeDetaislModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetDepositeDetaislModel({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory GetDepositeDetaislModel.fromJson(Map<String, dynamic> json) =>
      GetDepositeDetaislModel(
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
  String? txType;

  double? amount;
  double? rate;
  double? realAmount;

  String? status;
  String? hash;
  String? network;
  String? walletAddress;
  String? image;
  String? upi;
  String? upiHolder;

  dynamic expiresAt;

  bool? isDisable;
  bool? isDeleted;

  int? date;
  int? month;
  int? year;

  int? createdAt;
  int? updatedAt;

  String? orderId;
  int? v;
  String? rejectReason;

  Data({
    this.id,
    this.userId,
    this.walletType,
    this.txType,
    this.amount,
    this.walletAddress,
    this.status,
    this.hash,
    this.image,
    this.rate,
    this.realAmount,
    this.network,
    this.upi,
    this.expiresAt,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.v,
    this.rejectReason,
    this.upiHolder,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        userId: json["userId"],
        walletType: json["walletType"],
        txType: json["txType"],
        network: json["network"],
        walletAddress: json["walletAddress"],

        amount: _toDouble(json["amount"]),
        rate: _toDouble(json["rate"]),
        realAmount: _toDouble(json["realAmount"]),

        status: json["status"],
        hash: json["hash"],
        image: json["image"],
        upi: json["upi"],

        expiresAt: json["expiresAt"],

        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],

        date: json["date"],
        month: json["month"],
        year: json["year"],

        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],

        orderId: json["orderId"],
        v: json["__v"],
        rejectReason: json["rejectReason"],
        upiHolder: json["upiHolder"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "walletType": walletType,
        "txType": txType,
        "amount": amount,
        "status": status,
        "hash": hash,
        "network": network,
        "walletAddress": walletAddress,
        "image": image,
        "rate": rate,
        "realAmount": realAmount,
        "upi": upi,
        "expiresAt": expiresAt,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "orderId": orderId,
        "__v": v,
        "rejectReason": rejectReason,
        "upiHolder": upiHolder,
      };

  /// SAFE DOUBLE PARSER
  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is int) return value.toDouble();
    if (value is double) return value;

    return double.tryParse(value.toString());
  }
}