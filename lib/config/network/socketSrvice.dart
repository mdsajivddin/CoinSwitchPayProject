import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal() {
    connect();
  }

  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      "https://api.coinswitchpay.com",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print("✅ Socket Connected");
    });

    socket.onDisconnect((_) {
      print("❌ Socket Disconnected");
    });

    socket.onError((data) {
      print("⚠️ Socket Error: $data");
    });
  }

  /// ⭐ Listen Deposit Updates
  void listenDepositUpdate(Function(dynamic) onData) {
    socket.off("buyInrDepositListUpdated");

    socket.on("buyInrDepositListUpdated", (data) {
      print("🔄 Live Deposit Update Received");

      onData(data);
    });
  }
}


class DepositSocketApi {
  final socketService = SocketService();

  Future<dynamic> getBuyInrDepositList(String sortOrder) {
    Completer completer = Completer();

    socketService.socket.emitWithAck(
      "getBuyInrDepositList",
      {"sortOrder": sortOrder},
      ack: (response) {

        String jsonResponse =
            const JsonEncoder.withIndent('  ').convert(response);

        print("Socket Response:\n$jsonResponse");

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