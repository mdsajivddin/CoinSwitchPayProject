// To parse this JSON data, do
//
//     final sellP2PDetailsModel = sellP2PDetailsModelFromJson(jsonString);

import 'dart:convert';

SellP2PDetailsModel sellP2PDetailsModelFromJson(String str) => SellP2PDetailsModel.fromJson(json.decode(str));

String sellP2PDetailsModelToJson(SellP2PDetailsModel data) => json.encode(data.toJson());

class SellP2PDetailsModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    SellP2PDetailsModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory SellP2PDetailsModel.fromJson(Map<String, dynamic> json) => SellP2PDetailsModel(
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
    Dispute? dispute;
    String? id;
    String? creator;
    String? name;
    String? creatorModel;
    dynamic counterParty;
    String? txType;
    String? walletType;
    int? amount;
    double? rate;
    String? status;
    bool? isDisable;
    bool? isDeleted;
    List<dynamic>? paymentMethods;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    Data({
        this.dispute,
        this.id,
        this.creator,
        this.name,
        this.creatorModel,
        this.counterParty,
        this.txType,
        this.walletType,
        this.amount,
        this.rate,
        this.status,
        this.isDisable,
        this.isDeleted,
        this.paymentMethods,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
        id: json["_id"],
        creator: json["creator"],
        name: json["name"],
        creatorModel: json["creatorModel"],
        counterParty: json["counterParty"],
        txType: json["txType"],
        walletType: json["walletType"],
        amount: json["amount"],
        rate: json["rate"]?.toDouble(),
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        paymentMethods: json["paymentMethods"] == null ? [] : List<dynamic>.from(json["paymentMethods"]!.map((x) => x)),
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "dispute": dispute?.toJson(),
        "_id": id,
        "creator": creator,
        "name": name,
        "creatorModel": creatorModel,
        "counterParty": counterParty,
        "txType": txType,
        "walletType": walletType,
        "amount": amount,
        "rate": rate,
        "status": status,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x)),
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}

class Dispute {
    bool? isDisputed;
    dynamic raisedBy;
    String? reason;
    bool? resolvedByAdmin;

    Dispute({
        this.isDisputed,
        this.raisedBy,
        this.reason,
        this.resolvedByAdmin,
    });

    factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
        isDisputed: json["isDisputed"],
        raisedBy: json["raisedBy"],
        reason: json["reason"],
        resolvedByAdmin: json["resolvedByAdmin"],
    );

    Map<String, dynamic> toJson() => {
        "isDisputed": isDisputed,
        "raisedBy": raisedBy,
        "reason": reason,
        "resolvedByAdmin": resolvedByAdmin,
    };
}
