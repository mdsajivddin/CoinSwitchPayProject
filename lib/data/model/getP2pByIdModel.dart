// // To parse this JSON data, do
// //
// //     final getP2PByIdModel = getP2PByIdModelFromJson(jsonString);

// import 'dart:convert';

// GetP2PByIdModel getP2PByIdModelFromJson(String str) =>
//     GetP2PByIdModel.fromJson(json.decode(str));

// String getP2PByIdModelToJson(GetP2PByIdModel data) =>
//     json.encode(data.toJson());

// class GetP2PByIdModel {
//   String? message;
//   int? code;
//   bool? error;
//   Data? data;

//   GetP2PByIdModel({this.message, this.code, this.error, this.data});

//   factory GetP2PByIdModel.fromJson(Map<String, dynamic> json) =>
//       GetP2PByIdModel(
//         message: json["message"],
//         code: json["code"],
//         error: json["error"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "code": code,
//     "error": error,
//     "data": data?.toJson(),
//   };
// }

// class Data {
//   String? id;
//   String? creator;
//   String? name;
//   String? creatorModel;
//   String? counterParty;
//   List<PaymentMethod>? paymentMethods;
//   String? txType;
//   String? walletType;
//   double? amount;
//   double? rate;
//   String? status;
//   Dispute? dispute;
//   int? expiresAt;
//   bool? isDisable;
//   bool? isDeleted;
//   int? date;
//   int? month;
//   int? year;
//   int? createdAt;
//   int? updatedAt;
//   String? orderId;
//   int? v;
//   String? counterPartyModel;
//   String? hash;
//   String? image;

//   Data({
//     this.id,
//     this.creator,
//     this.name,
//     this.creatorModel,
//     this.counterParty,
//     this.paymentMethods,
//     this.txType,
//     this.walletType,
//     this.amount,
//     this.rate,
//     this.status,
//     this.dispute,
//     this.expiresAt,
//     this.isDisable,
//     this.isDeleted,
//     this.date,
//     this.month,
//     this.year,
//     this.createdAt,
//     this.updatedAt,
//     this.orderId,
//     this.v,
//     this.counterPartyModel,
//     this.hash,
//     this.image,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["_id"],
//     creator: json["creator"],
//     name: json["name"],
//     creatorModel: json["creatorModel"],
//     counterParty: json["counterParty"],
//     paymentMethods:
//         json["paymentMethods"] == null
//             ? []
//             : List<PaymentMethod>.from(
//               json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x)),
//             ),
//     txType: json["txType"],
//     walletType: json["walletType"],
//     amount: (json["amount"] as num?)?.toDouble(),
//     rate: (json["rate"] as num?)?.toDouble(),
//     status: json["status"],
//     dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
//     expiresAt: json["expiresAt"],
//     isDisable: json["isDisable"],
//     isDeleted: json["isDeleted"],
//     date: json["date"],
//     month: json["month"],
//     year: json["year"],
//     createdAt: json["createdAt"],
//     updatedAt: json["updatedAt"],
//     orderId: json["orderId"],
//     v: json["__v"],
//     counterPartyModel: json["counterPartyModel"],
//     hash: json["hash"],
//     image: json["image"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "creator": creator,
//     "name": name,
//     "creatorModel": creatorModel,
//     "counterParty": counterParty,
//     "paymentMethods":
//         paymentMethods == null
//             ? []
//             : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
//     "txType": txType,
//     "walletType": walletType,
//     "amount": amount,
//     "rate": rate,
//     "status": status,
//     "dispute": dispute?.toJson(),
//     "expiresAt": expiresAt,
//     "isDisable": isDisable,
//     "isDeleted": isDeleted,
//     "date": date,
//     "month": month,
//     "year": year,
//     "createdAt": createdAt,
//     "updatedAt": updatedAt,
//     "orderId": orderId,
//     "__v": v,
//     "counterPartyModel": counterPartyModel,
//     "hash": hash,
//     "image": image,
//   };
// }

// class Dispute {
//   bool? isDisputed;
//   dynamic raisedBy;
//   String? reason;
//   bool? resolvedByAdmin;

//   Dispute({this.isDisputed, this.raisedBy, this.reason, this.resolvedByAdmin});

//   factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
//     isDisputed: json["isDisputed"],
//     raisedBy: json["raisedBy"],
//     reason: json["reason"],
//     resolvedByAdmin: json["resolvedByAdmin"],
//   );

//   Map<String, dynamic> toJson() => {
//     "isDisputed": isDisputed,
//     "raisedBy": raisedBy,
//     "reason": reason,
//     "resolvedByAdmin": resolvedByAdmin,
//   };
// }

