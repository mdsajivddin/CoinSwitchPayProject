import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getSellByIdDetailsModel.dart';

final getSellByIdController = FutureProvider.family
    .autoDispose<GetSellByIdDetailsModel, String>((ref, id) async {
      final srvice = ApiNetwork(createDio());
      return await srvice.getSellById(id);
    });
