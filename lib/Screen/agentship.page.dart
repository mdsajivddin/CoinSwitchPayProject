// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:payment_app/config/auth/router/rightsliderFageRoute.dart';
// import 'package:payment_app/config/network/api.network.dart';
// import 'package:payment_app/config/utils/pretty.dio.dart';
// import 'package:payment_app/config/utils/showMessage.dart';
// import 'package:payment_app/data/controller/agentshipController.dart';
// import 'package:payment_app/data/model/applyAgentshipBodyModel.dart';

// class AgentshipPage extends ConsumerStatefulWidget {
//   const AgentshipPage({super.key});

//   @override
//   ConsumerState<AgentshipPage> createState() => _AgentshipPageState();
// }

// class _AgentshipPageState extends ConsumerState<AgentshipPage> {
//   // Manual Controllers
//   final TextEditingController _userIdController = TextEditingController();
//   final TextEditingController _telegramController = TextEditingController();
//   final TextEditingController _team1Controller = TextEditingController();
//   final TextEditingController _team2Controller = TextEditingController();
//   final TextEditingController _team3Controller = TextEditingController();
//   final TextEditingController _team4Controller = TextEditingController();
//   final TextEditingController _team5Controller = TextEditingController();

//   // Image Selection for 5 Team Members
//   final List<File?> _teamImages = List.generate(5, (_) => null);
//   final ImagePicker _picker = ImagePicker();

//   // Theme Colors
//   final Color bgColor = const Color(0xFF09111C);
//   final Color cardBg = const Color(0xFF0D1C26);
//   final Color accentColor = const Color(0xFF06CE8F);
//   final Color fieldBg = const Color(0xFF13222D);

//   // Function to pick image for a specific index
//   Future<void> _pickTeamImage(int index) async {
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxWidth: 800,
//     );
//     if (image != null) {
//       setState(() {
//         _teamImages[index] = File(image.path);
//       });
//       ShowMessage.success(context, "Screenshot added for Member ${index + 1}");
//     }
//   }

//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final agentshipState = ref.watch(agentshipController);
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Apply for Agentship",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: agentshipState.when(
//           data: (data) {
//             if (data.data != null) {
//               Navigator.push(
//                 context,
//                 RightSlideFadeRoute(page: AgentsListPage()),
//               );
//             }
//             return Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(20.w),
//                   decoration: BoxDecoration(
//                     color: cardBg,
//                     borderRadius: BorderRadius.circular(20.r),
//                     border: Border.all(color: Colors.white10),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Agent commission: You will earn 2% on every sell transaction completed by your team.",
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 13.sp,
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       _buildLabel("Enter Your User ID"),
//                       _buildMainField(_userIdController, "ABCD123456"),
//                       SizedBox(height: 16.h),
//                       _buildLabel("Enter Telegram ID *"),
//                       _buildMainField(_telegramController, "@username"),
//                       SizedBox(height: 20.h),
//                       _buildRequirementRow(),
//                       SizedBox(height: 20.h),
//                       Row(
//                         children: [
//                           Text(
//                             "Team Members ",
//                             style: GoogleFonts.poppins(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                           Text(
//                             "(5 required)",
//                             style: GoogleFonts.poppins(
//                               color: accentColor,
//                               fontSize: 12.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15.h),

//                       // --- Team Member Fields with Image Pick logic ---
//                       _buildTeamInput("Team User ID 1", _team1Controller, 0),
//                       _buildTeamInput("Team User ID 2", _team2Controller, 1),
//                       _buildTeamInput("Team User ID 3", _team3Controller, 2),
//                       _buildTeamInput("Team User ID 4", _team4Controller, 3),
//                       _buildTeamInput("Team User ID 5", _team5Controller, 4),

//                       SizedBox(height: 25.h),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 52.h,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             try {
//                               if (_telegramController.text.isEmpty) {
//                                 ShowMessage.error(context, "Enter Telegram ID");
//                                 return;
//                               }
//                               if (_team1Controller.text.isEmpty ||
//                                   _team2Controller.text.isEmpty ||
//                                   _team3Controller.text.isEmpty ||
//                                   _team4Controller.text.isEmpty ||
//                                   _team5Controller.text.isEmpty) {
//                                 ShowMessage.error(
//                                   context,
//                                   "Enter all team member IDs",
//                                 );
//                                 return;
//                               }
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               final service = ApiNetwork(createDio());

//                               /// Store uploaded image URLs
//                               List<String> imageUrls = [];

//                               /// 1️⃣ Upload images one by one
//                               for (int i = 0; i < _teamImages.length; i++) {
//                                 final file = _teamImages[i];

//                                 if (file == null) {
//                                   ShowMessage.error(
//                                     context,
//                                     "Please upload screenshot for member ${i + 1}",
//                                   );
//                                   return;
//                                 }

