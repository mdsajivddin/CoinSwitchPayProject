// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/network/supportService.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/GetAllUserTicketController.dart';

// class LiveSupportChatScreen extends ConsumerStatefulWidget {
//   final String id;
//   const LiveSupportChatScreen({Key? key, required this.id}) : super(key: key);

//   @override
//   ConsumerState<LiveSupportChatScreen> createState() =>
//       _LiveSupportChatScreenState();
// }

// class _LiveSupportChatScreenState extends ConsumerState<LiveSupportChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final ImagePicker _picker = ImagePicker();

//   List<Map<String, dynamic>> _allMessages = [];
//   final socketService = SupportService();

//   // Image Upload States
//   String? _uploadedImageUrl;
//   bool _isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     socketService.connect();

//     socketService.listenMessage((data) {
//       if (mounted) {
//         setState(() {
//           _allMessages.insert(0, {
//             "message": data["message"] ?? "",
//             "createdAt": DateTime.now().millisecondsSinceEpoch,
//             "senderType": data["senderType"] ?? "Admin",
//             "attachments": data["attachments"] ?? [],
//           });
//         });
//       }
//     });
//   }

//   // ==================== IMAGE PICK & UPLOAD ====================
//   Future<void> _handleImagePicker() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1024,
//       maxHeight: 1024,
//       imageQuality: 50,
//     );

//     if (image != null) {
//       final file = File(image.path);
//       final int sizeInBytes = await file.length();
//       log("File size for upload: ${sizeInBytes / 1024} KB");

//       await _uploadImage(file);
//     }
//   }

//   Future<void> _uploadImage(File file) async {
//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       final service = ApiNetwork(createDio());
//       final response = await service.uploadImage(file);

//       if (response.code == 0 && response.error == false) {
//         setState(() {
//           _uploadedImageUrl = response.data!.imageUrl;
//         });
//         // Note: Automatic _sendMessage() removed to allow preview
//       }
//     } catch (e) {
//       ShowMessage.error(context, "Image upload failed: $e");
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   // ==================== SEND MESSAGE ====================
//   void _sendMessage() {
//     final text = _messageController.text.trim();

//     // Logic: Don't send if both text and image are empty
//     if (text.isEmpty && _uploadedImageUrl == null) return;

//     var box = Hive.box("userdata");
//     final userId = box.get('id');

//     final attachments =
//         _uploadedImageUrl != null
//             ? [
//               {"url": _uploadedImageUrl, "type": "image"},
//             ]
//             : [];

//     final payload = {
//       "ticketId": widget.id,
//       "senderType": "User",
//       "senderId": userId,
//       "message": text,
//       "attachments": attachments,
//     };

//     socketService.sendMessage(payload);

//     setState(() {
//       _allMessages.insert(0, {
//         "message": text,
//         "createdAt": DateTime.now().millisecondsSinceEpoch,
//         "senderType": "User",
//         "attachments": attachments,
//       });
//       _uploadedImageUrl = null; // Clear image after sending
//     });

//     _messageController.clear();
//   }

//   @override
//   void dispose() {
//     socketService.dispose();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncState = ref.watch(getTicketByIdController(widget.id));

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: _buildAppBar(),
//       body: asyncState.when(
//         data: (response) {
//           final apiMessages = response.data?.messages ?? [];

//           if (_allMessages.isEmpty && apiMessages.isNotEmpty) {
//             _allMessages =
//                 apiMessages
//                     .map(
//                       (m) => {
//                         "message": m.message,
//                         "createdAt": m.createdAt,
//                         "senderType": m.senderType,
//                         "attachments": m.attachments,
//                       },
//                     )
//                     .toList()
//                     .reversed
//                     .toList();
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   padding: EdgeInsets.all(16.w),
//                   reverse: true,
//                   itemCount: _allMessages.length,
//                   itemBuilder: (context, index) {
//                     final msg = _allMessages[index];
//                     final isSender = msg["senderType"] == "User";

//                     return _buildChatBubble(
//                       isSender: isSender,
//                       time: DateFormat('hh:mm a').format(
//                         DateTime.fromMillisecondsSinceEpoch(
//                           msg["createdAt"] ?? 0,
//                         ),
//                       ),
//                       child: _buildMessageContent(msg),
//                     );
//                   },
//                 ),
//               ),
//               _buildInputArea(), // Preview aur Input yahan handle honge
//             ],
//           );
//         },
//         loading:
//             () => const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//         error:
//             (error, _) => Center(
//               child: Text(
//                 "Error: $error",
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//       ),
//     );
//   }

