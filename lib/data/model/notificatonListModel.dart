import 'dart:convert';

NotificatonListModel notificatonListModelFromJson(String str) =>
    NotificatonListModel.fromJson(json.decode(str));

String notificatonListModelToJson(NotificatonListModel data) =>
    json.encode(data.toJson());

class NotificatonListModel {
  String? message;
  int? code;
  bool? error;
  Data? data;

  NotificatonListModel({this.message, this.code, this.error, this.data});

  factory NotificatonListModel.fromJson(Map<String, dynamic> json) =>
      NotificatonListModel(
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
  List<NotificationItem>? list;
  int? total;
  String? pageNo;
  String? size;
  int? totalPages;

  Data({this.list, this.total, this.pageNo, this.size, this.totalPages});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    list:
        json["list"] == null
            ? []
            : List<NotificationItem>.from(
              json["list"].map((x) => NotificationItem.fromJson(x)),
            ),
    total: json["total"],
    pageNo: json["pageNo"],
    size: json["size"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "list":
        list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
    "total": total,
    "pageNo": pageNo,
    "size": size,
    "totalPages": totalPages,
  };
}

class NotificationItem {
  String? id;
  String? userId;
  String? orderId;
  String? orderModel;
  String? name;
  String? msg;
  bool? isRed;
  bool? isDisable;
  bool? isDeleted;
  int? date;
  int? month;
  int? year;
  int? createdAt;
  int? updatedAt;
  int? v;

  NotificationItem({
    this.id,
    this.userId,
    this.orderId,
    this.orderModel,
    this.name,
    this.msg,
    this.isRed,
    this.isDisable,
    this.isDeleted,
    this.date,
    this.month,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json["_id"],
        userId: json["userId"],
        orderId: json["orderId"],
        orderModel: json["orderModel"],
        name: json["name"],
        msg: json["msg"],
        isRed: json["isRed"],
        isDisable: json["isDisable"],
        isDeleted: json["isDeleted"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "orderId": orderId,
    "orderModel": orderModel,
    "name": name,
    "msg": msg,
    "isRed": isRed,
    "isDisable": isDisable,
    "isDeleted": isDeleted,
    "date": date,
    "month": month,
    "year": year,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}
