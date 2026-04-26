import 'dart:io';

import 'package:dio/dio.dart';
import 'package:payment_app/data/model/addBankBodyModel.dart';
import 'package:payment_app/data/model/addBankResModel.dart';
import 'package:payment_app/data/model/agentshipModel.dart';
import 'package:payment_app/data/model/applyAgentshipBodyModel.dart';
import 'package:payment_app/data/model/applyAgentshipResModel.dart';
import 'package:payment_app/data/model/cancelP2pTransactionBodyModel.dart';
import 'package:payment_app/data/model/cancelP2pTransationResModel.dart';
import 'package:payment_app/data/model/createSupportBodyModel.dart';
import 'package:payment_app/data/model/createSupportResModel.dart';
import 'package:payment_app/data/model/getAllUserTicketListModel.dart';
import 'package:payment_app/data/model/getDepositeDetailsModel.dart';
import 'package:payment_app/data/model/getOrCreateTransactionP2pDetailsModel.dart';
import 'package:payment_app/data/model/buyP2pListResModel.dart';
import 'package:payment_app/data/model/cancelINRBodyModel.dart';
import 'package:payment_app/data/model/cancelINRResModel.dart';
import 'package:payment_app/data/model/cancelUSDTDepositeBodyMOdel.dart';
import 'package:payment_app/data/model/cancelUSDTDepositeResModel.dart';
import 'package:payment_app/data/model/confirmSellBodyModel.dart';
import 'package:payment_app/data/model/confirmSellResModel.dart';
import 'package:payment_app/data/model/createDepositeBodyModel.dart';
import 'package:payment_app/data/model/createDepositeResModel.dart';
import 'package:payment_app/data/model/createOrUpdateKycBodyModel.dart';
import 'package:payment_app/data/model/createOrUpdateKycResModel.dart';
import 'package:payment_app/data/model/createSellOrderBodyModel.dart';
import 'package:payment_app/data/model/createSellOrderResModel.dart';
import 'package:payment_app/data/model/createUpiModel.dart';
import 'package:payment_app/data/model/createWithdrawBodyModel.dart';
import 'package:payment_app/data/model/deleteBankBodyModel.dart';
import 'package:payment_app/data/model/deleteBankResModel.dart';
import 'package:payment_app/data/model/depositeINRListModel.dart';
import 'package:payment_app/data/model/depositeUSDTBodyModel.dart';
import 'package:payment_app/data/model/depositeUSDTResModel.dart';
import 'package:payment_app/data/model/forgotPassBodyModel.dart';
import 'package:payment_app/data/model/forgotPassResModel.dart';
import 'package:payment_app/data/model/forgotPinVerifyBody.dart';
import 'package:payment_app/data/model/forgotPinVerifyRes.dart';
import 'package:payment_app/data/model/forgotSendOTPResModel.dart';
import 'package:payment_app/data/model/getAllQRCodeTokenModel.dart';
import 'package:payment_app/data/model/getAllQrCodeInrResModel.dart';
import 'package:payment_app/data/model/allBannersModel.dart';
import 'package:payment_app/data/model/getBankResModel.dart';
import 'package:payment_app/data/model/getBuyInrDepositeModel.dart';
import 'package:payment_app/data/model/getDepositeTransactionLIstModel.dart';
import 'package:payment_app/data/model/getFoundTransferModel.dart';
import 'package:payment_app/data/model/getKycModel.dart';
import 'package:payment_app/data/model/getP2pByIdModel.dart';
import 'package:payment_app/data/model/getP2pExitBuyModel.dart';
import 'package:payment_app/data/model/getP2pTransactonModel.dart';
import 'package:payment_app/data/model/getP2pTransatinSellModel.dart';
import 'package:payment_app/data/model/getP2pTransationBuyModel.dart';
import 'package:payment_app/data/model/getPendingSellOrpdersModel.dart';
import 'package:payment_app/data/model/getRefralChainListModel.dart';
import 'package:payment_app/data/model/getRequestSellOrdersModel.dart';
import 'package:payment_app/data/model/getSellByIdDetailsModel.dart';
import 'package:payment_app/data/model/getTicketByIdModel.dart';
import 'package:payment_app/data/model/getUpiModel.dart';
import 'package:payment_app/data/model/getWallerCommissionModel.dart';
import 'package:payment_app/data/model/getWalletModel.dart';
import 'package:payment_app/data/model/inrToTokenBuyHistoryModel.dart';
import 'package:payment_app/data/model/loginBodyModel.dart';
import 'package:payment_app/data/model/loginResModel.dart';
import 'package:payment_app/data/model/loginVerifyBodyModel.dart';
import 'package:payment_app/data/model/loginVerifyResModel.dart';
import 'package:payment_app/data/model/notificatonListModel.dart';
import 'package:payment_app/data/model/p2pPaidBodyModel.dart';
import 'package:payment_app/data/model/p2pPaidResModel.dart';
import 'package:payment_app/data/model/p2pSaveSellRequestBodyModel.dart';
import 'package:payment_app/data/model/p2pSaveSellRequestResModel.dart';
import 'package:payment_app/data/model/processBuyINRDepositeBody.dart';
import 'package:payment_app/data/model/processBuyINRDepositeRes.dart';
import 'package:payment_app/data/model/profileResModel.dart';
import 'package:payment_app/data/model/raiseDisputeBodyModel.dart';
import 'package:payment_app/data/model/raiseDisputeResModel.dart';
import 'package:payment_app/data/model/readNotificationModel.dart';
import 'package:payment_app/data/model/realeaseAmountAccRejectBody.dart';
import 'package:payment_app/data/model/registerBodyModel.dart';
import 'package:payment_app/data/model/registerResModel.dart';
import 'package:payment_app/data/model/registerVerifyBodyModel.dart';
import 'package:payment_app/data/model/registerVerifyResModel.dart';
import 'package:payment_app/data/model/requestBuyOrderBodyModel.dart';
import 'package:payment_app/data/model/requestBuyOrderResModel.dart';
import 'package:payment_app/data/model/saveRequest.dart';
import 'package:payment_app/data/model/saveSellINRRequestBodyModel.dart';
import 'package:payment_app/data/model/sellP2pDetailsModel.dart';
import 'package:payment_app/data/model/sellTokenDetailsHistoryModel.dart';
import 'package:payment_app/data/model/sellUpiModel.dart';
import 'package:payment_app/data/model/chagePinBodyModel.dart';
import 'package:payment_app/data/model/chagePinResModel.dart';
import 'package:payment_app/data/model/sendOTPForgotPinRes.dart';
import 'package:payment_app/data/model/submitINRDepositeBodyModel.dart';
import 'package:payment_app/data/model/submitINRDepositeResModel.dart';
import 'package:payment_app/data/model/submitUSDTDEpositeResModel.dart';
import 'package:payment_app/data/model/submiteUSDTDepositeBodyModel.dart';
import 'package:payment_app/data/model/tokenToInrSllHistoryModel.dart';
import 'package:payment_app/data/model/updateBankStatusBodyModel.dart';
import 'package:payment_app/data/model/updateBankStatusResModel.dart';
import 'package:payment_app/data/model/updateImageResModel.dart';
import 'package:payment_app/data/model/updateProfileBodyModel.dart';
import 'package:payment_app/data/model/updateProfileResModel.dart';
import 'package:payment_app/data/model/updateUpiStatus.dart';
import 'package:payment_app/data/model/upiDelete.dart';
import 'package:payment_app/data/model/uploadImageResModel.dart';
import 'package:payment_app/data/model/usdtDepositeHistoryModel.dart';
import 'package:payment_app/data/model/usdtToInrSellHistoryModel.dart';
import 'package:payment_app/data/model/withdrawBodyModel.dart';
import 'package:payment_app/data/model/withdrawResModel.dart';
import 'package:retrofit/retrofit.dart';