//                                 final response = await service.uploadImage(
//                                   file,
//                                 );

//                                 imageUrls.add(response.data!.imageUrl!);
//                               }

//                               /// 2️⃣ Create Team Members
//                               final teamMembers = [
//                                 TeamMember(
//                                   userId: _team1Controller.text,
//                                   imageUrl: imageUrls[0],
//                                 ),
//                                 TeamMember(
//                                   userId: _team2Controller.text,
//                                   imageUrl: imageUrls[1],
//                                 ),
//                                 TeamMember(
//                                   userId: _team3Controller.text,
//                                   imageUrl: imageUrls[2],
//                                 ),
//                                 TeamMember(
//                                   userId: _team4Controller.text,
//                                   imageUrl: imageUrls[3],
//                                 ),
//                                 TeamMember(
//                                   userId: _team5Controller.text,
//                                   imageUrl: imageUrls[4],
//                                 ),
//                               ];

//                               /// 3️⃣ Create Body
//                               final body = ApplyAgentshipBodyModel(
//                                 applicantUserId: _userIdController.text,
//                                 telegramId: _telegramController.text,
//                                 teamMembers: teamMembers,
//                               );

//                               /// 4️⃣ Apply Agentship API
//                               final response = await service.applyAgentship(
//                                 body,
//                               );
//                               if (response.code == 0 &&
//                                   response.error == false) {
//                                 Navigator.pop(context);
//                                 ShowMessage.success(
//                                   context,
//                                   response.message ??
//                                       "Application Submitted Successfully",
//                                 );
//                               } else {
//                                 ShowMessage.success(
//                                   context,
//                                   response.message ??
//                                       "Application Submitted Failed",
//                                 );
//                               }
//                             } catch (e) {
//                               ShowMessage.error(context, e.toString());
//                             } finally {
//                               setState(() {
//                                 isLoading = false;
//                               });
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: accentColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                           ),
//                           child:
//                               isLoading
//                                   ? Center(
//                                     child: SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   )
//                                   : Text(
//                                     "Submit Application",
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.sp,
//                                     ),
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//               ],
//             );
//           },
//           error: (error, stackTrace) => Center(child: Text(error.toString())),
//           loading:
//               () => const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.h),
//       child: Text(
//         text,
//         style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
//       ),
//     );
//   }

//   Widget _buildMainField(TextEditingController controller, String hint) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.white24),
//         filled: true,
//         fillColor: fieldBg,
//         contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: const BorderSide(color: Colors.white10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide(color: accentColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildRequirementRow() {
//     return RichText(
//       text: TextSpan(
//         style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
//         children: [
//           const TextSpan(text: "All "),
//           TextSpan(
//             text: "5 users ",
//             style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
//           ),
//           const TextSpan(text: "must be active at the same time with minimum "),
//           TextSpan(
//             text: "\$500 USDT ",
//             style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
//           ),
//           const TextSpan(text: "each."),
//         ],
//       ),
//     );
//   }

//   Widget _buildTeamInput(
//     String hint,
//     TextEditingController controller,
//     int index,
//   ) {
//     bool hasFile = _teamImages[index] != null;

//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     hintText: hint,
//                     hintStyle: const TextStyle(color: Colors.white24),
//                     filled: true,
//                     fillColor: fieldBg,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 14.h,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.r),
//                       borderSide: const BorderSide(color: Colors.white10),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.r),
//                       borderSide: BorderSide(color: accentColor),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               GestureDetector(
//                 onTap: () => _pickTeamImage(index),
//                 child: Container(
//                   height: 48.h,
//                   width: 48.h,
//                   decoration: BoxDecoration(
//                     color: fieldBg,
//                     borderRadius: BorderRadius.circular(10.r),
//                     border: Border.all(
//                       color: hasFile ? accentColor : Colors.white10,
//                     ),
//                   ),
//                   child: Icon(
//                     hasFile
//                         ? Icons.image_rounded
//                         : Icons.account_circle_outlined,
//                     color: hasFile ? accentColor : Colors.white54,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (hasFile)
//             Padding(
//               padding: EdgeInsets.only(top: 6.h, left: 4.w),
//               child: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: accentColor, size: 14.sp),
//                   SizedBox(width: 4.w),
//                   Expanded(
//                     child: Text(
//                       _teamImages[index]!.path.split('/').last,
//                       style: GoogleFonts.poppins(
//                         color: accentColor,
//                         fontSize: 10.sp,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class AgentsListPage extends StatelessWidget {
//   const AgentsListPage({super.key});

