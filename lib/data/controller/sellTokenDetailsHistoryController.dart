import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/sellTokenDetailsHistoryModel.dart';

final sellTokenDetailsHistoryController =
    FutureProvider.family.autoDispose<SellTokenDetailsHistoryModel, String>((
      ref,
      id,
    ) async {
      final service = ApiNetwork(createDio());
      return await service.sellTokenDetailsHistoryModel(id);
    });
