import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getPendingSellOrpdersModel.dart';

final getPendingSellOrdersControlelr =
    FutureProvider<GetPendingSellOrdersModel>((ref) async {
      final serivice = ApiNetwork(createDio());
      return await serivice.getPendingSellOrpders();
    });
