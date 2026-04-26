import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SupportService {
  static final SupportService _instance = SupportService._internal();
  factory SupportService() => _instance;

  SupportService._internal();

  IO.Socket? socket;
  bool _isConnected = false;

  void connect() {
    if (_isConnected) return; // 🔥 prevent multiple connect

    socket = IO.io(
      "https://coinswitchpay.com",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      _isConnected = true;
      log("✅ Socket Connected: ${socket!.id}");
    });

    socket!.onDisconnect((_) {
      _isConnected = false;
      log("❌ Socket Disconnected");
    });

    socket!.onAny((event, data) {
      log("🔥 EVENT: $event DATA: $data");
    });
  }

  /// ✅ JOIN ROOM
  void joinRoom(String ticketId) {
    log("📡 joinSupportRoom: $ticketId");
    socket!.emitWithAck(
      'joinSupportRoom',
      {'ticketId': ticketId},
      ack: (data) {
        log("Socket: Joined room confirmed by server: $data");
      },
    );
  }

  /// ✅ LISTEN MESSAGE (single listener)
  void listenMessage(Function(dynamic) callback) {
    socket?.off("receiveSupportMessage");
    socket?.on("receiveSupportMessage", (data) {
      log("📩 MESSAGE RECEIVED: $data");
      callback(data);
    });
  }

  void sendMessage(Map<String, dynamic> payload) {
    log("📤 Sending Message: $payload");
    socket?.emit("sendSupportMessage", payload);
  }
}



// class SupportService {
//   static final SupportService _instance = SupportService._internal();
//   factory SupportService() => _instance;

//   SupportService._internal();

//   IO.Socket? socket;

//   void connect(Function(dynamic data)? onMessage) {
//     socket = IO.io(
//       "https://coinswitchpay.com",
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           .enableReconnection()
//           .build(),
//     );

//     socket!.connect();

//     socket!.onConnect((_) {
//       log("✅ Socket Connected: ${socket!.id}");

//       /// 🔥 JOIN ROOM
//       // (important warna message nahi aayega)
//     });

//     /// 🔥 RECEIVE MESSAGE HERE ONLY
//     if (onMessage != null) {
//       socket!.off("receiveSupportMessage"); // clean old

//       socket!.on("receiveSupportMessage", (data) {
//         log("📩 MESSAGE RECEIVED: $data");
//         onMessage(data);
//       });
//     }

//     /// DEBUG ALL EVENTS
//     socket!.onAny((event, data) {
//       log("🔥 EVENT: $event DATA: $data");
//     });

//     socket!.onDisconnect((_) {
//       log("❌ Socket Disconnected");
//     });

//     socket!.onError((err) {
//       log("🚨 Socket Error: $err");
//     });
//   }

//   void sendMessage(Map<String, dynamic> payload) {
//     log("📤 Sending Message: $payload");
//     socket?.emit("sendSupportMessage", payload);
//   }
// }