import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getDepositeDetailsModel.dart';

final getdepositeDetislController = FutureProvider.family
    .autoDispose<GetDepositeDetaislModel, String>((ref, id) async {
      final service = ApiNetwork(createDio());
      return await service.getDepositById(id);
    });
