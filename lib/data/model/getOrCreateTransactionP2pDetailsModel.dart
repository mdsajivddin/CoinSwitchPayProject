// To parse this JSON data, do
//
//     final getOrCreateP2PTransactionDetailsModel = getOrCreateP2PTransactionDetailsModelFromJson(jsonString);

import 'dart:convert';

GetOrCreateP2PTransactionDetailsModel getOrCreateP2PTransactionDetailsModelFromJson(String str) => GetOrCreateP2PTransactionDetailsModel.fromJson(json.decode(str));

String getOrCreateP2PTransactionDetailsModelToJson(GetOrCreateP2PTransactionDetailsModel data) => json.encode(data.toJson());

class GetOrCreateP2PTransactionDetailsModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetOrCreateP2PTransactionDetailsModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetOrCreateP2PTransactionDetailsModel.fromJson(Map<String, dynamic> json) => GetOrCreateP2PTransactionDetailsModel(
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
    int? expiresAt;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    String? orderId;
    String? counterPartyModel;

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
        this.expiresAt,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.orderId,
        this.counterPartyModel,
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
        rate: json["rate"]?.toDouble(),
        status: json["status"],
        expiresAt: json["expiresAt"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        orderId: json["orderId"],
        counterPartyModel: json["counterPartyModel"],
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
        "expiresAt": expiresAt,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "orderId": orderId,
        "counterPartyModel": counterPartyModel,
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
    String? accountHolderName;
    String? bankName;
    String? accountNumber;
    String? ifsc;
    String? branchName;

    Details({
        this.upiId,
        this.accountHolderName,
        this.bankName,
        this.accountNumber,
        this.ifsc,
        this.branchName,
    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        upiId: json["upiId"],
        accountHolderName: json["accountHolderName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifsc: json["ifsc"],
        branchName: json["branchName"],
    );

    Map<String, dynamic> toJson() => {
        "upiId": upiId,
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifsc": ifsc,
        "branchName": branchName,
    };
}
