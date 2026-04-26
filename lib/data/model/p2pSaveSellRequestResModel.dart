
// // To parse this JSON data, do
// //
// //     final saveSellRequestResModel = saveSellRequestResModelFromJson(jsonString);

// import 'dart:convert';

// SaveSellRequestResModel saveSellRequestResModelFromJson(String str) => SaveSellRequestResModel.fromJson(json.decode(str));

// String saveSellRequestResModelToJson(SaveSellRequestResModel data) => json.encode(data.toJson());

// class SaveSellRequestResModel {
//     String? message;
//     int? code;
//     bool? error;
//     Data? data;

//     SaveSellRequestResModel({
//         this.message,
//         this.code,
//         this.error,
//         this.data,
//     });

//     factory SaveSellRequestResModel.fromJson(Map<String, dynamic> json) => SaveSellRequestResModel(
//         message: json["message"],
//         code: json["code"],
//         error: json["error"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "message": message,
//         "code": code,
//         "error": error,
//         "data": data?.toJson(),
//     };
// }

// class Data {
//     Dispute? dispute;
//     String? id;
//     String? creator;
//     String? name;
//     String? creatorModel;
//     String? counterParty;
//     String? txType;
//     String? walletType;
//     int? amount;
//     int? rate;
//     String? status;
//     bool? isDisable;
//     bool? isDeleted;
//     List<PaymentMethod>? paymentMethods;
//     int? date;
//     int? month;
//     int? year;
//     int? createdAt;
//     int? updatedAt;
//     String? counterPartyModel;

//     Data({
//         this.dispute,
//         this.id,
//         this.creator,
//         this.name,
//         this.creatorModel,
//         this.counterParty,
//         this.txType,
//         this.walletType,
//         this.amount,
//         this.rate,
//         this.status,
//         this.isDisable,
//         this.isDeleted,
//         this.paymentMethods,
//         this.date,
//         this.month,
//         this.year,
//         this.createdAt,
//         this.updatedAt,
//         this.counterPartyModel,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
//         id: json["_id"],
//         creator: json["creator"],
//         name: json["name"],
//         creatorModel: json["creatorModel"],
//         counterParty: json["counterParty"],
//         txType: json["txType"],
//         walletType: json["walletType"],
//         amount: json["amount"],
//         rate: json["rate"],
//         status: json["status"],
//         isDisable: json["isDisable"],
//         isDeleted: json["isDeleted"],
//         paymentMethods: json["paymentMethods"] == null ? [] : List<PaymentMethod>.from(json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
//         date: json["date"],
//         month: json["month"],
//         year: json["year"],
//         createdAt: json["createdAt"],
//         updatedAt: json["updatedAt"],
//         counterPartyModel: json["counterPartyModel"],
//     );

//     Map<String, dynamic> toJson() => {
//         "dispute": dispute?.toJson(),
//         "_id": id,
//         "creator": creator,
//         "name": name,
//         "creatorModel": creatorModel,
//         "counterParty": counterParty,
//         "txType": txType,
//         "walletType": walletType,
//         "amount": amount,
//         "rate": rate,
//         "status": status,
//         "isDisable": isDisable,
//         "isDeleted": isDeleted,
//         "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
//         "date": date,
//         "month": month,
//         "year": year,
//         "createdAt": createdAt,
//         "updatedAt": updatedAt,
//         "counterPartyModel": counterPartyModel,
//     };
// }

// class Dispute {
//     bool? isDisputed;
//     dynamic raisedBy;
//     String? reason;
//     bool? resolvedByAdmin;

//     Dispute({
//         this.isDisputed,
//         this.raisedBy,
//         this.reason,
//         this.resolvedByAdmin,
//     });

//     factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
//         isDisputed: json["isDisputed"],
//         raisedBy: json["raisedBy"],
//         reason: json["reason"],
//         resolvedByAdmin: json["resolvedByAdmin"],
//     );

//     Map<String, dynamic> toJson() => {
//         "isDisputed": isDisputed,
//         "raisedBy": raisedBy,
//         "reason": reason,
//         "resolvedByAdmin": resolvedByAdmin,
//     };
// }

// class PaymentMethod {
//     String? methodType;
//     String? label;
//     Details? details;
//     bool? isPrimary;
//     String? id;

//     PaymentMethod({
//         this.methodType,
//         this.label,
//         this.details,
//         this.isPrimary,
//         this.id,
//     });

//     factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
//         methodType: json["methodType"],
//         label: json["label"],
//         details: json["details"] == null ? null : Details.fromJson(json["details"]),
//         isPrimary: json["isPrimary"],
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "methodType": methodType,
//         "label": label,
//         "details": details?.toJson(),
//         "isPrimary": isPrimary,
//         "_id": id,
//     };
// }

// class Details {
//     String? upiId;
//     String? holderName;

//     Details({
//         this.upiId,
//         this.holderName,
//     });

//     factory Details.fromJson(Map<String, dynamic> json) => Details(
//         upiId: json["upiId"],
//         holderName: json["holderName"],
//     );

//     Map<String, dynamic> toJson() => {
//         "upiId": upiId,
//         "holderName": holderName,
//     };
// }


// To parse this JSON data, do
//
//     final saveRequestResModel = saveRequestResModelFromJson(jsonString);

import 'dart:convert';

SaveRequestResModel saveRequestResModelFromJson(String str) => SaveRequestResModel.fromJson(json.decode(str));

String saveRequestResModelToJson(SaveRequestResModel data) => json.encode(data.toJson());

class SaveRequestResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    SaveRequestResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory SaveRequestResModel.fromJson(Map<String, dynamic> json) => SaveRequestResModel(
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
    String? txType;
    String? walletType;
    int? amount;
   double? rate;
    String? status;
    bool? isDisable;
    bool? isDeleted;
    List<PaymentMethod>? paymentMethods;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    String? counterPartyModel;

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
        this.counterPartyModel,
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
       rate: (json["rate"] as num?)?.toDouble(),
        status: json["status"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        paymentMethods: json["paymentMethods"] == null ? [] : List<PaymentMethod>.from(json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        counterPartyModel: json["counterPartyModel"],
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
        "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
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
    String? holderName;
    String? bankName;
    String? accountNumber;
    String? ifscCode;
    String? branchName;
    String? accountHolderName;

    Details({
        this.upiId,
        this.holderName,
        this.bankName,
        this.accountNumber,
        this.ifscCode,
        this.accountHolderName,
        this.branchName,

    });

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        upiId: json["upiId"],
        holderName: json["holderName"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
        accountHolderName: json["accountHolderName"],
    );

    Map<String, dynamic> toJson() => {
        "upiId": upiId,
        "holderName": holderName,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
        "accountHolderName": accountHolderName,
    };
}