//   // ==================== IMAGE PREVIEW WIDGET ====================
//   Widget _buildImagePreview() {
//     if (_uploadedImageUrl == null && !_isUploading) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: const BoxDecoration(
//         color: Color(0xFF161B22),
//         border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 70.h,
//                 width: 90.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.r),
//                   border: Border.all(
//                     color: const Color(0xFF00B894),
//                     width: 1.5,
//                   ),
//                   color: Colors.black26,
//                 ),
//                 child:
//                     _isUploading
//                         ? const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                         : ClipRRect(
//                           borderRadius: BorderRadius.circular(8.r),
//                           child: Image.network(
//                             _uploadedImageUrl!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//               ),
//               if (!_isUploading)
//                 Positioned(
//                   top: -2,
//                   right: -2,
//                   child: GestureDetector(
//                     onTap: () => setState(() => _uploadedImageUrl = null),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 16.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageContent(Map<String, dynamic> msg) {
//     final attachments = msg["attachments"] as List?;
//     bool hasImage = attachments != null && attachments.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (hasImage)
//           Padding(
//             padding: EdgeInsets.only(bottom: 5.h),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8.r),
//               child: Image.network(
//                 attachments.first is Map
//                     ? attachments.first['url']
//                     : attachments.first.url,
//                 fit: BoxFit.cover,
//                 width: 200.w,
//                 errorBuilder:
//                     (_, __, ___) =>
//                         const Icon(Icons.broken_image, color: Colors.white54),
//               ),
//             ),
//           ),
//         if (msg["message"] != null && msg["message"].toString().isNotEmpty)
//           Text(
//             msg["message"],
//             style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
//           ),
//       ],
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: const Color(0xFF161B22), // Dark background as per image
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       titleSpacing:
//           0, // Profile picture aur back button ke beech space kam karne ke liye
//       title: Row(
//         children: [
//           // Profile Picture with Online Status Dot
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 18.r,
//                 backgroundColor: const Color(0xFF2D333B),
//                 child: Icon(Icons.person, color: Colors.white70, size: 22.sp),
//               ),
//               // Online Green Indicator
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   height: 10.w,
//                   width: 10.w,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF00B894), // Green color
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: const Color(0xFF161B22),
//                       width: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(width: 12.w),
//           // Name and Online Status Text
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Live Support",
//                 style: GoogleFonts.poppins(
//                   fontSize: 15.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "online",
//                 style: GoogleFonts.poppins(
//                   fontSize: 11.sp,
//                   color: const Color(0xFF00B894), // Green text
//                   height: 1.2,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       // actions: [
//       //   // Right side three dots menu
//       //   IconButton(
//       //     icon: const Icon(Icons.more_vert, color: Colors.white70),
//       //     onPressed: () {
//       //       // Add your menu logic here
//       //     },
//       //   ),
//       // ],
//     );
//   }

//   Widget _buildChatBubble({
//     required bool isSender,
//     required Widget child,
//     required String time,
//   }) {
//     return Align(
//       alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(
//           bottom: 12.h,
//           left: isSender ? 50.w : 0,
//           right: isSender ? 0 : 50.w,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//         decoration: BoxDecoration(
//           color: isSender ? const Color(0xFF054740) : const Color(0xFF21262D),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             child,
//             SizedBox(height: 4.h),
//             Text(
//               time,
//               style: TextStyle(color: Colors.white54, fontSize: 10.sp),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildImagePreview(),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
//           color: const Color(0xFF161B22),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1F2937),
//                     borderRadius: BorderRadius.circular(25.r),
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: _handleImagePicker,
//                         icon: const Icon(
//                           Icons.attach_file,
//                           color: Colors.white54,
//                         ),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: const InputDecoration(
//                             hintText: "Type a message...",
//                             hintStyle: TextStyle(color: Colors.white38),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               GestureDetector(
//                 onTap: _sendMessage,
//                 child: CircleAvatar(
//                   backgroundColor: const Color(0xFF2563EB),
//                   radius: 24.r,
//                   child: const Icon(Icons.send, color: Colors.white, size: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/network/supportService.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/GetAllUserTicketController.dart';

// class LiveSupportChatScreen extends ConsumerStatefulWidget {
//   final String id;
//   const LiveSupportChatScreen({Key? key, required this.id}) : super(key: key);

