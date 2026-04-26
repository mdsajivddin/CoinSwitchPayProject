// // import 'dart:developer';

// // import 'package:dio/dio.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:payment_app/Screen/p2pWaitingPayment.page.dart';
// // import 'package:payment_app/Screen/paymentRecive.page.dart';
// // import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
// // import 'package:payment_app/config/network/api.network.dart';
// // import 'package:payment_app/config/utils/pretty.dio.dart';
// // import 'package:payment_app/config/utils/showMessage.dart';
// // import 'package:payment_app/data/controller/buyP2pListController.dart';
// // import 'package:payment_app/data/model/p2pSaveSellRequestBodyModel.dart' as SaveSellRequestBodyModel;
// // import 'package:payment_app/data/model/p2pSaveSellRequestResModel.dart' as SaveSellRequestResModel;
// // import 'package:payment_app/data/model/p2pSaveSellRequestResModel.dart';

// // class P2pSaveSellRequestController
// //     extends StateNotifier<AsyncValue<SaveSellRequestResModel.SaveSellRequestResModel?>> {
// //   final Ref ref;
// //   P2pSaveSellRequestController(this.ref) : super(const AsyncValue.data(null));

// //   Future<void> p2pSaveSellRequest({
// //     required BuildContext context,
// //     required String holderName,
// //     required String depositId,
// //     required String label,
// //     required String upiId,
// //   }) async {
// //     try {
// //       state = const AsyncValue.loading();
// //       final service = ApiNetwork(createDio());

// //       final body = SaveSellRequestBodyModel(
// //         orderId: depositId,
// //         paymentMethods: [
// //           PaymentMethod(
// //             methodType: "UPI",
// //             label: label,
// //             details: Details(upiId: upiId, holderName: holderName),
// //           ),
// //         ],
// //       );
// //       final response = await service.p2pSaveSell(body);

// //       // SAHI LOGIC: Agar error false hai aur code 0 hai (Success)
// //       if (response.error == false && response.code == 0) {
// //         state = AsyncValue.data(response);

// //         Navigator.push(
// //           context,
// //           RightSlideFadeRoute(page: P2pWaitingPaymentPage()),
// //         );

// //         ShowMessage.success(
// //           context,
// //           response.message ?? "Deposit submitted successfully",
// //         );
// //       } else {
// //         // Agar API error response deti hai (e.g. error: true)
// //         state = const AsyncValue.data(null);
// //         ShowMessage.error(context, response.message ?? "Submission failed");
// //       }
// //     } catch (e, st) {
// //       state = const AsyncValue.data(null);
// //       log("Error: $e");
// //       log("Stacktrace: $st");

// //       if (e is DioException) {
// //         final errorMessage =
// //             e.response?.data?["message"] ?? "Network error occurred";
// //         ShowMessage.error(context, errorMessage);
// //       } else {
// //         ShowMessage.error(context, "An unexpected error occurred");
// //       }
// //     }
// //   }
// // }

// // final p2pSaveSellProvider = StateNotifierProvider<
// //   P2pSaveSellRequestController,
// //   AsyncValue<SaveSellRequestResModel?>
// // >((ref) => P2pSaveSellRequestController(ref));

// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payment_app/Screen/p2pWaitingPayment.page.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';

// // ✅ Alias Imports
// import 'package:payment_app/data/model/p2pSaveSellRequestBodyModel.dart'
//     as requestModel;
// import 'package:payment_app/data/model/p2pSaveSellRequestResModel.dart'
//     as responseModel;

// class P2pSaveSellRequestController
//     extends StateNotifier<AsyncValue<responseModel.SaveSellRequestResModel?>> {
//   final Ref ref;

//   P2pSaveSellRequestController(this.ref) : super(const AsyncValue.data(null));

//   Future<void> p2pSaveSellRequest({
//     required BuildContext context,
//     required String holderName,
//     required String depositId,
//     required String label,
//     required String upiId,
//     required int remainingSeconds,
//   }) async {
//     try {
//       state = const AsyncValue.loading();
//       final service = ApiNetwork(createDio());

//       // ✅ Proper Prefix Use
//       final body = requestModel.SaveSellRequestBodyModel(
//         orderId: depositId,
//         paymentMethods: [
//           requestModel.PaymentMethod(
//             methodType: "UPI",
//             label: label,
//             details: requestModel.Details(upiId: upiId, holderName: holderName),
//           ),
//         ],
//       );

//       final response = await service.p2pSaveSell(body);

//       if (response.error == false && response.code == 0) {
//         state = AsyncValue.data(response);

//         Navigator.push(
//           context,
//           RightSlideFadeRoute(page: const P2pWaitingPaymentPage()),
//         );

//         ShowMessage.success(
//           context,
//           response.message ?? "Sell request submitted successfully",
//         );
//       } else {
//         state = const AsyncValue.data(null);
//         ShowMessage.error(context, response.message ?? "Submission failed");
//       }
//     } catch (e, st) {
//       state = const AsyncValue.data(null);
//       log("Error: $e");
//       log("Stacktrace: $st");

//       if (e is DioException) {
//         final errorMessage =
//             e.response?.data?["message"] ?? "Network error occurred";
//         ShowMessage.error(context, errorMessage);
//       } else {
//         ShowMessage.error(context, "An unexpected error occurred");
//       }
//     }
//   }
// }

// final p2pSaveSellProvider = StateNotifierProvider<
//   P2pSaveSellRequestController,
//   AsyncValue<responseModel.SaveSellRequestResModel?>
// >((ref) => P2pSaveSellRequestController(ref));
