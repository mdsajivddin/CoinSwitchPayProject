// To parse this JSON data, do
//
//     final deleteBankResModel = deleteBankResModelFromJson(jsonString);

import 'dart:convert';

DeleteBankResModel deleteBankResModelFromJson(String str) => DeleteBankResModel.fromJson(json.decode(str));

String deleteBankResModelToJson(DeleteBankResModel data) => json.encode(data.toJson());

class DeleteBankResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    DeleteBankResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory DeleteBankResModel.fromJson(Map<String, dynamic> json) => DeleteBankResModel(
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