part 'api.network.g.dart';

// @RestApi(baseUrl: "https://dhan.globallywebsolutions.ca")
@RestApi(baseUrl: "https://coinswitchpay.com")
abstract class ApiNetwork {
  factory ApiNetwork(Dio dio, {String baseUrl}) = _ApiNetwork;

  @POST("/api/v1/user/register")
  Future<RegisterResModel> register(@Body() RegisterBodyModel body);

  @POST("/api/v1/user/registerVerify")
  Future<RegisterVerifyResModel> registerVerify(
    @Body() RegisterVerifyBodyModel body,
  );

  @POST("/api/v1/user/login")
  Future<LoginResModel> login(@Body() LoginBodyModel body);

  @POST("/api/v1/user/verifyUser")
  Future<LoginVerifyResModel> loginVerify(@Body() LoginVerifyBodyModel body);

  @POST("/api/v1/user/forgotPassword")
  Future<ForgotSendOtpResModel> forgotSendOTP(
    @Body() ForgotSendOtpBodyModel body,
  );

  @POST("/api/v1/user/forgotPasswordVerify")
  Future<ForgotPassResModel> forgotPassword(@Body() ForgotPassBodyModel body);

  @GET("/api/v1/user/getAllBanner?type=top")
  Future<GetBannersModel> getBannersTop();

