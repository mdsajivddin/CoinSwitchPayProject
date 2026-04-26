// To parse this JSON data, do
//
//     final readNotificationModel = readNotificationModelFromJson(jsonString);

import 'dart:convert';

ReadNotificationModel readNotificationModelFromJson(String str) => ReadNotificationModel.fromJson(json.decode(str));

String readNotificationModelToJson(ReadNotificationModel data) => json.encode(data.toJson());

class ReadNotificationModel {
    String? message;
    int? code;
    bool? error;
    Data? data;

    ReadNotificationModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory ReadNotificationModel.fromJson(Map<String, dynamic> json) => ReadNotificationModel(
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
    bool? acknowledged;
    int? modifiedCount;
    dynamic upsertedId;
    int? upsertedCount;
    int? matchedCount;

    Data({
        this.acknowledged,
        this.modifiedCount,
        this.upsertedId,
        this.upsertedCount,
        this.matchedCount,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        acknowledged: json["acknowledged"],
        modifiedCount: json["modifiedCount"],
        upsertedId: json["upsertedId"],
        upsertedCount: json["upsertedCount"],
        matchedCount: json["matchedCount"],
    );

    Map<String, dynamic> toJson() => {
        "acknowledged": acknowledged,
        "modifiedCount": modifiedCount,
        "upsertedId": upsertedId,
        "upsertedCount": upsertedCount,
        "matchedCount": matchedCount,
    };
}
