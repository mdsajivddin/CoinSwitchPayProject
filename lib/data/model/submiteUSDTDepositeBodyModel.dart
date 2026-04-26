// To parse this JSON data, do
//
//     final submitUsdtDepositeBodyModel = submitUsdtDepositeBodyModelFromJson(jsonString);

import 'dart:convert';

SubmitUsdtDepositeBodyModel submitUsdtDepositeBodyModelFromJson(String str) => SubmitUsdtDepositeBodyModel.fromJson(json.decode(str));

String submitUsdtDepositeBodyModelToJson(SubmitUsdtDepositeBodyModel data) => json.encode(data.toJson());

class SubmitUsdtDepositeBodyModel {
    String? depositId;
    String? hash;
    String? image;
    String? pin;

    SubmitUsdtDepositeBodyModel({
        this.depositId,
        this.hash,
        this.image,
        this.pin,
    });

    factory SubmitUsdtDepositeBodyModel.fromJson(Map<String, dynamic> json) => SubmitUsdtDepositeBodyModel(
        depositId: json["depositId"],
        hash: json["hash"],
        image: json["image"],
        pin: json["pin"],
    );

    Map<String, dynamic> toJson() => {
        "depositId": depositId,
        "hash": hash,
        "image": image,
        "pin": pin,
    };
}
