import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_app/Screen/liveSupportChatScreen.dart';
import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/GetAllUserTicketController.dart';
import 'package:payment_app/data/model/createSupportBodyModel.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatBotPage extends ConsumerStatefulWidget {
  const ChatBotPage({super.key});

  @override
  ConsumerState<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ConsumerState<ChatBotPage> {
  final ScrollController scrollController = ScrollController();
  static const Color bgColor = Color(0xFF09111C);
  static const Color botBubble = Color(0xFF1F2A44);
  static const Color userBubble = Color(0xFF3B82F6);
  static const Color buttonBg = Color(0xFF1F2A44);
  static const Color buttonBorder = Color(0xFF334155);

  List<Map<String, dynamic>> history = [
    {"step": "home", "type": "bot"},
  ];

  List<String> issuePath = [];
  bool isTyping = false;
  late IO.Socket socket;

  // ====================== FULL FLOW ======================
  final Map<String, dynamic> flow = {
    // MAIN MENU
    "home": {
      "message":
          "👋 Welcome to *Coinswitchpay*\nIndia's leading USDT to INR exchange platform 🇮🇳\n\nPlease choose an option below so we can assist you 👇",
      "buttons": [
        {"text": "📥 Deposit Issue", "next": "deposit"},
        {"text": "📤 Sell / Withdraw Issue", "next": "sell_withdraw"},
        {"text": "🤝 P2P Order Help", "next": "p2p_menu"},
        {"text": "💰 Wallet & Balance Issue", "next": "wallet_menu"},
        {"text": "📱 Payment Issue", "next": "payment_menu"},
        {"text": "🎁 Referral / Commission Issue", "next": "referral_menu"},
      ],
    },

    // ====================== DEPOSIT ======================
    "deposit": {
      "message": "Please select your deposit type 👇",
      "buttons": [
        {"text": "INR Deposit Issue", "next": "inr_menu"},
        {"text": "USDT Deposit Issue", "next": "usdt_menu"},
        {"text": "⬅️ Back", "next": "home"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "inr_menu": {
      "message": "Please select your INR deposit issue 👇",
      "buttons": [
        {"text": "Deposit Pending", "next": "inr_pending"},
        {"text": "Wrong Amount / Wrong Details", "next": "inr_wrong"},
        {"text": "⬅️ Back", "next": "deposit"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "inr_pending": {
      "message":
          "Once your INR order is confirmed, wallet credit may take up to *30 minutes*.\nPlease wait for the expected time.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "inr_pending_options"},
        {"text": "⬅️ Back", "next": "inr_menu"},
      ],
    },
    "inr_pending_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "inr_pending"},
      ],
    },
    "inr_wrong": {
      "message":
          "If the deposited INR amount or payment details are incorrect, manual verification may be required.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "inr_wrong_options"},
        {"text": "⬅️ Back", "next": "inr_menu"},
      ],
    },
    "inr_wrong_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "inr_wrong"},
      ],
    },

    "usdt_menu": {
      "message": "Please select your USDT deposit issue 👇",
      "buttons": [
        {"text": "Deposit Pending", "next": "usdt_pending"},
        {"text": "Wrong Amount / Wrong Details", "next": "usdt_wrong"},
        {"text": "⬅️ Back", "next": "deposit"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "usdt_pending": {
      "message":
          "USDT deposits depend on blockchain confirmation.\nIf you entered the correct amount, TXID, and uploaded the screenshot, confirmation usually takes *1–10 minutes*.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "usdt_pending_options"},
        {"text": "⬅️ Back", "next": "usdt_menu"},
      ],
    },
    "usdt_pending_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "usdt_pending"},
      ],
    },
    "usdt_wrong": {
      "message":
          "If the USDT amount, TXID, or blockchain network is incorrect, your deposit may be delayed until verification is completed.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "usdt_wrong_options"},
        {"text": "⬅️ Back", "next": "usdt_menu"},
      ],
    },
    "usdt_wrong_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "usdt_wrong"},
      ],
    },

    // ====================== SELL / WITHDRAW ======================
    "sell_withdraw": {
      "message": "Please select what you want to sell 👇",
      "buttons": [
        {"text": "💵 Sell USDT", "next": "sell_usdt_menu"},
        {"text": "🪙 Sell Tokens", "next": "sell_token_menu"},
        {"text": "⬅️ Back", "next": "home"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },

    // Sell USDT
    "sell_usdt_menu": {
      "message": "Please select your USDT sell issue 👇",
      "buttons": [
        {"text": "Payment Pending", "next": "sell_usdt_pending"},
        {"text": "Wrong Amount / Wrong Details", "next": "sell_usdt_wrong"},
        {
          "text": "Order Completed but Payment Not Received",
          "next": "sell_usdt_completed",
        },
        {"text": "⬅️ Back", "next": "sell_withdraw"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "sell_usdt_pending": {
      "message":
          "USDT sell payment timelines depend on the selected payment method.\n• *UPI* payments may take up to *1 hour*\n• *IMPS / CDM / RTGS* payments usually take *30–60 minutes*.\n\nPlease wait for the expected settlement time.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "sell_usdt_pending_options"},
        {"text": "⬅️ Back", "next": "sell_usdt_menu"},
      ],
    },
    "sell_usdt_pending_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "sell_usdt_pending"},
      ],
    },
    "sell_usdt_wrong": {
      "message":
          "If incorrect amount or payment details were provided for the USDT sell order, the payment may be delayed until verification is completed.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "sell_usdt_wrong_options"},
        {"text": "⬅️ Back", "next": "sell_usdt_menu"},
      ],
    },
    "sell_usdt_wrong_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "sell_usdt_wrong"},
      ],
    },
    "sell_usdt_completed": {
      "message":
          "If your USDT sell order is marked completed but payment is not received, please allow time for bank settlement.\nManual verification may be required if the delay continues.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "sell_usdt_completed_options"},
        {"text": "⬅️ Back", "next": "sell_usdt_menu"},
      ],
    },
    "sell_usdt_completed_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "sell_usdt_completed"},
      ],
    },

    // Sell Tokens
    "sell_token_menu": {
      "message": "Please select your token sell issue 👇",
      "buttons": [
        {"text": "Payment Pending", "next": "sell_token_pending"},
        {"text": "Wrong Amount / Wrong Details", "next": "sell_token_wrong"},
        {
          "text": "Order Completed but Payment Not Received",
          "next": "sell_token_completed",
        },
        {"text": "⬅️ Back", "next": "sell_withdraw"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "sell_token_pending": {
      "message":
          "Token sell orders are processed at a fixed rate.\nOnce the order is confirmed, payment is initiated within the standard settlement time.\nPlease wait for completion.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "sell_token_pending_options"},
        {"text": "⬅️ Back", "next": "sell_token_menu"},
      ],
    },
    "sell_token_pending_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "sell_token_pending"},
      ],
    },
    "sell_token_wrong": {
      "message":
          "If incorrect amount or payment details were provided for the token sell order, verification may be required before processing.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "sell_token_wrong_options"},
        {"text": "⬅️ Back", "next": "sell_token_menu"},
      ],
    },
    "sell_token_wrong_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "sell_token_wrong"},
      ],
    },
    "sell_token_completed": {
      "message":
          "If your token sell order is completed but payment is not received, please allow settlement time to complete.\nManual verification may be required if delay persists.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "sell_token_completed_options"},
        {"text": "⬅️ Back", "next": "sell_token_menu"},
      ],
    },
    "sell_token_completed_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "sell_token_completed"},
      ],
    },

    // ====================== P2P ======================
    "p2p_menu": {
      "message": "Please select your P2P issue 👇",
      "buttons": [
        {"text": "P2P Order Buy Issue", "next": "p2p_buy"},
        {"text": "P2P Order Sell Issue", "next": "p2p_sell"},
        {"text": "⬅️ Back", "next": "home"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "p2p_buy": {
      "message": "Please select your issue 👇",
      "buttons": [
        {
          "text": "Payment Done but USDT Not Received",
          "next": "p2p_buy_release",
        },
        {"text": "Order Cancelled", "next": "p2p_cancel"},
        {"text": "Payment Pending", "next": "p2p_pending"},
        {"text": "⬅️ Back", "next": "p2p_menu"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "p2p_buy_release": {
      "message":
          "If you have completed the payment and marked it as paid, please wait for the seller to confirm and release USDT.\nIn most cases, release happens shortly.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "p2p_buy_release_options"},
        {"text": "⬅️ Back", "next": "p2p_buy"},
      ],
    },
    "p2p_buy_release_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "p2p_buy_release"},
      ],
    },
    "p2p_cancel": {
      "message":
          "If the P2P buy order was cancelled, any paid amount will be refunded as per the order status.\nPlease check your order history.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "p2p_cancel_options"},
        {"text": "⬅️ Back", "next": "p2p_buy"},
      ],
    },
    "p2p_cancel_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "p2p_cancel"},
      ],
    },
    "p2p_pending": {
      "message":
          "If payment is still pending, please complete the payment within the given time to avoid order cancellation.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "p2p_pending_options"},
        {"text": "⬅️ Back", "next": "p2p_buy"},
      ],
    },
    "p2p_pending_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "p2p_pending"},
      ],
    },

    // P2P Sell (similarly added)
    "p2p_sell": {
      "message": "Please select your issue 👇",
      "buttons": [
        {
          "text": "Buyer Marked Paid but Payment Not Received",
          "next": "p2p_sell_verify",
        },
        {"text": "Order Cancelled", "next": "p2p_sell_cancel"},
        {"text": "Payment Pending", "next": "p2p_sell_pending"},
        {"text": "⬅️ Back", "next": "p2p_menu"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "p2p_sell_verify": {
      "message":
          "If the buyer has marked the order as paid but you have not received the payment, please *do not release USDT*.\nOur team will verify the transaction.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "p2p_sell_verify_options"},
        {"text": "⬅️ Back", "next": "p2p_sell"},
      ],
    },
    "p2p_sell_verify_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "p2p_sell_verify"},
      ],
    },
    "p2p_sell_cancel": {
      "message":
          "If the P2P sell order was cancelled, USDT will be returned to your wallet automatically.\nPlease check your wallet balance.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "p2p_sell_cancel_options"},
        {"text": "⬅️ Back", "next": "p2p_sell"},
      ],
    },
    "p2p_sell_cancel_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "p2p_sell_cancel"},
      ],
    },
    "p2p_sell_pending": {
      "message":
          "If payment is pending, please wait for the buyer to complete the payment within the allowed time.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "p2p_sell_pending_options"},
        {"text": "⬅️ Back", "next": "p2p_sell"},
      ],
    },
    "p2p_sell_pending_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "p2p_sell_pending"},
      ],
    },

    // ====================== WALLET ======================
    "wallet_menu": {
      "message": "Please select your balance type 👇",
      "buttons": [
        {"text": "USDT Balance Issue", "next": "wallet_usdt"},
        {"text": "Token Balance Issue", "next": "wallet_token_menu"},
        {"text": "⬅️ Back", "next": "home"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "wallet_usdt": {
      "message": "Please select your USDT balance issue 👇",
      "buttons": [
        {"text": "Balance Not Updated", "next": "wallet_usdt_update"},
        {"text": "Balance Deducted Incorrectly", "next": "wallet_usdt_deduct"},
        {"text": "⬅️ Back", "next": "wallet_menu"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "wallet_usdt_update": {
      "message":
          "USDT balance updates after successful deposit, sell, or P2P release.\nPlease allow some time for settlement or blockchain confirmation.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "wallet_usdt_update_options"},
        {"text": "⬅️ Back", "next": "wallet_usdt"},
      ],
    },
    "wallet_usdt_update_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "wallet_usdt_update"},
      ],
    },
    "wallet_usdt_deduct": {
      "message":
          "If your USDT balance was deducted incorrectly, our team will review the transaction details carefully.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "wallet_usdt_deduct_options"},
        {"text": "⬅️ Back", "next": "wallet_usdt"},
      ],
    },
    "wallet_usdt_deduct_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "wallet_usdt_deduct"},
      ],
    },

    // Token Balance
    "wallet_token_menu": {
      "message": "Please select your token balance issue 👇",
      "buttons": [
        {"text": "Balance Not Updated", "next": "wallet_token_update"},
        {"text": "Balance Deducted Incorrectly", "next": "wallet_token_deduct"},
        {"text": "⬅️ Back", "next": "wallet_menu"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "wallet_token_update": {
      "message":
          "Token balance updates after successful buy, sell, or conversion.\nIn some cases, system sync or settlement may take a few minutes.\nPlease wait for the confirmation.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "wallet_token_update_options"},
        {"text": "⬅️ Back", "next": "wallet_token_menu"},
      ],
    },
    "wallet_token_update_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "wallet_token_update"},
      ],
    },
    "wallet_token_deduct": {
      "message":
          "If your token balance was deducted incorrectly, it may be due to a failed order, cancelled transaction, or system adjustment.\nOur team will review the transaction details.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "wallet_token_deduct_options"},
        {"text": "⬅️ Back", "next": "wallet_token_menu"},
      ],
    },
    "wallet_token_deduct_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "wallet_token_deduct"},
      ],
    },

    // ====================== PAYMENT ======================
    "payment_menu": {
      "message": "Please select your query 👇",
      "buttons": [
        {"text": "1️⃣ UPI payment timing", "next": "upi"},
        {"text": "2️⃣ IMPS payment timing", "next": "imps"},
        {"text": "3️⃣ CDM payment timing", "next": "cdm"},
        {"text": "4️⃣ RTGS payment timing", "next": "rtgs"},
        {"text": "5️⃣ Fastest payment method", "next": "fastest"},
        {"text": "6️⃣ Safest payment method", "next": "safest"},
        {"text": "⬅️ Back", "next": "home"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "upi": {
      "message":
          "UPI payments may be processed as split transactions.\nThe order will be marked completed within *1–2 hours* maximum.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "payment_options"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },
    "imps": {
      "message":
          "IMPS payments are completed within *45–60 minutes* as a single transaction.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "payment_options"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },
    "cdm": {
      "message":
          "CDM payments are completed within *1–2 hours.\nYou may receive the payment in 1 or 2 transactions only.\nPayment is credited via **Cash Deposit Machine (CDM)* or Bank Deposit.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "payment_options"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },
    "rtgs": {
      "message":
          "RTGS payments are available *24×7.\nRTGS payments are usually completed within **30–60 minutes* as a single transaction.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "payment_options"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },
    "fastest": {
      "message":
          "*RTGS* is the fastest payment method.\nRTGS payments are completed within 30–60 minutes, available 24×7, as a single transaction.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "payment_options"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },
    "safest": {
      "message":
          "For safety and reduced bank account risk, *IMPS, CDM, and RTGS* are considered the safest payment methods.\nUPI payments may involve split transactions, which can sometimes trigger bank monitoring.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "payment_options"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },
    "payment_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "payment_menu"},
      ],
    },

    // ====================== REFERRAL ======================
    "referral_menu": {
      "message": "Please select your issue 👇",
      "buttons": [
        {"text": "Referral Commission Not Credited", "next": "referral1"},
        {"text": "Referral Earnings Not Updated", "next": "referral2"},
        {"text": "Team Commission Issue", "next": "referral3"},
        {"text": "Commission Calculation Query", "next": "referral4"},
        {"text": "⬅️ Back", "next": "home"},
        {"text": "🏠 Main Menu", "next": "home"},
      ],
    },
    "referral1": {
      "message":
          "Referral commission is credited after the referred User completes a valid transaction as per the referral policy.\nIn some cases, commission credit may take some time.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "referral_options"},
        {"text": "⬅️ Back", "next": "referral_menu"},
      ],
    },
    "referral2": {
      "message":
          "Referral earnings are updated after system synchronization and successful transaction confirmation.\nPlease allow some time for the update.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "referral_options"},
        {"text": "⬅️ Back", "next": "referral_menu"},
      ],
    },
    "referral3": {
      "message":
          "Team commission depends on your referral structure and completed transactions within your team.\nCommission updates may take some time to reflect.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "referral_options"},
        {"text": "⬅️ Back", "next": "referral_menu"},
      ],
    },
    "referral4": {
      "message":
          "Commission is calculated based on the applicable rate and successful transactions.\nPlease review your commission details in the app.\n\nWas your issue resolved?",
      "buttons": [
        {"text": "✅ Yes, resolved", "next": "thanks"},
        {"text": "❌ No, still pending", "next": "referral_options"},
        {"text": "⬅️ Back", "next": "referral_menu"},
      ],
    },
    "referral_options": {
      "message": "Please choose an option 👇",
      "buttons": [
        {"text": "🎧 Contact Support Agent", "next": "agent"},
        {"text": "⬅️ Back", "next": "referral_menu"},
      ],
    },

    // ====================== COMMON ======================
    "agent": {
      "message":
          "✅ *Request Received!*\n\nClick below to chat with our support agent on WhatsApp.",
      "buttons": [
        // {
        //   "text": "💬 Chat on WhatsApp",
        //   "type": "link",
        //   "url": "https://wa.me/919876543210",
        // },
        {"text": "🏠 Back to Home", "next": "home"},
      ],
    },

    "thanks": {
      "message":
          "Thank you for using *Coinswitchpay* 🙏\n\nYour feedback helps us improve!",
      "isRatingStep": true,
      "next": "rating_done",
    },

    "rating_done": {
      "message": "🙏 Thank you for your feedback!",
      "buttons": [
        {"text": "🔄 Start New Chat", "next": "home"},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  // 1. Socket Initialization
  void initSocket() {
    try {
      // Replace with your actual backend URL
      socket = IO.io(
        'https://coinswitchpay.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build(),
      );

      socket.onConnect((_) => log('Socket: Connection established ✅'));
      socket.onConnectError((data) => log('Socket: Connect Error ❌ $data'));
      socket.onDisconnect((_) => log('Socket: Disconnected ⚠️'));
    } catch (e) {
      log("Socket Init Exception: $e");
    }
  }

  // 2. Handle Button Actions
  void handleAction(Map<String, dynamic> btn) async {
    // A. Contact Agent Case
    if (btn["next"] == "agent") {
      await createTicket([...issuePath]); // Path ki copy bhejein
      setState(() {
        history.add({"step": "agent", "type": "bot"});
      });
      scrollToBottom();
      return;
    }

    // B. Link / WhatsApp Case
    if (btn["type"] == "link") {
      final url = btn["url"];
      if (url != null) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
      return;
    }

    // C. Navigation & Path Logic
    setState(() {
      String btnText = btn["text"] ?? "";

      if (btn["next"] == "home") {
        issuePath.clear();
      } else if (btnText.contains("Back") || btnText.contains("⬅️")) {
        if (issuePath.isNotEmpty) {
          issuePath.removeLast();
        }
      } else {
        // Sirf tabhi path mein add karein jab wo back ya home na ho
        issuePath.add(btnText);
      }

      history.add({"text": btnText, "type": "user"});
      isTyping = true;
    });

    scrollToBottom();

    // Bot Response Delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        isTyping = false;
        history.add({"step": btn["next"], "type": "bot"});
      });
      scrollToBottom();
    }
  }

  // 3. Create Ticket & Join Socket Room
  Future<void> createTicket(List<String> reason) async {
    String formattedMessage = reason.join(" > ");

    try {
      final body = CreateSupportTicketBodyModel(
        message: formattedMessage,
        reasonPath: reason,
      );

      final service = ApiNetwork(createDio());
      final response = await service.createSupport(body);

      if (response.code == 0 &&
          response.error == false &&
          response.data != null) {
        final String newTicketId = response.data!.id.toString();

        // Check Socket Connection before emitting
        if (socket.connected) {
          log("Socket: Joining Room for Ticket ID: $newTicketId");

          socket.emitWithAck(
            'joinSupportRoom',
            {'ticketId': newTicketId},
            ack: (data) {
              log("Socket: Joined room confirmed by server: $data");
            },
          );
        } else {
          log("Socket: Not connected, attempting to connect...");
          socket.connect();
        }

        if (mounted) {
          Navigator.push(
            context,
            RightSlideFadeRoute(page: LiveSupportChatScreen(id: newTicketId)),
          );
        }
      } else {
        if (mounted) {
          ShowMessage.error(
            context,
            response.message ?? "Ticket creation failed",
          );
        }
      }
    } catch (e, s) {
      log("CreateTicket Error: $e");
      log("Stacktrace: $s");
    }
  }

  @override
  void dispose() {
    socket.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // ====================== FUNCTIONS ======================
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget typingDots() {
    return Row(
      children: [
        SizedBox(
          width: 6,
          height: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 6),
        SizedBox(
          width: 6,
          height: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 6),
        SizedBox(
          width: 6,
          height: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget ratingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (i) => IconButton(
          icon: const Icon(Icons.star_border, color: Colors.amber, size: 35),
          onPressed:
              () => handleAction({
                "text": "${i + 1} Stars",
                "next": "rating_done",
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(getAllUserTicketController);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: bgColor),
      body: asyncState.when(
        data: (data) {
          final hasData = (data.data?.isNotEmpty ?? false);
          final tickets = data.data ?? [];
          return Column(
            children: [
              /// 🔹 HEADER
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),

                    SizedBox(width: 10.w),

                    /// Avatar
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 22.r,
                          backgroundColor: const Color(0xFF1E3A8A),
                          child: Center(
                            child: Icon(
                              Icons.headset_mic_outlined,
                              color: const Color(0xFF06CE8F),
                              size: 22.sp,
                            ),
                          ),
                        ),

                        /// Online Dot
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 10.w,
                            width: 10.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D09C),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 10.w),

                    /// Name + Status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Support",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Online",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF00D09C),
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    /// Chat Button
                    if (hasData)
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            // Full width ke liye insetPadding zero karna zaroori hai
                            builder: (BuildContext context) {
                              return Dialog(
                                insetPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 24.h,
                                ), // Screen se thodi doori ke liye
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: const Color(
                                  0xFF161B22,
                                ), // Deep Dark
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  // Isse dialog full width ho jayega
                                  width: MediaQuery.of(context).size.width,
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                        0.7,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Header
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Header title sirf tab dikhega jab tickets honge
                                          tickets.isNotEmpty
                                              ? Text(
                                                "Your Tickets",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                              : const SizedBox.shrink(),

                                          IconButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),

                                      // List of Tickets
                                      if (tickets.isNotEmpty)
                                        Expanded(
                                          child: ListView.separated(
                                            padding: EdgeInsets.only(
                                              bottom: 10.h,
                                            ),
                                            itemCount: tickets.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    SizedBox(height: 12.h),
                                            itemBuilder: (context, index) {
                                              final ticket = tickets[index];

                                              // Image jaisa full path with arrow
                                              final String title =
                                                  ticket.reasonPath != null &&
                                                          ticket
                                                              .reasonPath!
                                                              .isNotEmpty
                                                      ? ticket.reasonPath!.join(
                                                        " → ",
                                                      )
                                                      : "Support Issue";

                                              final String status =
                                                  ticket.status ?? "open";

                                              return InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    RightSlideFadeRoute(
                                                      page:
                                                          LiveSupportChatScreen(
                                                            id:
                                                                ticket.id
                                                                    .toString(),
                                                          ),
                                                    ),
                                                  ).then((value) {
                                                    return ref.invalidate(
                                                      getAllUserTicketController,
                                                    );
                                                  });
                                                },
                                                child: TicketCard(
                                                  title: title,
                                                  status: status,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      else
                                        // Empty state agar tickets nahi hain
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 20.h,
                                          ),
                                          child: Text(
                                            "No tickets found",
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "Chat History",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: history.length + (isTyping ? 1 : 0),

                  itemBuilder: (context, index) {
                    if (isTyping && index == history.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.only(bottom: 10, right: 100.w),
                          decoration: BoxDecoration(
                            color: botBubble, // ← Better for typing
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: typingDots(),
                        ),
                      );
                    }

                    final item = history[index];

                    // ==================== USER MESSAGE (Right Side) ====================
                    if (item["type"] == "user") {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 10,
                            left: 60,
                          ), // Thoda left margin for better look
                          decoration: BoxDecoration(
                            color: userBubble, // ← Blue color (Image jaisa)
                            borderRadius: BorderRadius.circular(
                              18,
                            ), // Thoda zyada round for modern look
                          ),
                          child: Text(
                            item["text"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }

                    // ==================== BOT MESSAGE (Left Side) ====================
                    final step = flow[item["step"]];
                    if (step == null) return const SizedBox.shrink();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 8,
                              right: 60,
                            ), // Right margin for better look
                            decoration: BoxDecoration(
                              color: botBubble,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              step["message"] ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),

                        if (index == history.length - 1 && !isTyping)
                          Column(
                            children: [
                              if (step["buttons"] != null)
                                ...step["buttons"].map<Widget>((btn) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 8,
                                      right: 60.w,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          backgroundColor: buttonBg,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          textStyle: const TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => handleAction(btn),
                                        child: Text(btn["text"] ?? ""),
                                      ),
                                    ),
                                  );
                                }).toList(),

                              if (step["isRatingStep"] == true) ratingStars(),
                            ],
                          ),

                        const SizedBox(height: 6),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          return Center(
            child: Text(
              error.toString(),
              style: TextStyle(color: Colors.white),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// --- Fixed Ticket Card Widget ---
class TicketCard extends StatelessWidget {
  final String title;
  final String status;

  const TicketCard({Key? key, required this.title, required this.status})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getStatusBgColor(String status) {
      switch (status.toLowerCase()) {
        case "open":
          return Colors.green.shade100;
        case "resolved":
          return Colors.indigo.shade100;
        default:
          return Colors.red.shade100;
      }
    }

    Color getStatusTextColor(String status) {
      switch (status.toLowerCase()) {
        case "open":
          return Colors.green.shade700;
        case "resolved":
          return Colors.indigo.shade700;
        default:
          return Colors.red.shade700;
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Icon(
              //   Icons.account_balance_wallet_outlined,
              //   color: Colors.lightBlue,
              //   size: 20,
              // ),
              // const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: title,
                      ), // ← Sirf yeh title aa raha hai (already full path)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: getStatusBgColor(status),
            ),
            child: Text(
              "Status: $status",
              style: TextStyle(
                color: getStatusTextColor(status),
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
