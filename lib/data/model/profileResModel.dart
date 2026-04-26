import 'dart:convert';

ProfileResModel profileResModelFromJson(String str) =>
    ProfileResModel.fromJson(json.decode(str));

String profileResModelToJson(ProfileResModel data) =>
    json.encode(data.toJson());

class ProfileResModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  ProfileResModel({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory ProfileResModel.fromJson(Map<String, dynamic> json) =>
      ProfileResModel(
        message: json["message"],
        code: _toInt(json["code"]),
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
  User? user;
  Wallet? wallet;
  Stats? stats;
  CommissionPercent? commissionPercent;
  int? notificationCount;

  Data({
    this.user,
    this.wallet,
    this.stats,
    this.commissionPercent,
    this.notificationCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        commissionPercent: json["commissionPercent"] == null
            ? null
            : CommissionPercent.fromJson(json["commissionPercent"]),
        notificationCount: _toInt(json["notificationCount"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "wallet": wallet?.toJson(),
        "stats": stats?.toJson(),
        "commissionPercent": commissionPercent?.toJson(),
        "notificationCount": notificationCount,
      };
}

class CommissionPercent {
  String? value;

  CommissionPercent({this.value});

  factory CommissionPercent.fromJson(Map<String, dynamic> json) =>
      CommissionPercent(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class Stats {
  int? todayWithdraw;
  int? remainBalance;

  Stats({
    this.todayWithdraw,
    this.remainBalance,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        todayWithdraw: _toInt(json["todayWithdraw"]),
        remainBalance: _toInt(json["remainBalance"]),
      );

  Map<String, dynamic> toJson() => {
        "todayWithdraw": todayWithdraw,
        "remainBalance": remainBalance,
      };
}

class User {
  String? id;
  String? name;
  String? mobile;
  String? userName;
  String? email;
  String? password;
  dynamic deviceId;
  String? referralCode;
  String? refByCode;
  String? referredBy;
  List<String>? referralChain;
  bool? isKyc;
  String? inrPin;
  String? image;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;

  User({
    this.id,
    this.name,
    this.mobile,
    this.userName,
    this.email,
    this.password,
    this.deviceId,
    this.referralCode,
    this.refByCode,
    this.referredBy,
    this.referralChain,
    this.isKyc,
    this.inrPin,
    this.image,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        userName: json["userName"],
        password: json["password"],
        deviceId: json["deviceId"],
        referralCode: json["referralCode"],
        refByCode: json["refByCode"],
        referredBy: json["referredBy"],
        referralChain: json["referralChain"] == null
            ? []
            : List<String>.from(json["referralChain"].map((x) => x)),
        isKyc: json["isKyc"],
        inrPin: json["inrPin"],
        image: json["image"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: _toInt(json["date"]),
        month: _toInt(json["month"]),
        year: _toInt(json["year"]),
        createdAt: _toInt(json["createdAt"]),
        updatedAt: _toInt(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mobile": mobile,
        "userName": userName,
        "email": email,
        "password": password,
        "deviceId": deviceId,
        "referralCode": referralCode,
        "refByCode": refByCode,
        "referredBy": referredBy,
        "referralChain": referralChain == null
            ? []
            : List<dynamic>.from(referralChain!.map((x) => x)),
        "isKyc": isKyc,
        "inrPin": inrPin,
        "image": image,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Wallet {
  Map<String, int>? totalCommission;
  String? id;
  String? userId;

  double? usdt;
  double? token;
  double? freezeBalance;

  bool? isDisable;
  bool? isDeleted;

  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;

  Wallet({
    this.totalCommission,
    this.id,
    this.userId,
    this.usdt,
    this.token,
    this.freezeBalance,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        totalCommission: json["totalCommission"] == null
            ? {}
            : Map.from(json["totalCommission"])
                .map((k, v) => MapEntry<String, int>(k, _toInt(v) ?? 0)),
        id: json["_id"],
        userId: json["userId"],
        usdt: _toDouble(json["usdt"]),
        token: _toDouble(json["token"]),
        freezeBalance: _toDouble(json["freezeBalance"]),
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: _toInt(json["date"]),
        month: _toInt(json["month"]),
        year: _toInt(json["year"]),
        createdAt: _toInt(json["createdAt"]),
        updatedAt: _toInt(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "totalCommission": Map.from(totalCommission ?? {})
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "_id": id,
        "userId": userId,
        "usdt": usdt,
        "token": token,
        "freezeBalance": freezeBalance,
        "isDisable": isDisable,
        "isDeleted": isDeleted,
        "date": date,
        "month": month,
        "year": year,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

/// SAFE INT PARSER
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

/// SAFE DOUBLE PARSER
double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return double.tryParse(value.toString());
}