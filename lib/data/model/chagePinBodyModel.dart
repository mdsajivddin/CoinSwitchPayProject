// To parse this JSON data, do
//
//     final changePinBodyModel = changePinBodyModelFromJson(jsonString);

import 'dart:convert';

ChangePinBodyModel changePinBodyModelFromJson(String str) => ChangePinBodyModel.fromJson(json.decode(str));

String changePinBodyModelToJson(ChangePinBodyModel data) => json.encode(data.toJson());

class ChangePinBodyModel {
    String? oldPin;
    String? newPin;
    String? confirmPin;

    ChangePinBodyModel({
        this.oldPin,
        this.newPin,
        this.confirmPin,
    });

    factory ChangePinBodyModel.fromJson(Map<String, dynamic> json) => ChangePinBodyModel(
        oldPin: json["oldPin"],
        newPin: json["newPin"],
        confirmPin: json["confirmPin"],
    );

    Map<String, dynamic> toJson() => {
        "oldPin": oldPin,
        "newPin": newPin,
        "confirmPin": confirmPin,
    };
}
