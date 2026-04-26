import 'dart:convert';

ProcessBuyInrDepositResModel processBuyInrDepositResModelFromJson(String str) =>
    ProcessBuyInrDepositResModel.fromJson(json.decode(str));

String processBuyInrDepositResModelToJson(ProcessBuyInrDepositResModel data) =>
    json.encode(data.toJson());

class ProcessBuyInrDepositResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  ProcessBuyInrDepositResModel({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory ProcessBuyInrDepositResModel.fromJson(Map<String, dynamic> json) =>
      ProcessBuyInrDepositResModel(
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
  String? name;
  double? amount;     // Changed int? to double?
  double? percentage; // Already double?
  String? upiId;
  String? status;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? expiresAt;
  int? updatedAt;

  Data({
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
    this.expiresAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        // FIXED: Amount can be double from API
        amount: json["amount"] == null
            ? null
            : (json["amount"] as num).toDouble(), 
        // FIXED: Percentage parsed as num to avoid int/double conflict
        percentage: json["percentage"] == null
            ? null
            : (json["percentage"] as num).toDouble(),
        upiId: json["upiId"],
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        expiresAt: json["expiresAt"],
        updatedAt: json["updatedAt"],
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
        "expiresAt": expiresAt,
        "updatedAt": updatedAt,
      };
}