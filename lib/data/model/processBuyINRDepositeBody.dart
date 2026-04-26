// To parse this JSON data, do
//
//     final processBuyInrDepositBodyModel = processBuyInrDepositBodyModelFromJson(jsonString);

import 'dart:convert';

ProcessBuyInrDepositBodyModel processBuyInrDepositBodyModelFromJson(String str) => ProcessBuyInrDepositBodyModel.fromJson(json.decode(str));

String processBuyInrDepositBodyModelToJson(ProcessBuyInrDepositBodyModel data) => json.encode(data.toJson());

class ProcessBuyInrDepositBodyModel {
    String? orderId;

    ProcessBuyInrDepositBodyModel({
        this.orderId,
    });

    factory ProcessBuyInrDepositBodyModel.fromJson(Map<String, dynamic> json) => ProcessBuyInrDepositBodyModel(
        orderId: json["orderId"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
    };
}
