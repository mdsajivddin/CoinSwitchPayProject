// To parse this JSON data, do
//
//     final getWalletCommissionModel = getWalletCommissionModelFromJson(jsonString);

import 'dart:convert';

GetWalletCommissionModel getWalletCommissionModelFromJson(String str) =>
    GetWalletCommissionModel.fromJson(json.decode(str));

String getWalletCommissionModelToJson(GetWalletCommissionModel data) =>
    json.encode(data.toJson());

class GetWalletCommissionModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetWalletCommissionModel({this.message, this.code, this.error, this.data});

  factory GetWalletCommissionModel.fromJson(Map<String, dynamic> json) =>
      GetWalletCommissionModel(
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

// class Data {
//     int? usdtAmount;
//     int? tokenAmount;

//     Data({
//         this.usdtAmount,
//         this.tokenAmount,
//     });

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         usdtAmount: json["usdtAmount"],
//         tokenAmount: json["tokenAmount"],
//     );

//     Map<String, dynamic> toJson() => {
//         "usdtAmount": usdtAmount,
//         "tokenAmount": tokenAmount,
//     };
// }

class Data {
  double? usdtAmount;
  double? tokenAmount;

  Data({this.usdtAmount, this.tokenAmount});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    usdtAmount: _toDouble(json["usdtAmount"]),
    tokenAmount: _toDouble(json["tokenAmount"]),
  );

  Map<String, dynamic> toJson() => {
    "usdtAmount": usdtAmount,
    "tokenAmount": tokenAmount,
  };

  // 🔥 Safe converter (int, double, string sab handle karega)
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }
}
