// To parse this JSON data, do
//
//     final p2PPaidResModel = p2PPaidResModelFromJson(jsonString);

import 'dart:convert';

P2PPaidResModel p2PPaidResModelFromJson(String str) => P2PPaidResModel.fromJson(json.decode(str));

String p2PPaidResModelToJson(P2PPaidResModel data) => json.encode(data.toJson());

class P2PPaidResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    P2PPaidResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory P2PPaidResModel.fromJson(Map<String, dynamic> json) => P2PPaidResModel(
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
    String? counterParty;
    List<PaymentMethod>? paymentMethods;
    String? txType;
    String? walletType;
    int? amount;
    double? rate;
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
        this.name,
        this.creatorModel,
        this.counterParty,
        this.paymentMethods,
        this.txType,
        this.walletType,
        this.amount,
        this.rate,
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
        name: json["name"],
        creatorModel: json["creatorModel"],
        counterParty: json["counterParty"],
        paymentMethods: json["paymentMethods"] == null ? [] : List<PaymentMethod>.from(json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
        txType: json["txType"],
        walletType: json["walletType"],
        amount: json["amount"],
       rate: (json["rate"] as num?)?.toDouble(),
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
        "name": name,
        "creatorModel": creatorModel,
        "counterParty": counterParty,
        "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "txType": txType,
        "walletType": walletType,
        "amount": amount,
        "rate": rate,
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

    Details({
        this.upiId,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        upiId: json["upiId"],
    );

    Map<String, dynamic> toJson() => {
        "upiId": upiId,
    };
}
