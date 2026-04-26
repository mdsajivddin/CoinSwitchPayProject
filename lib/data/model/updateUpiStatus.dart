// To parse this JSON data, do
//
//     final updateUpiStatusResModel = updateUpiStatusResModelFromJson(jsonString);

import 'dart:convert';

UpdateUpiStatusResModel updateUpiStatusResModelFromJson(String str) => UpdateUpiStatusResModel.fromJson(json.decode(str));

String updateUpiStatusResModelToJson(UpdateUpiStatusResModel data) => json.encode(data.toJson());

class UpdateUpiStatusResModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    UpdateUpiStatusResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory UpdateUpiStatusResModel.fromJson(Map<String, dynamic> json) => UpdateUpiStatusResModel(
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
    String? userId;
    String? upi;
    bool? isDisable;
    bool? isDeleted;
    int? date;
    int? month;
    int? year;
    int? createdAt;
    int? updatedAt;

    Data({
        this.id,
        this.userId,
        this.upi,
        this.isDisable,
        this.isDeleted,
        this.date,
        this.month,
        this.year,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        userId: json["userId"],
        upi: json["upi"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "upi": upi,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
    };
}



// To parse this JSON data, do
//
//     final updateUpiStatusBodyModel = updateUpiStatusBodyModelFromJson(jsonString);


UpdateUpiStatusBodyModel updateUpiStatusBodyModelFromJson(String str) => UpdateUpiStatusBodyModel.fromJson(json.decode(str));

String updateUpiStatusBodyModelToJson(UpdateUpiStatusBodyModel data) => json.encode(data.toJson());

class UpdateUpiStatusBodyModel {
    String? upiId;
    bool? isDisable;

    UpdateUpiStatusBodyModel({
        this.upiId,
        this.isDisable,
    });

    factory UpdateUpiStatusBodyModel.fromJson(Map<String, dynamic> json) => UpdateUpiStatusBodyModel(
        upiId: json["upiId"],
        isDisable: json["isDisable"],
    );

    Map<String, dynamic> toJson() => {
        "upiId": upiId,
        "isDisable": isDisable,
    };
}