  @GET("/api/v1/user/getAllBanner?type=bottom")
  Future<GetBannersModel> getBannersBottom();

  @GET("/api/v1/user/getFoundTransferOptions")
  Future<GetFoundTransferModel> getFoundTransfer();

  @POST("/api/v1/user/createUsdtDeposit")
  Future<DepositeUsdtResModel> createUSDTDeposite(
    @Body() DepositeUsdtBodyModel body,
  );

  @POST("/api/v1/user/submitUsdtDepositProof")
  Future<SubmitUsdtDepositeResModel> submiteUSDTDeposite(
    @Body() SubmitUsdtDepositeBodyModel body,
  );

  @POST("/api/v1/user/cancelUsdtDeposit")
  Future<CancelUsdtDepositResModel> cancelUSDTDeposite(
    @Body() CancelUsdtDepositBodyModel body,
  );

  @GET("/api/v1/user/getBuyInrDepositList?sortOrder=asc")
  Future<DepositeInrListModel> depositeINRList();

  @GET("/api/v1/user/getBuyInrDeposit")
  Future<GetBuyInrDepositeModel> getBuyInrDeposite();

  @POST("/api/v1/user/processBuyInrDeposit")
  Future<ProcessBuyInrDepositResModel> processBuyINRDeposite(
    @Body() ProcessBuyInrDepositBodyModel body,
  );

  @POST("/api/v1/user/cancelBuyInrDeposit")
  Future<CancelInrDepositeResModel> cancelINRDeposite(
    @Body() CanceInrDepositeBodyModel body,
  );

  @POST("/api/v1/user/submitInrDepositProof")
  Future<SubmitInrDepositeResModel> submiteINRDeposite(
    @Body() SubmitInrDepositeBodyModel body,
  );

  @GET("/api/v1/user/getP2PBuyOrSellList?page=1&limit=100000&txType=BUY")
  Future<BuyP2PListResModel> buyP2pList();

  // @GET("/api/v1/user/getOrCreateP2PTransaction?id=69afd2e859651ce04351cf46&type=BUY")
  // Future<GetOrCreateP2PTransactionDetailsModel> getOrCreateP2pTransationDetails(
  //   @Query('id') String id,
  // );
  @GET("/api/v1/user/getOrCreateP2PTransaction")
  Future<GetOrCreateP2PTransactionDetailsModel> getOrCreateP2pTransationDetails(
    @Query('id') String id,
    @Query('type') String type,
  );

  @POST("/api/v1/user/cancelP2PTransaction")
  Future<CancelP2PTransationResModel> cancelP2pTransation(
    @Body() CancelP2pTransactionBodyModel body,
  );

  @POST("/api/v1/user/saveBuyRequest")
  Future<P2PPaidResModel> p2pPaid(@Body() P2PPaidBodyModel body);

  @GET("/api/v1/user/getP2PBuyOrSellList?page=1&limit=10000&txType=SELL")
  Future<BuyP2PListResModel> sellP2pList();

  @GET("/api/v1/user/getP2PBuyOrSellById")
  Future<SellP2PDetailsModel> sellP2pDetails(@Query('id') String id);

  // @POST("/api/v1/user/saveSellRequest")
  // Future<SaveSellRequestResModel> p2pSaveSell(
  //   @Body() SaveSellRequestBodyModel body,
  // );

  // @POST("/api/v1/user/saveSellRequest")
  // Future<SaveSellRequestResModel> p2pSaveSellINR(
  //   @Body() SaveSellInrRequestBodyModel body,
  // );

  @POST("/api/v1/user/saveSellRequest")
  Future<SaveRequestResModel> p2pSaveSell(@Body() saveRequest body);

  @POST("/api/v1/user/raiseDispute")
  Future<RaiseDsiputeResModel> raiseDispute(@Body() RaiseDsiputeBodyModel body);

  @GET("/api/v1/user/getUpi")
  Future<SellUpiModel> sellUpi();

