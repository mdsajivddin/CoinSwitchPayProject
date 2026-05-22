import 'dart:convert';

GetP2PTrasationSellModel getP2PTrasationSellModelFromJson(String str) =>
    GetP2PTrasationSellModel.fromJson(json.decode(str));

String getP2PTrasationSellModelToJson(GetP2PTrasationSellModel data) =>
    json.encode(data.toJson());

class GetP2PTrasationSellModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetP2PTrasationSellModel({this.message, this.code, this.error, this.data});

  factory GetP2PTrasationSellModel.fromJson(Map<String, dynamic> json) =>
      GetP2PTrasationSellModel(
        message: json["message"],
        code: (json["code"] as num?)?.toInt(),
        error: json["error"],
        data:
            json["data"] is Map<String, dynamic>
                ? Data.fromJson(json["data"])
                : null,
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

  Data({this.total, this.page, this.pages, this.data});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: (json["total"] as num?)?.toInt(),
    page: (json["page"] as num?)?.toInt(),
    pages: (json["pages"] as num?)?.toInt(),
    data:
        json["data"] is List
            ? List<Datum>.from(
              json["data"]
                  .where((x) => x is Map<String, dynamic>)
                  .map((x) => Datum.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "pages": pages,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  Creator? creator;
  String? name;
  String? creatorModel;
  CounterParty? counterParty;
  List<PaymentMethod>? paymentMethods;
  String? txType;
  String? walletType;
  num? amount;
  double? rate;
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
  String? counterPartyModel;
  String? hash;
  String? orderId;
  String? image;

  Datum({
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
    this.dispute,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.counterPartyModel,
    this.hash,
    this.orderId,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    orderId: json["orderId"],

    // SAFE CREATOR
    creator:
        json["creator"] is Map<String, dynamic>
            ? Creator.fromJson(json["creator"])
            : null,

    name: json["name"],
    creatorModel: json["creatorModel"],

    // 🔥 SAFE COUNTER PARTY (Fix for your error)
    counterParty:
        json["counterParty"] is Map<String, dynamic>
            ? CounterParty.fromJson(json["counterParty"])
            : null,

    // SAFE PAYMENT METHODS
    paymentMethods:
        json["paymentMethods"] is List
            ? List<PaymentMethod>.from(
              json["paymentMethods"]
                  .where((x) => x is Map<String, dynamic>)
                  .map((x) => PaymentMethod.fromJson(x)),
            )
            : [],

    txType: json["txType"],
    walletType: json["walletType"],
    amount: (json["amount"] as num?)?.toDouble(),
    rate: (json["rate"] as num?)?.toDouble(),
    status: json["status"],

    dispute:
        json["dispute"] is Map<String, dynamic>
            ? Dispute.fromJson(json["dispute"])
            : null,

    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    date: (json["date"] as num?)?.toInt(),
    month: (json["month"] as num?)?.toInt(),
    year: (json["year"] as num?)?.toInt(),
    createdAt: (json["createdAt"] as num?)?.toInt(),
    updatedAt: (json["updatedAt"] as num?)?.toInt(),
    v: (json["__v"] as num?)?.toInt(),
    counterPartyModel: json["counterPartyModel"],
    hash: json["hash"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "orderId": orderId,
    "creator": creator?.toJson(),
    "name": name,
    "creatorModel": creatorModel,
    "counterParty": counterParty?.toJson(),
    "paymentMethods":
        paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
    "txType": txType,
    "walletType": walletType,
    "amount": amount,
    "rate": rate,
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
    "counterPartyModel": counterPartyModel,
    "hash": hash,
    "image": image,
  };
}

class CounterParty {
  String? id;
  String? name;
  String? email;
  String? image;

  CounterParty({this.id, this.name, this.email, this.image});

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

  Creator({this.id, this.name});

  factory Creator.fromJson(Map<String, dynamic> json) =>
      Creator(id: json["_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name};
}

class Dispute {
  bool? isDisputed;
  String? reason;
  bool? resolvedByAdmin;

  Dispute({this.isDisputed, this.reason, this.resolvedByAdmin});

  factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
    isDisputed: json["isDisputed"],
    reason: json["reason"],
    resolvedByAdmin: json["resolvedByAdmin"],
  );

  Map<String, dynamic> toJson() => {
    "isDisputed": isDisputed,
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
    details:
        json["details"] is Map<String, dynamic>
            ? Details.fromJson(json["details"])
            : null,
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
  String? ifscCode;
  String? branchName;

  Details({
    this.upiId,
    this.accountHolderName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.branchName,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    upiId: json["upiId"],
    accountHolderName: json["accountHolderName"],
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    ifscCode: json["ifscCode"],
    branchName: json["branchName"],
  );

  Map<String, dynamic> toJson() => {
    "upiId": upiId,
    "accountHolderName": accountHolderName,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "ifscCode": ifscCode,
    "branchName": branchName,
  };
}
