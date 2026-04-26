// To parse this JSON data, do
//
//     final requestBuyOrderResModel = requestBuyOrderResModelFromJson(jsonString);

import 'dart:convert';

RequestBuyOrderResModel requestBuyOrderResModelFromJson(String str) => RequestBuyOrderResModel.fromJson(json.decode(str));

String requestBuyOrderResModelToJson(RequestBuyOrderResModel data) => json.encode(data.toJson());

class RequestBuyOrderResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    RequestBuyOrderResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory RequestBuyOrderResModel.fromJson(Map<String, dynamic> json) => RequestBuyOrderResModel(
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
    String? creatorModel;
    String? counterParty;
    String? sellerAddress;
    String? walletType;
    int? amount;
    int? price;
    int? percentage;
    String? status;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    String? hash;
    String? image;

    Data({
        this.dispute,
        this.id,
        this.creator,
        this.creatorModel,
        this.counterParty,
        this.sellerAddress,
        this.walletType,
        this.amount,
        this.price,
        this.percentage,
        this.status,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.hash,
        this.image,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
        id: json["_id"],
        creator: json["creator"],
        creatorModel: json["creatorModel"],
        counterParty: json["counterParty"],
        sellerAddress: json["sellerAddress"],
        walletType: json["walletType"],
        amount: json["amount"],
        price: json["price"],
        percentage: json["percentage"],
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        hash: json["hash"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "dispute": dispute?.toJson(),
        "_id": id,
        "creator": creator,
        "creatorModel": creatorModel,
        "counterParty": counterParty,
        "sellerAddress": sellerAddress,
        "walletType": walletType,
        "amount": amount,
        "price": price,
        "percentage": percentage,
        "status": status,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "hash": hash,
        "image": image,
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
