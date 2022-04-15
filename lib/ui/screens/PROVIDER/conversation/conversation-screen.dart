import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/chat/chat-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../locator.dart';

class ConversationScreen extends StatelessWidget {
  final isBottom;
  const ConversationScreen({this.isBottom = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            appBar(),
            conversationList(),
          ],
        ),
      ),
    );
  }

  appBar() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 5.w,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text(
                "Back",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chats",
                  style: GoogleFonts.openSans(
                    color: Color(0xff8B53FF),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchConversation() {
    final providerId = locator<LocalStorageService>().accessTokenProvider;
    return FirebaseFirestore.instance
        .collection('provider_user')
        .doc(providerId)
        .collection('chat')
        // .doc(chatId)
        // .collection('messages')
        .orderBy('timeStamp')
        .snapshots();
  }

  conversationList() {
    return StreamBuilder<QuerySnapshot>(
        stream: fetchConversation(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var customerId;

            List<Message> conversations = [];
            snapshot.data!.docs.forEach((doc) {
              customerId = doc.id.split('_').first;
              print("Provider NAME ===>  ${doc.data()}");
              conversations.add(Message.fromJson2(doc.data(), doc.id));
            });
            return conversations.length < 1
                ? Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: Center(
                      child: Text(
                        "No conversation available",
                        style: bodyTextStyle,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: conversations.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return appTile(index, conversations[index], customerId);
                    },
                  );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  appTile(index, Message conversation, customerId) {
    print("PROVIDERR NAME ==> ${conversation.providerName}");
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatScreen(
            customerId: customerId,
            customerName: conversation.customerName,
            chatId: conversation.chatId,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 16.5, top: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 35.h,
                        width: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              "$assets/messages.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${conversation.providerName}",
                            style: GoogleFonts.openSans(
                              color: Color(0xff8B53FF),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "${conversation.message}",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "${conversation.timeStamp}",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 5,
          )
        ],
      ),
    );
  }
}
