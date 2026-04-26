// To parse this JSON data, do
//
//     final createSellOrderResModel = createSellOrderResModelFromJson(jsonString);

import 'dart:convert';

CreateSellOrderResModel createSellOrderResModelFromJson(String str) => CreateSellOrderResModel.fromJson(json.decode(str));

String createSellOrderResModelToJson(CreateSellOrderResModel data) => json.encode(data.toJson());

class CreateSellOrderResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    CreateSellOrderResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory CreateSellOrderResModel.fromJson(Map<String, dynamic> json) => CreateSellOrderResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "error": error,
        "data": data,
    };
}
