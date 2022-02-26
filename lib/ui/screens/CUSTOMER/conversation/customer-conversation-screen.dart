import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/conversation/chat/customer-chat-screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../locator.dart';

class CustomerConversationScreen extends StatelessWidget {
  final isBottom;
  const CustomerConversationScreen({this.isBottom = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ////
      ///FAB
      ///
      /// floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: ImageContainer(
      //     assets: "$assets/fab0.png",
      //     height: 60.h,
      //     width: 60.w,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      body: Column(
        children: [
          ///
          ///appbar
          ///
          appBar(),

          ///
          ///list of conversation
          ///
          conversationList(),
        ],
      ),
    );
  }

  ///
  ///appbar
  ///
  appBar() {
    return Container(
      height: 90.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //back button
              GestureDetector(
                onTap: () {
                  if (this.isBottom) {
                    Get.offAll(() => RootSCustomercreen(
                          index: 3,
                        ));
                  } else {
                    Get.back();
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(width: 18.w),
                      ImageContainer(
                        assets: "$assets/back.png",
                        height: 10,
                        width: 10,
                      ),
                      SizedBox(width: 13.29),
                      Text(
                        "BACK",
                        style: subHeadingTextstyle.copyWith(
                            fontSize: 13.sp,
                            letterSpacing: 0.4,
                            fontFamily: robottoFontTextStyle),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                "Chats",
                style: subHeadingTextstyle.copyWith(
                  fontSize: 17.sp,
                  fontFamily: robottoFontTextStyle,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(
                width: 80,
              ),
            ],
          ),
          SizedBox(
            height: 11.h,
          ),
          Container(
            height: 1.h,
            width: 1.sw,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchConversation() {
    final customerId = locator<LocalStorageService>().accessTokenCustomer;
    return FirebaseFirestore.instance
        .collection('customer_user')
        .doc(customerId)
        .collection('chat')
        .orderBy('timeStamp')
        .snapshots();
    ////TODO:
    //we will pass the reciver id to the chat screen which we will get here
    //ok so if=====> someone is going from this screen to the chat screen then we will pass reciver id
    /// else ===> we will take reciver id from that particular service provider for sure
    ///
  }

  ///
  ///list of conversation
  ///
  conversationList() {
    return StreamBuilder<QuerySnapshot>(
        stream: fetchConversation(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            ///parsing collection docs to messagelist
            List<Message> conversations = [];
            var providerId;
            // var chatId;
            snapshot.data!.docs.forEach((doc) {
              // chatId = doc.id;
              providerId = doc.id.toString().split('_').last;
              print("conversation/chat id is ======>$providerId");
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
                      return appTile(index, conversations[index], providerId);
                    },
                  );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(child: CircularProgressIndicator()
                  // Text(
                  // "Loading...",
                  // style: bodyTextStyle,
                  // )
                  ),
            );
          }
        });
  }

  appTile(index, Message conversation, providerId) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CustomerChatScreen(
              providerId: providerId,
              providerName: conversation.providerName,
              chatId: conversation.chatId,
            ));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 16.5, top: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(500),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 35.h,
                            width: 35.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                  "$assets/avatar.png",
                                )))),
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
                            // index % 2 == 0 ? "James" : "Will Kenny",
                            style: headingTextStyle.copyWith(
                              fontFamily: robottoFontTextStyle,
                              fontSize: 13.sp,
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
                                  // index % 2 == 0
                                  //     ? "Wanted to ask if you’re available for a portrait shoot next week."
                                  //     : "I know... I’m trying to get the funds.",
                                  style: bodyTextStyle.copyWith(
                                    fontFamily: robottoFontTextStyle,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [Text("${conversation.timeStamp}")],
                    )
                  ],
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 19.h,
          // ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
