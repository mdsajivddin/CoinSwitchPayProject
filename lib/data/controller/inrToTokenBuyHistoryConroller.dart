import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/inrToTokenBuyHistoryModel.dart';
import 'package:payment_app/data/model/tokenToInrSllHistoryModel.dart';

final InrToTokenBuyHistoryController =
    FutureProvider.autoDispose<IntToTokenBuyHistoryModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.inrToTokenBuyHistory();
    });

final tokenToInrSellHistoryControlelr =
    FutureProvider.autoDispose<TokenToInrSellHistoryModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.tokenToInrSellingHistory();
    });
