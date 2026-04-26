// To parse this JSON data, do
//
//     final getRefralchainlistModel = getRefralchainlistModelFromJson(jsonString);

import 'dart:convert';

GetRefralchainlistModel getRefralchainlistModelFromJson(String str) => GetRefralchainlistModel.fromJson(json.decode(str));

String getRefralchainlistModelToJson(GetRefralchainlistModel data) => json.encode(data.toJson());

class GetRefralchainlistModel {
    Message? message;
    int? code;
    bool? error;
    dynamic data;

    GetRefralchainlistModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetRefralchainlistModel.fromJson(Map<String, dynamic> json) => GetRefralchainlistModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        code: json["code"],
        error: json["error"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
        "code": code,
        "error": error,
        "data": data,
    };
}

class Message {
    int? total;
    int? page;
    int? limit;
    List<Datum>? data;

    Message({
        this.total,
        this.page,
        this.limit,
        this.data,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? name;
    String? mobile;
    String? email;
    dynamic deviceId;
    String? referralCode;
    String? refByCode;
    String? referredBy;
    List<String>? referralChain;
    bool? isKyc;
    dynamic image;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;
    int? v;

    Datum({
        this.id,
        this.name,
        this.mobile,
        this.email,
        this.deviceId,
        this.referralCode,
        this.refByCode,
        this.referredBy,
        this.referralChain,
        this.isKyc,
        this.image,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        deviceId: json["deviceId"],
        referralCode: json["referralCode"],
        refByCode: json["refByCode"],
        referredBy: json["referredBy"],
        referralChain: json["referralChain"] == null ? [] : List<String>.from(json["referralChain"]!.map((x) => x)),
        isKyc: json["isKyc"],
        image: json["image"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "deviceId": deviceId,
        "referralCode": referralCode,
        "refByCode": refByCode,
        "referredBy": referredBy,
        "referralChain": referralChain == null ? [] : List<dynamic>.from(referralChain!.map((x) => x)),
        "isKyc": isKyc,
        "image": image,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
    };
}
