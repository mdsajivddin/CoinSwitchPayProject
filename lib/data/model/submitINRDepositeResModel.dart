import 'dart:convert';

SubmitInrDepositeResModel submitInrDepositeResModelFromJson(String str) =>
    SubmitInrDepositeResModel.fromJson(json.decode(str));

String submitInrDepositeResModelToJson(SubmitInrDepositeResModel data) =>
    json.encode(data.toJson());

class SubmitInrDepositeResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  SubmitInrDepositeResModel({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory SubmitInrDepositeResModel.fromJson(Map<String, dynamic> json) =>
      SubmitInrDepositeResModel(
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
  double? creditedAmount;
  double? bonus;
  double? walletBalance;

  Data({
    this.creditedAmount,
    this.bonus,
    this.walletBalance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        creditedAmount: (json["creditedAmount"] as num?)?.toDouble(),
        bonus: (json["bonus"] as num?)?.toDouble(),
        walletBalance: (json["walletBalance"] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "creditedAmount": creditedAmount,
        "bonus": bonus,
        "walletBalance": walletBalance,
      };
}