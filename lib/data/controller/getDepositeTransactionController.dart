// Provider definition
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/data/model/getDepositeTransactionLIstModel.dart';

final transactionProvider = StateNotifierProvider.family<
  TransactionNotifier,
  AsyncValue<GetDepositTransactionListModel?>,
  String
>((ref, walletType) {
  return TransactionNotifier(ref, walletType);
});

final apiClientProvider = Provider<ApiNetwork>((ref) {
  final dio = createDio();
  return ApiNetwork(dio);
});

class TransactionNotifier
    extends StateNotifier<AsyncValue<GetDepositTransactionListModel?>> {
  final Ref ref;
  final String walletType;

  TransactionNotifier(this.ref, this.walletType)
    : super(const AsyncValue.loading()) {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    state = const AsyncValue.loading();
    try {
      // API call using retrofit client
      final response = await ref
          .read(apiClientProvider)
          .getTransactions(
            page: 1,
            limit: 10,
            txType: 'deposit',
            walletType: walletType, // Dynamic parameter
          );
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
