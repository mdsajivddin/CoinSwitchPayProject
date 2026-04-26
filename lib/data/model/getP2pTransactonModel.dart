// To parse this JSON data, do
//
//     final getP2PTransactionModel = getP2PTransactionModelFromJson(jsonString);

import 'dart:convert';

GetP2PTransactionModel getP2PTransactionModelFromJson(String str) => GetP2PTransactionModel.fromJson(json.decode(str));

String getP2PTransactionModelToJson(GetP2PTransactionModel data) => json.encode(data.toJson());

class GetP2PTransactionModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetP2PTransactionModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetP2PTransactionModel.fromJson(Map<String, dynamic> json) => GetP2PTransactionModel(
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
    int? page;
    int? pages;
    List<Datum>? data;

    Data({
        this.total,
        this.page,
        this.pages,
        this.data,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "pages": pages,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    dynamic creator;
    String? creatorModel;
    CounterParty? counterParty;
    String? sellerAddress;
    String? walletType;
    int? amount;
    int? price;
    int? percentage;
    String? status;
    Dispute? dispute;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;
    String? hash;
    String? image;

    Datum({
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
        this.dispute,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.hash,
        this.image,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        creator: json["creator"],
        creatorModel: json["creatorModel"],
        counterParty: json["counterParty"] == null ? null : CounterParty.fromJson(json["counterParty"]),
        sellerAddress: json["sellerAddress"],
        walletType: json["walletType"],
        amount: json["amount"],
        price: json["price"],
        percentage: json["percentage"],
        status: json["status"],
        dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        hash: json["hash"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "creator": creator,
        "creatorModel": creatorModel,
        "counterParty": counterParty?.toJson(),
        "sellerAddress": sellerAddress,
        "walletType": walletType,
        "amount": amount,
        "price": price,
        "percentage": percentage,
        "status": status,
        "dispute": dispute?.toJson(),
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "hash": hash,
        "image": image,
    };
}

class CounterParty {
    String? id;
    String? name;
    String? email;

    CounterParty({
        this.id,
        this.name,
        this.email,
    });

    factory CounterParty.fromJson(Map<String, dynamic> json) => CounterParty(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
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
