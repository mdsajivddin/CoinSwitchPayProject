// To parse this JSON data, do
//
//     final getAllQrCodeTokenModel = getAllQrCodeTokenModelFromJson(jsonString);

import 'dart:convert';

GetAllQrCodeTokenModel getAllQrCodeTokenModelFromJson(String str) => GetAllQrCodeTokenModel.fromJson(json.decode(str));

String getAllQrCodeTokenModelToJson(GetAllQrCodeTokenModel data) => json.encode(data.toJson());

class GetAllQrCodeTokenModel {
    String? message;
    int? code;
    bool? error;
    List<Datum>? data;

    GetAllQrCodeTokenModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetAllQrCodeTokenModel.fromJson(Map<String, dynamic> json) => GetAllQrCodeTokenModel(
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
    String? address;
    bool? isUpi;
    int? createdAt;

    Datum({
        this.id,
        this.address,
        this.isUpi,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        address: json["address"],
        isUpi: json["isUpi"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "address": address,
        "isUpi": isUpi,
        "createdAt": createdAt,
    };
}
