import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getAllUserTicketListModel.dart';
import 'package:payment_app/data/model/getTicketByIdModel.dart';

final getAllUserTicketController =
    FutureProvider.autoDispose<GetUserAllTicketListModel>((ref) async {
      final service = ApiNetwork(createDio());
      return await service.getUserAllTicketList();
    });

final getTicketByIdController = FutureProvider.family
    .autoDispose<GetTicketByIdModel, String>((ref, id) async {
      final service = ApiNetwork(createDio());
      return await service.getTicketById(id);
    });
