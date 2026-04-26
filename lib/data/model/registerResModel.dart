import 'dart:convert';

RegisterResModel registerResModelFromJson(String str) =>
    RegisterResModel.fromJson(json.decode(str));

String registerResModelToJson(RegisterResModel data) =>
    json.encode(data.toJson());

class RegisterResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  RegisterResModel({this.message, this.code, this.error, this.data});

  factory RegisterResModel.fromJson(Map<String, dynamic> json) =>
      RegisterResModel(
        message: json["message"]?.toString(),
        code:
            json["code"] is int
                ? json["code"]
                : int.tryParse(json["code"]?.toString() ?? ""),
        error:
            json["error"] is bool
                ? json["error"]
                : json["error"].toString() == "true",
        data:
            json["data"] is Map<String, dynamic>
                ? Data.fromJson(json["data"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "error": error,
    "data": data?.toJson(),
  };
}

class Data {
  String? token;

  Data({this.token});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"]?.toString());

  Map<String, dynamic> toJson() => {"token": token};
}