  @GET("/api/v1/user/getWallet")
  Future<GetWalletModel> getWallet();

  @GET("/api/v1/user/getTodayCommission")
  Future<GetWalletCommissionModel> getWalletCommission();

  @POST("/api/v1/user/forgotPin")
  Future<SendOtPforgotInRes> forgotPinSendOTP();

  @POST("/api/v1/user/forgotPinVerify")
  Future<ForgotPinVerifyRes> forgotPinVerify(@Body() ForgotPinVerifyBody body);

  @GET("/api/v1/user/getTransactionList?")
  Future<GetDepositTransactionListModel> getTransactions({
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("txType") String? txType,
    @Query("walletType") String? walletType,
  });

  @POST("/api/v1/user/releaseAmountRejectOrApprove")
  Future<ConfirmSellResModel> releaseAmountRejectOrApprove(
    @Body() ReleaseAmountRejectOrApproveBody body,
  );

  @GET(
    "/api/v1/user/getTransactionList?page=1&limit=100000&txType=deposit&walletType=USDT",
  )
  Future<UsdtDepositeHisotryModel> usdtDepositeHostory();

  @GET(
    "/api/v1/user/getTransactionList?page=1&limit=100000&txType=deposit&walletType=INR",
  )
  Future<IntToTokenBuyHistoryModel> inrToTokenBuyHistory();

  @GET("/api/v1/user/getUserSellList?page=1&limit=100000&walletType=TOKEN")
  Future<TokenToInrSellHistoryModel> tokenToInrSellingHistory();

  @GET("/api/v1/user/getUserSellList?page=1&limit=100000&walletType=USDT")
  Future<UsdtToInrSellHistoryModel> usdtToInrSellHistory();

  // @POST("/api/v1/user/saveSellInWallet")
  // Future<ConfirmSellResModel> confirmSellWallet(
  //   @Body() ConfirmSellBodyModel body,
  // );
  @POST("/api/v1/user/saveSellInWallet")
  Future<ConfirmSellResModel> confirmSellWallet(
    @Body() Map<String, dynamic> body,
  );

  @GET("/api/v1/user/getReferralChainList?search=&page=1&limit=10000")
  Future<GetRefralchainlistModel> getRefralList();

  @GET("/api/v1/user/getP2PTransactions?page=1&limit=100000&type=buy")
  Future<GetP2PTrasationBuyModel> getP2PBuyTransactions();

  // Type 'sell' hai to function name bhi Sell hona chahiye
  @GET("/api/v1/user/getP2PTransactions?page=1&limit=100000&type=sell")
  Future<GetP2PTrasationSellModel> getP2PSellTransactions();

  // @GET("/api/v1/user/getP2PExist?type=BUY")
  // Future<GetP2PExitBuyModel> getP2pExitBuy();

  @GET("/api/v1/user/getP2PExist")
  Future<GetP2PExitBuyModel> getP2pExit(@Query("type") String type);

  ///////////////////////////////////////////////////////////////////////////////////

  @GET("/api/v1/user/getProfile")
  Future<ProfileResModel> fetchProfile();

  @GET("/api/v1/user/getAgentships")
  Future<AgentshipModel> fetchAgentship();

  @POST("/api/v1/user/applyAgentship")
  Future<ApplyAgentshipResModel> applyAgentship(
    @Body() ApplyAgentshipBodyModel body,
  );

  @GET("/api/v1/user/getAllQrCodes?isUpi=false")
  Future<GetAllQrCodeTokenModel> getAllQrCodeToken();

  @GET("/api/v1/user/getAllQrCodes?isUpi=true")
  Future<GetAllQrCodeInrResModel> getAllQrCodeINR();

  @POST("/api/v1/user/changePin")
  Future<SetPinInrResModel> chanegePin(@Body() ChangePinBodyModel body);

  @POST("/api/v1/user/setPinToToken")
  Future<SetPinInrResModel> setPinToToken(@Body() ChangePinBodyModel body);

  @POST("/api/v1/user/createDeposit")
  Future<CreateDepositeResModel> createDeposite(
    @Body() CreateDepositeBodyModel body,
  );

  @POST("/api/v1/user/createWithdraw")
  Future<HttpResponse<dynamic>> createWithdraw(
    @Body() CreateWithBodyModel body,
  );

  @POST("/api/v1/user/createUpi")
  Future<CreateUpiResModel> createUpi(@Body() CreateUpiBodyModel body);