//   @override
//   ConsumerState<LiveSupportChatScreen> createState() =>
//       _LiveSupportChatScreenState();
// }

// class _LiveSupportChatScreenState extends ConsumerState<LiveSupportChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final ImagePicker _picker = ImagePicker();

//   List<Map<String, dynamic>> _allMessages = [];
//   final socketService = SupportService();

//   // Image Upload States
//   String? _uploadedImageUrl;
//   bool _isUploading = false;

//   @override
//   void initState() {
//     super.initState();
//     socketService.connect();

//     // Handling receive message with ticketId check (React useEffect equivalent)
//     socketService.listenMessage((data) {
//       if (mounted) {
//         // Checking if the message belongs to this ticket
//         if (data["ticketId"] != widget.id) return;

//         setState(() {
//           _allMessages.insert(0, {
//             "message": data["message"] ?? "",
//             "createdAt": DateTime.now().millisecondsSinceEpoch,
//             "senderType": data["senderType"] ?? "Admin",
//             "attachments": data["attachments"] ?? [],
//           });
//         });
//       }
//     });
//   }

//   // ==================== IMAGE PICK & UPLOAD ====================
//   Future<void> _handleImagePicker() async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 1024,
//       maxHeight: 1024,
//       imageQuality: 50,
//     );

//     if (image != null) {
//       final file = File(image.path);
//       final int sizeInBytes = await file.length();
//       log("File size for upload: ${sizeInBytes / 1024} KB");

//       await _uploadImage(file);
//     }
//   }

//   Future<void> _uploadImage(File file) async {
//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       final service = ApiNetwork(createDio());
//       final response = await service.uploadImage(file);

//       if (response.code == 0 && response.error == false) {
//         setState(() {
//           _uploadedImageUrl = response.data!.imageUrl;
//         });
//       }
//     } catch (e) {
//       ShowMessage.error(context, "Image upload failed: $e");
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   // ==================== SEND MESSAGE ====================
//   void _sendMessage() {
//     final text = _messageController.text.trim();

//     if (text.isEmpty && _uploadedImageUrl == null) return;

//     var box = Hive.box("userdata");
//     final userId = box.get('id');

//     final attachments =
//         _uploadedImageUrl != null
//             ? [
//               {"url": _uploadedImageUrl, "type": "image"},
//             ]
//             : [];

//     final payload = {
//       "ticketId": widget.id,
//       "senderType": "User",
//       "senderId": userId,
//       "message": text,
//       "attachments": attachments,
//     };

//     socketService.sendMessage(payload);

//     setState(() {
//       _allMessages.insert(0, {
//         "message": text,
//         "createdAt": DateTime.now().millisecondsSinceEpoch,
//         "senderType": "User",
//         "attachments": attachments,
//       });
//       _uploadedImageUrl = null;
//     });

//     _messageController.clear();
//   }

//   @override
//   void dispose() {
//     socketService.dispose();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncState = ref.watch(getTicketByIdController(widget.id));

//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       appBar: _buildAppBar(),
//       body: asyncState.when(
//         data: (response) {
//           final apiMessages = response.data?.messages ?? [];

//           if (_allMessages.isEmpty && apiMessages.isNotEmpty) {
//             _allMessages =
//                 apiMessages
//                     .map(
//                       (m) => {
//                         "message": m.message,
//                         "createdAt": m.createdAt,
//                         "senderType": m.senderType,
//                         "attachments": m.attachments,
//                       },
//                     )
//                     .toList()
//                     .reversed
//                     .toList();
//           }

//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   controller: _scrollController,
//                   padding: EdgeInsets.all(16.w),
//                   reverse: true,
//                   itemCount: _allMessages.length,
//                   itemBuilder: (context, index) {
//                     final msg = _allMessages[index];
//                     final isSender = msg["senderType"] == "User";

//                     return _buildChatBubble(
//                       isSender: isSender,
//                       time: DateFormat('hh:mm a').format(
//                         DateTime.fromMillisecondsSinceEpoch(
//                           msg["createdAt"] ?? 0,
//                         ),
//                       ),
//                       child: _buildMessageContent(msg),
//                     );
//                   },
//                 ),
//               ),
//               _buildInputArea(),
//             ],
//           );
//         },
//         loading:
//             () => const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//         error:
//             (error, _) => Center(
//               child: Text(
//                 "Error: $error",
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ),
//       ),
//     );
//   }

