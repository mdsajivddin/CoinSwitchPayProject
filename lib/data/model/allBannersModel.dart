// To parse this JSON data, do
//
//     final getBannersModel = getBannersModelFromJson(jsonString);

import 'dart:convert';

GetBannersModel getBannersModelFromJson(String str) => GetBannersModel.fromJson(json.decode(str));

String getBannersModelToJson(GetBannersModel data) => json.encode(data.toJson());

class GetBannersModel {
    String? message;
    int? code;
    bool? error;
    List<Datum>? data;

    GetBannersModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory GetBannersModel.fromJson(Map<String, dynamic> json) => GetBannersModel(
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
    String? type;
    String? image;
    int? createdAt;

    Datum({
        this.id,
        this.type,
        this.image,
        this.createdAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        type: json["type"],
        image: json["image"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "image": image,
        "createdAt": createdAt,
    };
}
