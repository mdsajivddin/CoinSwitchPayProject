// To parse this JSON data, do
//
//     final getAllQrCodeInrResModel = getAllQrCodeInrResModelFromJson(jsonString);

import 'dart:convert';

GetAllQrCodeInrResModel getAllQrCodeInrResModelFromJson(String str) => GetAllQrCodeInrResModel.fromJson(json.decode(str));

String getAllQrCodeInrResModelToJson(GetAllQrCodeInrResModel data) => json.encode(data.toJson());

class GetAllQrCodeInrResModel {
    String? message;
    int? code;
    bool? error;
    List<Datum>? data;

    GetAllQrCodeInrResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetAllQrCodeInrResModel.fromJson(Map<String, dynamic> json) => GetAllQrCodeInrResModel(
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