//   // ==================== IMAGE PREVIEW WIDGET ====================
//   Widget _buildImagePreview() {
//     if (_uploadedImageUrl == null && !_isUploading) {
//       return const SizedBox.shrink();
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: const BoxDecoration(
//         color: Color(0xFF161B22),
//         border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 70.h,
//                 width: 90.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.r),
//                   border: Border.all(
//                     color: const Color(0xFF00B894),
//                     width: 1.5,
//                   ),
//                   color: Colors.black26,
//                 ),
//                 child:
//                     _isUploading
//                         ? const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                         : ClipRRect(
//                           borderRadius: BorderRadius.circular(8.r),
//                           child: Image.network(
//                             _uploadedImageUrl!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//               ),
//               if (!_isUploading)
//                 Positioned(
//                   top: -2,
//                   right: -2,
//                   child: GestureDetector(
//                     onTap: () => setState(() => _uploadedImageUrl = null),
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 16.sp,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageContent(Map<String, dynamic> msg) {
//     final attachments = msg["attachments"] as List?;
//     bool hasImage = attachments != null && attachments.isNotEmpty;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (hasImage)
//           Padding(
//             padding: EdgeInsets.only(bottom: 5.h),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8.r),
//               child: Image.network(
//                 attachments.first is Map
//                     ? attachments.first['url']
//                     : attachments.first.url,
//                 fit: BoxFit.cover,
//                 width: 200.w,
//                 errorBuilder:
//                     (_, __, ___) =>
//                         const Icon(Icons.broken_image, color: Colors.white54),
//               ),
//             ),
//           ),
//         if (msg["message"] != null && msg["message"].toString().isNotEmpty)
//           Text(
//             msg["message"],
//             style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
//           ),
//       ],
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: const Color(0xFF161B22),
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Navigator.pop(context),
//       ),
//       titleSpacing: 0,
//       title: Row(
//         children: [
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 18.r,
//                 backgroundColor: const Color(0xFF2D333B),
//                 child: Icon(Icons.person, color: Colors.white70, size: 22.sp),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 child: Container(
//                   height: 10.w,
//                   width: 10.w,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF00B894),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: const Color(0xFF161B22),
//                       width: 1.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(width: 12.w),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Live Support",
//                 style: GoogleFonts.poppins(
//                   fontSize: 15.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "online",
//                 style: GoogleFonts.poppins(
//                   fontSize: 11.sp,
//                   color: const Color(0xFF00B894),
//                   height: 1.2,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.more_vert, color: Colors.white70),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildChatBubble({
//     required bool isSender,
//     required Widget child,
//     required String time,
//   }) {
//     return Align(
//       alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(
//           bottom: 12.h,
//           left: isSender ? 50.w : 0,
//           right: isSender ? 0 : 50.w,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
//         decoration: BoxDecoration(
//           color: isSender ? const Color(0xFF054740) : const Color(0xFF21262D),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             child,
//             SizedBox(height: 4.h),
//             Text(
//               time,
//               style: TextStyle(color: Colors.white54, fontSize: 10.sp),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildImagePreview(),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
//           color: const Color(0xFF161B22),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1F2937),
//                     borderRadius: BorderRadius.circular(25.r),
//                   ),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: _handleImagePicker,
//                         icon: const Icon(
//                           Icons.attach_file,
//                           color: Colors.white54,
//                         ),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           style: const TextStyle(color: Colors.white),
//                           decoration: const InputDecoration(
//                             hintText: "Type a message...",
//                             hintStyle: TextStyle(color: Colors.white38),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               GestureDetector(
//                 onTap: _sendMessage,
//                 child: CircleAvatar(
//                   backgroundColor: const Color(0xFF2563EB),
//                   radius: 24.r,
//                   child: const Icon(Icons.send, color: Colors.white, size: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/network/supportService.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/GetAllUserTicketController.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LiveSupportChatScreen extends ConsumerStatefulWidget {
  final String id;
  const LiveSupportChatScreen({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<LiveSupportChatScreen> createState() =>
      _LiveSupportChatScreenState();
}

class _LiveSupportChatScreenState extends ConsumerState<LiveSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> _allMessages = [];
  final socketService = SupportService();

  String? _uploadedImageUrl;
  bool _isUploading = false;
  bool _isInitialLoaded = false;

  /// ✅ SAME FUNCTION REFERENCE (IMPORTANT)
  void _handleIncomingMessage(dynamic data) {
    if (!mounted) return;

    if (data["ticketId"].toString() != widget.id.toString()) return;

    log("🟢 Socket Message Received: $data");

    setState(() {
      _allMessages.insert(0, {
        "message": data["message"] ?? "",
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "senderType": data["senderType"] ?? "Admin",
        "attachments": data["attachments"] ?? [],
      });
    });

    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();

    /// ✅ connect only once
    socketService.connect();

    /// ✅ JOIN ROOM (IMPORTANT)
    Future.delayed(const Duration(milliseconds: 300), () {
      socketService.joinRoom(widget.id);
    });

    // socketService.listenMessage((msg) {
    //   if (!mounted) return;

    //   if (msg["ticketId"].toString() != widget.id.toString()) return;

    //   /// 🔥 IMPORTANT: ignore own message (duplicate fix)
    //   if (msg["senderType"] == "User") return;

    //   log("🟢 UI RECEIVED MESSAGE: $msg");

    //   setState(() {
    //     _allMessages.insert(0, {
    //       "message": msg["message"] ?? "",
    //       "createdAt": DateTime.now().millisecondsSinceEpoch,
    //       "senderType": msg["senderType"] ?? "Admin",
    //       "attachments": msg["attachments"] ?? [],
    //     });
    //   });

    //   _scrollToBottom();
    // });

    // socketService.listenMessage((msg) {
    //   if (!mounted) return;

    //   if (msg["ticketId"].toString() != widget.id.toString()) return;

    //   /// ✅ localId based duplicate check
    //   final alreadyExists = _allMessages.any(
    //     (m) =>
    //         m["localId"] != null &&
    //         msg["localId"] != null &&
    //         m["localId"] == msg["localId"],
    //   );

    //   if (alreadyExists) {
    //     log("⚠️ Duplicate ignored");
    //     return;
    //   }

    //   setState(() {
    //     _allMessages.insert(0, {
    //       "message": msg["message"] ?? "",
    //       "createdAt": DateTime.now().millisecondsSinceEpoch,
    //       "senderType": msg["senderType"] ?? "Admin",
    //       "attachments": msg["attachments"] ?? [],
    //       "localId": msg["localId"], // ✅ match
    //     });
    //   });

    //   _scrollToBottom();
    // });

    socketService.listenMessage((msg) {
      if (!mounted) return;

      if (msg["ticketId"].toString() != widget.id.toString()) return;

      var box = Hive.box("userdata");
      final myUserId = box.get('id');

      /// ✅ ONLY IGNORE YOUR OWN MESSAGE (CORRECT WAY)
      if (msg["senderId"].toString() == myUserId.toString()) {
        log("⚠️ Own message ignored (no duplicate)");
        return;
      }

      log("🟢 UI RECEIVED MESSAGE: $msg");

      setState(() {
        _allMessages.insert(0, {
          "message": msg["message"] ?? "",
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "senderType": msg["senderType"] ?? "Admin",
          "attachments": msg["attachments"] ?? [],
        });
      });

      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    /// ✅ Proper cleanup
    socketService.socket?.off("receiveSupportMessage", _handleIncomingMessage);

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------- CORE ----------------

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  //   // ==================== IMAGE PICK & UPLOAD ====================

  Future<void> _handleImagePicker() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 50,
    );

    if (image != null) {
      final file = File(image.path);
      final int sizeInBytes = await file.length();
      log("File size for upload: ${sizeInBytes / 1024} KB");

      await _uploadImage(file);
    }
  }

  Future<void> _uploadImage(File file) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final service = ApiNetwork(createDio());
      final response = await service.uploadImage(file);

      if (response.code == 0 && response.error == false) {
        setState(() {
          _uploadedImageUrl = response.data!.imageUrl;
        });
        // Note: Automatic _sendMessage() removed to allow preview
      }
    } catch (e) {
      ShowMessage.error(context, "Image upload failed: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _uploadedImageUrl == null) return;

    var box = Hive.box("userdata");
    final userId = box.get('id');

    final attachments =
        _uploadedImageUrl != null
            ? [
              {"url": _uploadedImageUrl, "type": "image"},
            ]
            : [];

    final payload = {
      "ticketId": widget.id,
      "senderType": "User",
      "senderId": userId,
      "message": text,
      "attachments": attachments,
    };

    /// ✅ SEND TO SOCKET
    socketService.sendMessage(payload);

    /// ✅ LOCAL UI UPDATE (instant feel)
    setState(() {
      _allMessages.insert(0, {
        "message": text,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "senderType": "User",
        "attachments": attachments,
      });
      _uploadedImageUrl = null;
    });

    _messageController.clear();
    _scrollToBottom();
  }

  // void _sendMessage() {
  //   final text = _messageController.text.trim();
  //   if (text.isEmpty && _uploadedImageUrl == null) return;

  //   var box = Hive.box("userdata");
  //   final userId = box.get('id');

  //   final localId = DateTime.now().millisecondsSinceEpoch;

  //   final attachments =
  //       _uploadedImageUrl != null
  //           ? [
  //             {"url": _uploadedImageUrl, "type": "image"},
  //           ]
  //           : [];

  //   final payload = {
  //     "ticketId": widget.id,
  //     "senderType": "User",
  //     "senderId": userId,
  //     "message": text,
  //     "attachments": attachments,
  //     "localId": localId, // ✅ important
  //   };

  //   socketService.sendMessage(payload);

  //   /// ✅ UI me bhi same localId use karo
  //   setState(() {
  //     _allMessages.insert(0, {
  //       "message": text,
  //       "createdAt": DateTime.now().millisecondsSinceEpoch,
  //       "senderType": "User",
  //       "attachments": attachments,
  //       "localId": localId, // ✅ MUST
  //     });
  //     _uploadedImageUrl = null;
  //   });

  //   _messageController.clear();
  //   _scrollToBottom();
  // }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(getTicketByIdController(widget.id));

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: _buildAppBar(),
      body: asyncState.when(
        data: (response) {
          /// ✅ INITIAL HISTORY LOAD (ONLY ONCE)
          if (!_isInitialLoaded) {
            final apiMessages = response.data?.messages ?? [];

            _allMessages =
                apiMessages
                    .map(
                      (m) => {
                        "message": m.message,
                        "createdAt": m.createdAt,
                        "senderType": m.senderType,
                        "attachments": m.attachments,
                      },
                    )
                    .toList()
                    .reversed
                    .toList();

            _isInitialLoaded = true;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.all(16.w),
                  itemCount: _allMessages.length,
                  itemBuilder: (context, index) {
                    final msg = _allMessages[index];

                    return _buildChatBubble(
                      isSender: msg["senderType"] == "User",
                      time: _formatTime(msg["createdAt"]),
                      child: _buildMessageContent(msg),
                    );
                  },
                ),
              ),
              _buildInputArea(),
            ],
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        error:
            (e, _) => Center(
              child: Text("Error: $e", style: TextStyle(color: Colors.red)),
            ),
      ),
    );
  }

  String _formatTime(dynamic timestamp) {
    try {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        timestamp is String ? int.parse(timestamp) : timestamp,
      );
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return "";
    }
  }

  Widget _buildMessageContent(Map<String, dynamic> msg) {
    final attachments = msg["attachments"] as List?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attachments != null && attachments.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                attachments.first is Map
                    ? attachments.first['url']
                    : attachments.first.url,
                width: 200.w,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const Icon(Icons.broken_image, color: Colors.white54),
              ),
            ),
          ),
        if (msg["message"] != null && msg["message"].toString().isNotEmpty)
          Text(
            msg["message"],
            style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
          ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF161B22),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFF2D333B),
                child: Icon(Icons.person, color: Colors.white70, size: 22.sp),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B894),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF161B22),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Live Support",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "online",
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: const Color(0xFF00B894),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required bool isSender,
    required Widget child,
    required String time,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12.h,
          left: isSender ? 50.w : 0,
          right: isSender ? 0 : 50.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSender ? Color(0xFF054740) : Color(0xFF21262D),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            SizedBox(height: 4.h),
            Text(
              time,
              style: TextStyle(color: Colors.white54, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_uploadedImageUrl != null || _isUploading) _buildImagePreview(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          color: const Color(0xFF161B22),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _handleImagePicker,
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.white54,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _sendMessage,
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF2563EB),
                  radius: 24.r,
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== IMAGE PREVIEW WIDGET ====================
  Widget _buildImagePreview() {
    if (_uploadedImageUrl == null && !_isUploading) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 70.h,
                width: 90.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xFF00B894),
                    width: 1.5,
                  ),
                  color: Colors.black26,
                ),
                child:
                    _isUploading
                        ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            _uploadedImageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
              ),
              if (!_isUploading)
                Positioned(
                  top: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: () => setState(() => _uploadedImageUrl = null),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
