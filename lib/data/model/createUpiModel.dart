// To parse this JSON data, do
//
//     final createUpiResModel = createUpiResModelFromJson(jsonString);

import 'dart:convert';

CreateUpiResModel createUpiResModelFromJson(String str) => CreateUpiResModel.fromJson(json.decode(str));

String createUpiResModelToJson(CreateUpiResModel data) => json.encode(data.toJson());

class CreateUpiResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    CreateUpiResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory CreateUpiResModel.fromJson(Map<String, dynamic> json) => CreateUpiResModel(
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
    String? userId;
    String? name;
    String? upi;
    bool? isDisable;
    bool? isDeleted;
    String? id;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    Data({
        this.userId,
        this.name,
        this.upi,
        this.isDisable,
        this.isDeleted,
        this.id,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        name: json["name"],
        upi: json["upi"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        id: json["_id"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "upi": upi,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "_id": id,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}



// To parse this JSON data, do
//
//     final createUpiBodyModel = createUpiBodyModelFromJson(jsonString);


CreateUpiBodyModel createUpiBodyModelFromJson(String str) => CreateUpiBodyModel.fromJson(json.decode(str));

String createUpiBodyModelToJson(CreateUpiBodyModel data) => json.encode(data.toJson());

class CreateUpiBodyModel {
    String? upi;
    String? name;

    CreateUpiBodyModel({
        this.upi,
        this.name,
    });

    factory CreateUpiBodyModel.fromJson(Map<String, dynamic> json) => CreateUpiBodyModel(
        upi: json["upi"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "upi": upi,
        "name": name,
    };
}
