// To parse this JSON data, do
//
//     final depositeUsdtResModel = depositeUsdtResModelFromJson(jsonString);

import 'dart:convert';

DepositeUsdtResModel depositeUsdtResModelFromJson(String str) =>
    DepositeUsdtResModel.fromJson(json.decode(str));

String depositeUsdtResModelToJson(DepositeUsdtResModel data) =>
    json.encode(data.toJson());

class DepositeUsdtResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  DepositeUsdtResModel({this.message, this.code, this.error, this.data});

  factory DepositeUsdtResModel.fromJson(Map<String, dynamic> json) =>
      DepositeUsdtResModel(
        message: json["message"],
        code: json["code"],
        error: json["error"],
        // data: json["data"] == null ? null : Data.fromJson(json["data"]),
        data:
            json["data"] is Map<String, dynamic>
                ? Data.fromJson(json["data"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "error": error,
    // "data": data?.toJson(),
    "data": data?.toJson(),
  };
}

class Data {
  String? depositId;
  int? amount;
  String? network;
  DateTime? expiresAt;
  String? walletAddress;

  Data({
    this.depositId,
    this.amount,
    this.network,
    this.expiresAt,
    this.walletAddress,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    depositId: json["depositId"],
    amount: json["amount"],
    network: json["network"],
    // expiresAt:
    //     json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
    expiresAt: _parseExpiresAt(json["expiresAt"]),
    walletAddress: json["walletAddress"],
  );

  Map<String, dynamic> toJson() => {
    "depositId": depositId,
    "amount": amount,
    "network": network,
    "expiresAt": expiresAt?.toIso8601String(),
    "walletAddress": walletAddress,
  };

  static DateTime? _parseExpiresAt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      // 👇 milliseconds timestamp
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
