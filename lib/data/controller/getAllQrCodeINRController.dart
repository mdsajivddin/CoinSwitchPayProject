import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getAllQrCodeInrResModel.dart';

final getAllQrCodeINRController = FutureProvider.autoDispose<GetAllQrCodeInrResModel>((
  ref,
) async {
  final service = ApiNetwork(createDio());
  return await service.getAllQrCodeINR();
});
