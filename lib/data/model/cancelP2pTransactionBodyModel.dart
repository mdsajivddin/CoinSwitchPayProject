// To parse this JSON data, do
//
//     final CancelP2pTransactionBodyModel = CancelP2pTransactionBodyModelFromJson(jsonString);

import 'dart:convert';

CancelP2pTransactionBodyModel CancelP2pTransactionBodyModelFromJson(String str) => CancelP2pTransactionBodyModel.fromJson(json.decode(str));

String CancelP2pTransactionBodyModelToJson(CancelP2pTransactionBodyModel data) => json.encode(data.toJson());

class CancelP2pTransactionBodyModel {
    String? id;

    CancelP2pTransactionBodyModel({
        this.id,
    });

    factory CancelP2pTransactionBodyModel.fromJson(Map<String, dynamic> json) => CancelP2pTransactionBodyModel(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