//   final List<String> agents = const [
//     "HEL261697",
//     "TES666225",
//     "TES614585",
//     "DIS211472",
//     "TES998122",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF08121C),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//           child: ListView.builder(
//             itemCount: agents.length,
//             itemBuilder: (context, index) {
//               return AgentCard(agentId: agents[index]);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AgentCard extends StatelessWidget {
//   final String agentId;

//   const AgentCard({super.key, required this.agentId});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h),
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18.r),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF0E1A27), Color(0xFF0A141F)],
//         ),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Row(
//         children: [
//           /// Avatar
//           Container(
//             width: 50.w,
//             height: 50.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFF1A2634),
//               border: Border.all(color: Colors.white12),
//             ),
//             child: Icon(Icons.person, color: Colors.white54, size: 26.sp),
//           ),

//           SizedBox(width: 14.w),

//           /// ID Text
//           Expanded(
//             child: Text(
//               agentId,
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),

//           /// Active Badge
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
//             decoration: BoxDecoration(
//               color: const Color(0xFF0F3B32),
//               borderRadius: BorderRadius.circular(30.r),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.check_circle,
//                   color: const Color(0xFF06CE8F),
//                   size: 14.sp,
//                 ),
//                 SizedBox(width: 5.w),
//                 Text(
//                   "ACTIVE",
//                   style: GoogleFonts.poppins(
//                     color: const Color(0xFF06CE8F),
//                     fontSize: 11.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payment_app/config/network/api.network.dart';
import 'package:payment_app/config/utils/pretty.dio.dart';
import 'package:payment_app/config/utils/showMessage.dart';
import 'package:payment_app/data/controller/agentshipController.dart';
import 'package:payment_app/data/model/applyAgentshipBodyModel.dart';

class AgentshipPage extends ConsumerStatefulWidget {
  const AgentshipPage({super.key});

  @override
  ConsumerState<AgentshipPage> createState() => _AgentshipPageState();
}

class _AgentshipPageState extends ConsumerState<AgentshipPage> {
  final List<File?> _teamImages = List.generate(5, (_) => null);
  final ImagePicker _picker = ImagePicker();

  final Color bgColor = const Color(0xFF09111C);
  final Color cardBg = const Color(0xFF0D1C26);
  final Color accentColor = const Color(0xFF06CE8F);
  final Color fieldBg = const Color(0xFF13222D);

  bool isLoading = false;

  Future<void> _pickTeamImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
    if (image != null) {
      setState(() {
        _teamImages[index] = File(image.path);
      });

      ShowMessage.success(context, "Screenshot added for Member ${index + 1}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final agentshipState = ref.watch(agentshipController);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Apply for Agentship",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),

      body: agentshipState.when(
        data: (data) {
          /// अगर API से agents मिलते हैं → List दिखाओ
          final teamMembers = data.data?.teamMembers;

          if (teamMembers == null || teamMembers.isEmpty) {
            return FormDesign();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  itemCount: data.data!.teamMembers!.length,
                  itemBuilder: (context, index) {
                    final agent = data.data!.teamMembers![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.r),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0E1A27), Color(0xFF0A141F)],
                            ),
                            border: Border.all(color: Colors.white10),
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1A2634),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    agent.imageUrl ?? "",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        color: Colors.white54,
                                        size: 26.sp,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(width: 14.w),

                              Expanded(
                                child: Text(
                                  agent.userId ?? "",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F3B32),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: const Color(0xFF06CE8F),
                                      size: 14.sp,
                                    ),

                                    SizedBox(width: 5.w),

                                    Text(
                                      agent.status ?? "",
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF06CE8F),
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    width: 0.9.sw,
                    padding: EdgeInsets.symmetric(
                      vertical: 30.h,
                      horizontal: 24.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1720),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Title
                        Text(
                          data.data!.status ?? "",
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3B82F6),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// Description
                        Text(
                          "All members are verified. Your status has been approved by the admin.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            height: 1.6,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),

                        SizedBox(height: 28.h),

                        /// Status Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: const Color(0xFF60A5FA),
                                size: 20.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Status: ${data.data!.status ?? ""}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          /// अगर null है → Form दिखाओ
        },

        error: (e, st) => Center(child: Text(e.toString())),

        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
      ),
    );
  }
}

class FormDesign extends ConsumerStatefulWidget {
  const FormDesign({super.key});

  @override
  ConsumerState<FormDesign> createState() => _FormDesignState();
}

