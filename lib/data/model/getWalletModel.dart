// To parse this JSON data, do
//
// final getWalletModel = getWalletModelFromJson(jsonString);

import 'dart:convert';

GetWalletModel getWalletModelFromJson(String str) =>
    GetWalletModel.fromJson(json.decode(str));

String getWalletModelToJson(GetWalletModel data) =>
    json.encode(data.toJson());

class GetWalletModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  GetWalletModel({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory GetWalletModel.fromJson(Map<String, dynamic> json) =>
      GetWalletModel(
        message: json["message"],
        code: (json["code"] as num?)?.toInt(),
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
  double? totalUsdt;
  double? totalToken;
  double? totalUsdtCommission;
  double? totalTokenCommission;
  Stats? stats;
  ActiveSelling? activeSelling;

  Data({
    this.totalUsdt,
    this.totalToken,
    this.totalUsdtCommission,
    this.totalTokenCommission,
    this.stats,
    this.activeSelling,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalUsdt: (json["totalUsdt"] as num?)?.toDouble(),
        totalToken: (json["totalToken"] as num?)?.toDouble(),
        totalUsdtCommission: (json["totalUsdtCommission"] as num?)?.toDouble(),
        totalTokenCommission: (json["totalTokenCommission"] as num?)?.toDouble(),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        activeSelling: json["activeSelling"] == null
            ? null
            : ActiveSelling.fromJson(json["activeSelling"]),
      );

  Map<String, dynamic> toJson() => {
        "totalUsdt": totalUsdt,
        "totalToken": totalToken,
        "totalUsdtCommission": totalUsdtCommission,
        "totalTokenCommission": totalTokenCommission,
        "stats": stats?.toJson(),
        "activeSelling": activeSelling?.toJson(),
      };
}

class ActiveSelling {
  double? tokenSelling;
  double? usdtSelling;

  ActiveSelling({
    this.tokenSelling,
    this.usdtSelling,
  });

  factory ActiveSelling.fromJson(Map<String, dynamic> json) =>
      ActiveSelling(
        tokenSelling: (json["tokenSelling"] as num?)?.toDouble(),
        usdtSelling: (json["usdtSelling"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "tokenSelling": tokenSelling,
        "usdtSelling": usdtSelling,
      };
}

class Stats {
  double? usdtBuy;
  double? tokenBuy;
  double? usdtSold;
  double? tokenSold;

  Stats({
    this.usdtBuy,
    this.tokenBuy,
    this.usdtSold,
    this.tokenSold,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        usdtBuy: (json["usdtBuy"] as num?)?.toDouble(),
        tokenBuy: (json["tokenBuy"] as num?)?.toDouble(),
        usdtSold: (json["usdtSold"] as num?)?.toDouble(),
        tokenSold: (json["tokenSold"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "usdtBuy": usdtBuy,
        "tokenBuy": tokenBuy,
        "usdtSold": usdtSold,
        "tokenSold": tokenSold,
      };
}