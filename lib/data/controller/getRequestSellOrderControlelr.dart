import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:riverpod/riverpod.dart';

final getRequestSellOrderControlelr = FutureProvider((ref) async {
  final serivce = ApiNetwork(createDio());
  return await serivce.getRequestSellOrders();
});