// class PaymentMethod {
//   String? methodType;
//   String? label;
//   Details? details;
//   bool? isPrimary;
//   String? id;

//   PaymentMethod({
//     this.methodType,
//     this.label,
//     this.details,
//     this.isPrimary,
//     this.id,
//   });

//   factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
//     methodType: json["methodType"],
//     label: json["label"],
//     details: json["details"] == null ? null : Details.fromJson(json["details"]),
//     isPrimary: json["isPrimary"],
//     id: json["_id"],
//   );

//   Map<String, dynamic> toJson() => {
//     "methodType": methodType,
//     "label": label,
//     "details": details?.toJson(),
//     "isPrimary": isPrimary,
//     "_id": id,
//   };
// }

// class Details {
//   String? upiId;
//   String? bankName;
//   String? accountNumber;
//   String? ifscCode;

//   Details({this.upiId, this.bankName, this.accountNumber, this.ifscCode});

//   factory Details.fromJson(Map<String, dynamic> json) => Details(
//     upiId: json["upiId"],
//     bankName: json["bankName"],
//     accountNumber: json["accountNumber"],
//     ifscCode: json["ifscCode"],
//   );

//   Map<String, dynamic> toJson() => {
//     "upiId": upiId,
//     "bankName": bankName,
//     "accountNumber": accountNumber,
//     "ifscCode": ifscCode,
//   };
// }


// To parse this JSON data, do
//
//     final getP2PByIdModel = getP2PByIdModelFromJson(jsonString);

import 'dart:convert';

GetP2PByIdModel getP2PByIdModelFromJson(String str) => GetP2PByIdModel.fromJson(json.decode(str));

String getP2PByIdModelToJson(GetP2PByIdModel data) => json.encode(data.toJson());

class GetP2PByIdModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    GetP2PByIdModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetP2PByIdModel.fromJson(Map<String, dynamic> json) => GetP2PByIdModel(
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
    String? creatorModel;
    Creator? creator;
    String? counterPartyModel;
    CounterParty? counterParty;
    List<PaymentMethod>? paymentMethods;
    String? txType;
    String? walletType;
    double? amount;
    double? rate;
    String? status;
    Dispute? dispute;
    int? expiresAt;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    String? orderId;
    int? v;
    String? hash;
    String? image;

    Data({
        this.id,
        this.name,
        this.creatorModel,
        this.creator,
        this.counterPartyModel,
        this.counterParty,
        this.paymentMethods,
        this.txType,
        this.walletType,
        this.amount,
        this.rate,
        this.status,
        this.dispute,
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
        this.hash,
        this.image,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        creatorModel: json["creatorModel"],
        creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        counterPartyModel: json["counterPartyModel"],
        counterParty: json["counterParty"] == null ? null : CounterParty.fromJson(json["counterParty"]),
        paymentMethods: json["paymentMethods"] == null ? [] : List<PaymentMethod>.from(json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
        txType: json["txType"],
        walletType: json["walletType"],
        amount: (json["amount"] as num?)?.toDouble(),
    rate: (json["rate"] as num?)?.toDouble(),
        status: json["status"],
        dispute: json["dispute"] == null ? null : Dispute.fromJson(json["dispute"]),
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
        hash: json["hash"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "creatorModel": creatorModel,
        "creator": creator?.toJson(),
        "counterPartyModel": counterPartyModel,
        "counterParty": counterParty?.toJson(),
        "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "txType": txType,
        "walletType": walletType,
        "amount": amount,
        "rate": rate,
        "status": status,
        "dispute": dispute?.toJson(),
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
        "hash": hash,
        "image": image,
    };
}

class CounterParty {
    String? id;
    String? name;
    String? email;
    String? image;

    CounterParty({
        this.id,
        this.name,
        this.email,
        this.image,
    });

    factory CounterParty.fromJson(Map<String, dynamic> json) => CounterParty(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "image": image,
    };
}

class Creator {
    String? id;
    String? name;

    Creator({
        this.id,
        this.name,
    });

    factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
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
    String? id;
    String? methodType;
    String? label;
    Details? details;
    bool? isPrimary;

    PaymentMethod({
        this.id,
        this.methodType,
        this.label,
        this.details,
        this.isPrimary,
    });

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["_id"],
        methodType: json["methodType"],
        label: json["label"],
        details: json["details"] == null ? null : Details.fromJson(json["details"]),
        isPrimary: json["isPrimary"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "methodType": methodType,
        "label": label,
        "details": details?.toJson(),
        "isPrimary": isPrimary,
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