  @GET("/api/v1/user/getAllUpi")
  Future<GetUpiModel> getAllUpi();

  @POST("/api/v1/user/deleteUpi")
  Future<UpiDeleteResModel> deleteUpi(@Body() UpiDeleteBodyModel body);

  @POST("/api/v1/user/updateUpiStatus")
  Future<UpdateUpiStatusResModel> updateUpiStatus(
    @Body() UpdateUpiStatusBodyModel body,
  );
  @POST("/api/v1/user/createBank")
  Future<AddBankResModel> addBank(@Body() AddBankBodyModel body);

  @GET("/api/v1/user/getBank")
  Future<GetBankResModel> sellBankList();

  @GET("/api/v1/user/getAllBank")
  Future<GetBankResModel> getAllBankList(); //////////

  @POST("/api/v1/user/deleteBank")
  Future<DeleteBankResModel> deleteBank(@Body() DeleteBankBodyModel body);

  @POST("/api/v1/user/updateBankStatus")
  Future<UpdateBankStatuResModel> updateBankStatus(
    @Body() UpdateBankStatusBodyModel body,
  );

  @MultiPart()
  @POST("/api/v1/uploadImage")
  Future<UploadImageResModel> uploadImage(@Part(name: "file") File file);

  @POST("/api/v1/user/createOrUpdateKyc")
  Future<CreateOrUpdateKycResModel> createOrUpdateKyc(
    @Body() CreateOrUpdateKycBodyModel body,
  );

  @POST("/api/v1/user/createWithdraw")
  Future<WithdawResModel> withdrawForToken(@Body() WithdawBodyModel body);

  @POST("/api/v1/user/updateProfile")
  Future<UpdateProfileResModel> updateProfle(
    @Body() UpdateProfileBodyModel body,
  );

  @MultiPart()
  @POST("/api/v1/user/updateImage")
  Future<UpdateImageResModel> updateImage(@Field("image") String imageUrl);

  @GET("/api/v1/user/getKyc")
  Future<GetKycModel> getKyc();

  @GET("/api/v1/user/getPendingSellOrders")
  Future<GetPendingSellOrdersModel> getPendingSellOrpders();

  @POST("/api/v1/user/createSellOrder")
  Future<CreateSellOrderResModel> createSellOrder(
    @Body() CreateSellOrderBodyModel body,
  );

  @POST("/api/v1/user/requestBuyOrder")
  Future<RequestBuyOrderResModel> requestBuyOrder(
    @Body() RequestBuyOrderBodyModel body,
  );

  // // ✅ Pagination ke liye updated GET method
  // @GET("/api/v1/user/getRequestSellOrders")
  // Future<GetRequestSellOrdersModel> getPendingSellOrders(
  //   @Query("page") int page,
  //   @Query("limit") int limit,
  // );

  @GET("/api/v1/user/getRequestSellOrders")
  Future<GetRequestSellOrdersModel> getRequestSellOrders();

  @GET("/api/v1/user/getP2PTransactions")
  Future<GetP2PTransactionModel> getP2PTransactions(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("type") String type,
  );

  @GET("/api/v1/user/getNotificationList?pageNo=1&size=100000&keyWord=")
  Future<NotificatonListModel> notificationList();

  @POST("/api/v1/user/readNotification")
  Future<ReadNotificationModel> readNotification();

  @GET("/api/v1/user/getDepositById")
  Future<GetDepositeDetaislModel> getDepositById(@Query("id") String id);

  @GET("/api/v1/user/getSellById")
  Future<GetSellByIdDetailsModel> getSellById(@Query("id") String id);

  @GET("/api/v1/user/getP2PById")
  Future<GetP2PByIdModel> getP2pByID(@Query("id") String id);

  @GET("/api/v1/user/getSellById")
  Future<SellTokenDetailsHistoryModel> sellTokenDetailsHistoryModel(
    @Query("id") String id,
  );

  @GET("/api/v1/user/getUserAllTicketList")
  Future<GetUserAllTicketListModel> getUserAllTicketList();

  @GET("/api/v1/user/getTickeById")
  Future<GetTicketByIdModel> getTicketById(@Query("ticketId") String ticketId);

  @POST("/api/v1/user/createSupportTicket")
  Future<CreateSupportTicketResModel> createSupport(
    @Body() CreateSupportTicketBodyModel body,
  );
}
