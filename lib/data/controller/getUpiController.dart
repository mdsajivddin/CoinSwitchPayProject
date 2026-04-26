import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getUpiModel.dart';
import 'package:riverpod/riverpod.dart';

final getUpiController = FutureProvider.autoDispose<GetUpiModel>((ref) async {
  final service = ApiNetwork(createDio());
  return await service.getAllUpi();
});
