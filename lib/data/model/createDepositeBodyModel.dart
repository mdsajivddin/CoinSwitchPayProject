// To parse this JSON data, do
//
//     final createDepositeBodyModel = createDepositeBodyModelFromJson(jsonString);

import 'dart:convert';

CreateDepositeBodyModel createDepositeBodyModelFromJson(String str) => CreateDepositeBodyModel.fromJson(json.decode(str));

String createDepositeBodyModelToJson(CreateDepositeBodyModel data) => json.encode(data.toJson());

class CreateDepositeBodyModel {
    int? amount;
    String? qrCodeId;
    String? image;
    String? hash;
    String? walletType;

    CreateDepositeBodyModel({
        this.amount,
        this.qrCodeId,
        this.image,
        this.hash,
        this.walletType,
    });

    factory CreateDepositeBodyModel.fromJson(Map<String, dynamic> json) => CreateDepositeBodyModel(
        amount: json["amount"],
        qrCodeId: json["qrCodeId"],
        image: json["image"],
        hash: json["hash"],
        walletType: json["walletType"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "qrCodeId": qrCodeId,
        "image": image,
        "hash": hash,
        "walletType": walletType,
    };
}
