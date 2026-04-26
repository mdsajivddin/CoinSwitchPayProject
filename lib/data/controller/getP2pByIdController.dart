import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getP2pByIdModel.dart';

final getP2pByIdController = FutureProvider.family
    .autoDispose<GetP2PByIdModel, String>((ref, id) async {
      final service = ApiNetwork(createDio());
      return await service.getP2pByID(id);
    });
