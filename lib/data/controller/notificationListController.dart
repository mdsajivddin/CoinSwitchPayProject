import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/notificatonListModel.dart';
import 'package:payment_app/data/model/readNotificationModel.dart';

final notificationListController =
    FutureProvider.autoDispose<NotificatonListModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.notificationList();
    });

final readNotificationController =
    FutureProvider.autoDispose<ReadNotificationModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.readNotification();
    });
