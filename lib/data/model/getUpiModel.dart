// To parse this JSON data, do
//
//     final getUpiModel = getUpiModelFromJson(jsonString);

import 'dart:convert';

GetUpiModel getUpiModelFromJson(String str) => GetUpiModel.fromJson(json.decode(str));

String getUpiModelToJson(GetUpiModel data) => json.encode(data.toJson());

class GetUpiModel {
    String? message;
    int? code;
    bool? error;
    List<Datum>? data;

    GetUpiModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetUpiModel.fromJson(Map<String, dynamic> json) => GetUpiModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? userId;
    String? upi;
    String? name;
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
        this.userId,
        this.upi,
        this.name,
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
        userId: json["userId"],
        upi: json["upi"],
        name: json["name"],
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
        "userId": userId,
        "upi": upi,
        "name": name,
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
