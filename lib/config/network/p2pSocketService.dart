import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class P2pSocketService {
  static final P2pSocketService _instance = P2pSocketService._internal();

  factory P2pSocketService() => _instance;

  P2pSocketService._internal();

  late IO.Socket socket;

  bool isConnected = false;

  void connect() {
    if (isConnected) return;

    socket = IO.io(
      "https://coinswitchpay.com",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      isConnected = true;
      log("✅ P2P Socket Connected: ${socket.id}");
    });

    socket.onDisconnect((_) {
      isConnected = false;
      log("❌ P2P Socket Disconnected");
    });

    socket.onError((data) {
      log("⚠️ Socket Error $data");
    });
  }

  void disconnect() {
    socket.dispose();
  }

  /// REALTIME UPDATE LISTENER
  void listenP2pUpdate(Function(dynamic data) onData) {
    socket.off("P2PBuyOrSellListUpdated");

    socket.on("P2PBuyOrSellListUpdated", (data) {
      log("⚡ LIVE UPDATE RECEIVED");

      String pretty = const JsonEncoder.withIndent('  ').convert(data);
      log(pretty);
      print(pretty);

      onData(data);
    });
  }

  /// FETCH LIST
  Future<dynamic> getP2PBuyOrSellList({
    required String txType,
    String sortOrder = "asc",
    int page = 1,
    int limit = 10,
  }) {
    Completer completer = Completer();

    final body = {
      "txType": txType,
      "sortOrder": sortOrder,
      "page": page,
      "limit": limit,
    };

    socket.emitWithAck(
      "getP2PBuyOrSellList",
      body,
      ack: (response) {
        print("📡 Fetch Response $response");

        if (response["status"] == true) {
          completer.complete(response);
        } else {
          completer.completeError(response["message"]);
        }
      },
    );

    return completer.future;
  }
}
