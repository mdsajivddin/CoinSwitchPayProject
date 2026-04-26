// To parse this JSON data, do
//
//     final getFoundTransferModel = getFoundTransferModelFromJson(jsonString);

import 'dart:convert';

GetFoundTransferModel getFoundTransferModelFromJson(String str) =>
    GetFoundTransferModel.fromJson(json.decode(str));

String getFoundTransferModelToJson(GetFoundTransferModel data) =>
    json.encode(data.toJson());

class GetFoundTransferModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetFoundTransferModel({this.message, this.code, this.error, this.data});

  factory GetFoundTransferModel.fromJson(Map<String, dynamic> json) =>
      GetFoundTransferModel(
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
  String? upi;
  String? imps;
  String? cdm;
  String? rtgs;

  Data({this.upi, this.imps, this.cdm, this.rtgs});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    // upi: json["upi"],
    // imps: json["imps"],
    // cdm: json["cdm"],
    // rtgs: json["rtgs"],
    upi: _parseToString(json["upi"]),
    imps: _parseToString(json["imps"]),
    cdm: _parseToString(json["cdm"]),
    rtgs: _parseToString(json["rtgs"]),
  );

  Map<String, dynamic> toJson() => {
    "upi": upi,
    "imps": imps,
    "cdm": cdm,
    "rtgs": rtgs,
  };

  /// 🔥 Helper (handles int, double, string, null)
  static String _parseToString(dynamic value) {
    if (value == null) return "0";
    return value.toString();
  }
}
