import 'dart:convert';

GetP2PTrasationBuyModel getP2PTrasationBuyModelFromJson(String str) =>
    GetP2PTrasationBuyModel.fromJson(json.decode(str));

String getP2PTrasationBuyModelToJson(GetP2PTrasationBuyModel data) =>
    json.encode(data.toJson());

class GetP2PTrasationBuyModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetP2PTrasationBuyModel({this.message, this.code, this.error, this.data});

  factory GetP2PTrasationBuyModel.fromJson(Map<String, dynamic> json) =>
      GetP2PTrasationBuyModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
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
    total: json["total"],
    page: json["page"],
    pages: json["pages"],
    data:
        json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "pages": pages,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class Datum {
  String? id;
  Creator? creator;
  String? name;
  String? creatorModel;
  CounterParty? counterParty;
  String? txType;
  String? walletType;
  num? amount;
  double? rate;
  String? status;
  Dispute? dispute;
  bool? isDisable;
  bool? isDeleted;
  List<PaymentMethod>? paymentMethods;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  int? v;
  String? counterPartyModel;

  Datum({
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
    this.dispute,
    this.isDisable,
    this.isDeleted,
    this.paymentMethods,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.counterPartyModel,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    creator: json["creator"] != null ? Creator.fromJson(json["creator"]) : null,
    name: json["name"],
    creatorModel: json["creatorModel"],
    counterParty:
        json["counterParty"] != null
            ? CounterParty.fromJson(json["counterParty"])
            : null,
    txType: json["txType"],
    walletType: json["walletType"],
    amount: json["amount"],
    rate: json["rate"] != null ? (json["rate"] as num).toDouble() : null,
    status: json["status"],
    dispute: json["dispute"] != null ? Dispute.fromJson(json["dispute"]) : null,
    isDisable: json["isDisable"],
    isDeleted: json["isDeleted"],
    paymentMethods:
        json["paymentMethods"] == null
            ? []
            : List<PaymentMethod>.from(
              json["paymentMethods"].map((x) => PaymentMethod.fromJson(x)),
            ),
    date: json["date"],
    month: json["month"],
    year: json["year"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    counterPartyModel: json["counterPartyModel"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "creator": creator?.toJson(),
    "name": name,
    "creatorModel": creatorModel,
    "counterParty": counterParty?.toJson(),
    "txType": txType,
    "walletType": walletType,
    "amount": amount,
    "rate": rate,
    "status": status,
    "dispute": dispute?.toJson(),
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "paymentMethods": paymentMethods?.map((x) => x.toJson()).toList(),
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "counterPartyModel": counterPartyModel,
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
  dynamic raisedBy;
  String? reason;
  bool? resolvedByAdmin;

  Dispute({this.isDisputed, this.raisedBy, this.reason, this.resolvedByAdmin});

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
    details: json["details"] != null ? Details.fromJson(json["details"]) : null,
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
    this.branchName,
    this.accountHolderName,
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
