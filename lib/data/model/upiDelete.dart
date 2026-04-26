// To parse this JSON data, do
//
//     final upiDeleteResModel = upiDeleteResModelFromJson(jsonString);

import 'dart:convert';

UpiDeleteResModel upiDeleteResModelFromJson(String str) => UpiDeleteResModel.fromJson(json.decode(str));

String upiDeleteResModelToJson(UpiDeleteResModel data) => json.encode(data.toJson());

class UpiDeleteResModel {
    String? message;
    int? code;
    bool? error;
    dynamic data;

    UpiDeleteResModel({
        this.message,
        this.code,
        this.error,
        this.data,
    });

    factory UpiDeleteResModel.fromJson(Map<String, dynamic> json) => UpiDeleteResModel(
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



// To parse this JSON data, do
//
//     final upiDeleteBodyModel = upiDeleteBodyModelFromJson(jsonString);



UpiDeleteBodyModel upiDeleteBodyModelFromJson(String str) => UpiDeleteBodyModel.fromJson(json.decode(str));

String upiDeleteBodyModelToJson(UpiDeleteBodyModel data) => json.encode(data.toJson());

class UpiDeleteBodyModel {
    String? id;

    UpiDeleteBodyModel({
        this.id,
    });

    factory UpiDeleteBodyModel.fromJson(Map<String, dynamic> json) => UpiDeleteBodyModel(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
