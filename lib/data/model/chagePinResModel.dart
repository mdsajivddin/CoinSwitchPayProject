// To parse this JSON data, do
//
//     final setPinInrResModel = setPinInrResModelFromJson(jsonString);

import 'dart:convert';

SetPinInrResModel setPinInrResModelFromJson(String str) => SetPinInrResModel.fromJson(json.decode(str));

String setPinInrResModelToJson(SetPinInrResModel data) => json.encode(data.toJson());

class SetPinInrResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    SetPinInrResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory SetPinInrResModel.fromJson(Map<String, dynamic> json) => SetPinInrResModel(
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
