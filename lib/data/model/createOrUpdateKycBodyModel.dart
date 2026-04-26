// To parse this JSON data, do
//
//     final createOrUpdateKycBodyModel = createOrUpdateKycBodyModelFromJson(jsonString);

import 'dart:convert';

CreateOrUpdateKycBodyModel createOrUpdateKycBodyModelFromJson(String str) => CreateOrUpdateKycBodyModel.fromJson(json.decode(str));

String createOrUpdateKycBodyModelToJson(CreateOrUpdateKycBodyModel data) => json.encode(data.toJson());

class CreateOrUpdateKycBodyModel {
    String? front;
    String? back;
    String? name;
    String? amount;
    String? hash;
    String? screenshotImage;

    CreateOrUpdateKycBodyModel({
        this.front,
        this.back,
        this.name,
        this.amount,
        this.hash,
        this.screenshotImage,
    });

    factory CreateOrUpdateKycBodyModel.fromJson(Map<String, dynamic> json) => CreateOrUpdateKycBodyModel(
        front: json["front"],
        back: json["back"],
        name: json["name"],
        amount: json["amount"],
        hash: json["hash"],
        screenshotImage: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "front": front,
        "back": back,
        "name": name,
        "amount": amount,
        "hash": hash,
        "image": screenshotImage,
    };
}
