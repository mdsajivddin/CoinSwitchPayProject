import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/usdtToInrSellHistoryModel.dart';

final usdtToSellInrHistoryController =
    FutureProvider.autoDispose<UsdtToInrSellHistoryModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.usdtToInrSellHistory();
    });
