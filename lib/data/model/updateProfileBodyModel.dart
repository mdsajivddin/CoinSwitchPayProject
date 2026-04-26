// To parse this JSON data, do
//
//     final updateProfileBodyModel = updateProfileBodyModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileBodyModel updateProfileBodyModelFromJson(String str) => UpdateProfileBodyModel.fromJson(json.decode(str));

String updateProfileBodyModelToJson(UpdateProfileBodyModel data) => json.encode(data.toJson());

class UpdateProfileBodyModel {
    String? name;

    UpdateProfileBodyModel({
        this.name,
    });

    factory UpdateProfileBodyModel.fromJson(Map<String, dynamic> json) => UpdateProfileBodyModel(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