class _FormDesignState extends ConsumerState<FormDesign> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _telegramController = TextEditingController();
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();
  final TextEditingController _team3Controller = TextEditingController();
  final TextEditingController _team4Controller = TextEditingController();
  final TextEditingController _team5Controller = TextEditingController();
  final List<File?> _teamImages = List.generate(5, (_) => null);
  final ImagePicker _picker = ImagePicker();

  final Color bgColor = const Color(0xFF09111C);
  final Color cardBg = const Color(0xFF0D1C26);
  final Color accentColor = const Color(0xFF06CE8F);
  final Color fieldBg = const Color(0xFF13222D);

  bool isLoading = false;

  Future<void> _pickTeamImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );

    if (image != null) {
      setState(() {
        _teamImages[index] = File(image.path);
      });

      ShowMessage.success(context, "Screenshot added for Member ${index + 1}");
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Agent commission: You will earn 3% on every sell transaction completed by your team.",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  _buildLabel("Enter Your User ID"),
                  _buildMainField(_userIdController, "ABCD123456"),

                  SizedBox(height: 16.h),

                  _buildLabel("Enter Telegram ID *"),
                  _buildMainField(_telegramController, "@username"),

                  SizedBox(height: 20.h),

                  _buildRequirementRow(),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Text(
                        "Team Members ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "(5 required)",
                        style: GoogleFonts.poppins(
                          color: accentColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  _buildTeamInput("Team User ID 1", _team1Controller, 0),
                  _buildTeamInput("Team User ID 2", _team2Controller, 1),
                  _buildTeamInput("Team User ID 3", _team3Controller, 2),
                  _buildTeamInput("Team User ID 4", _team4Controller, 3),
                  _buildTeamInput("Team User ID 5", _team5Controller, 4),

                  SizedBox(height: 25.h),

                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isSubmitted = true; // ✅ yaha add karo
                        });
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        try {
                          setState(() => isLoading = true);

                          final service = ApiNetwork(createDio());

                          List<String> imageUrls = [];

                          for (int i = 0; i < _teamImages.length; i++) {
                            final file = _teamImages[i];

                            if (file == null) {
                              ShowMessage.error(
                                context,
                                "Upload screenshot for member ${i + 1}",
                              );
                              return;
                            }

                            final response = await service.uploadImage(file);

                            imageUrls.add(response.data!.imageUrl!);
                          }

                          final teamMembers = [
                            TeamMember(
                              userId: _team1Controller.text,
                              imageUrl: imageUrls[0],
                            ),
                            TeamMember(
                              userId: _team2Controller.text,
                              imageUrl: imageUrls[1],
                            ),
                            TeamMember(
                              userId: _team3Controller.text,
                              imageUrl: imageUrls[2],
                            ),
                            TeamMember(
                              userId: _team4Controller.text,
                              imageUrl: imageUrls[3],
                            ),
                            TeamMember(
                              userId: _team5Controller.text,
                              imageUrl: imageUrls[4],
                            ),
                          ];

                          final body = ApplyAgentshipBodyModel(
                            applicantUserId: _userIdController.text,
                            telegramId: _telegramController.text,
                            teamMembers: teamMembers,
                          );

                          final response = await service.applyAgentship(body);

                          if (response.code == 0 && response.error == false) {
                            ShowMessage.success(
                              context,
                              response.message ??
                                  "Application Submitted Successfully",
                            );

                            ref.refresh(agentshipController);
                          } else {
                            ShowMessage.error(
                              context,
                              response.message ?? "Application Failed",
                            );
                          }
                        } catch (e) {
                          ShowMessage.error(context, e.toString());
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child:
                          isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                "Submit Application",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
      ),
    );
  }

  Widget _buildMainField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: fieldBg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: accentColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }

        // Telegram specific validation
        if (hint.contains("@") && !value.startsWith("@")) {
          return "Telegram ID must start with @";
        }

        return null;
      },
    );
  }

  Widget _buildRequirementRow() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
        children: const [
          TextSpan(text: "All 5 users must be active with minimum "),
          TextSpan(text: "\$500 USDT each"),
        ],
      ),
    );
  }

  Widget _buildTeamInput(
    String hint,
    TextEditingController controller,
    int index,
  ) {
    bool hasFile = _teamImages[index] != null;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: Colors.white24),
                    filled: true,
                    fillColor: fieldBg,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter $hint";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () => _pickTeamImage(index),
                child: Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    color: fieldBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: hasFile ? accentColor : Colors.white10,
                    ),
                  ),
                  child: Icon(
                    hasFile
                        ? Icons.check_circle_outline
                        : Icons.file_upload_outlined,
                    color: hasFile ? accentColor : Colors.white54,
                  ),
                ),
              ),
            ],
          ),
          // ✅ File validation message (optional)
          if (isSubmitted && !hasFile)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 14.w),
              child: Text(
                "Profile page screenshot required",
                style: TextStyle(color: Colors.red, fontSize: 10.sp),
              ),
            ),

          if (hasFile)
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: accentColor, size: 14.sp),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      _teamImages[index]!.path.split('/').last,
                      style: GoogleFonts.poppins(
                        color: accentColor,
                        fontSize: 10.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
