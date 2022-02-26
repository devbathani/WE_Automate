import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/local_storage_service.dart';
import 'package:antonx_flutter_template/locator.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/message_text_widget.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/chat/chat-view-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final customerId;
  final customerName;
  final chatId;
  ChatScreen(
      {@required this.customerId,
      @required this.customerName,
      @required this.chatId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//dummy list
  List<Message> messages = [];
  @override
  void initState() {
    // messages.add(Message(
    //     message:
    //         "Really love your most recent photo. I’ve been trying to capture the same thing for a few months and would love some tips!"));
    // messages.add(Message(
    //     message:
    //         "A fast 50mm like f1.8 would help with the bokeh. I’ve been using primes as they tend to get a bit sharper images."));
    // messages.add(Message(message: "Thank you! That was very helpful!"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: SafeArea(
        child: Scaffold(
          body: Consumer<ChatViewModel>(
            builder: (context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ///
                /// Top bar
                ///
                _topAppBar(model),

                ///
                /// Chat Messages
                ///
                chatMessages(model),

                ///
                /// Send Message Text Field plus buttons
                ///
                sendMessageContainer(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages() {
    final providerId = locator<LocalStorageService>()
        .accessTokenProvider; //locator<AuthService>().providerProfile!.uid;
    // final customerId = widget.customerId ?? "customer_id";
    // final chatId = "${customerId}_$providerId"; //"${senderId}_$recieverId";
    return FirebaseFirestore.instance
        .collection('provider_user')
        .doc(providerId)
        .collection('chat')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timeStamp')
        .snapshots();
  }

  chatMessages(ChatViewModel model) {
    return Expanded(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: fetchMessages(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                ///parsing collection docs to messagelist
                List<Message> messages = [];
                snapshot.data!.docs.forEach((element) {
                  messages.add(Message.fromJson(element.data()));
                });

                messages = messages.reversed.toList();
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  reverse: true,
                  itemCount: messages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Message msg =
                    //     Message.fromJson(snapshot.data.docs[index].data());
                    bool isMe = messages[index].senderId ==
                        locator<LocalStorageService>().accessTokenProvider;
                    // locator<AuthService>().providerProfile!.uid;

                    print('isMe: $isMe');
                    return isMe
                        ? MessengerTextRight(message: messages[index])
                        : MessengerTextLeft(message: messages[index]);
                    // }
                  },
                );
              } else {
                return Container(
                    child: Center(child: Text("No conversation available")));
              }
            }),
      ),
    );
  }

  sendMessageContainer(context, ChatViewModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8, // has the effect of softening the shadow
            spreadRadius: 1.2, // has the effect of extending the shadow
            offset: Offset(
              0, // horizontal, move right 10
              5, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ///
            /// Message TextField
            ///
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0XFFEEF0F7),
                  borderRadius: BorderRadius.circular(27.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 11, right: 18.0),
                  child: Row(
                    children: [
                      // ImageContainer(
                      //   assetImage: "$assets/smile.png",
                      //   height: 18.h,
                      //   width: 18.w,
                      // ),
                      SizedBox(
                        width: 18,
                      ),
                      Flexible(
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: model.controller,
                          onChanged: (val) {
                            model.msgToBeSent!.message = val;
                          },
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Write a message',
                            hintStyle: headingTextStyle.copyWith(
                                fontSize: 13, color: Color(0XFF9E9E9E)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // ImageContainer(
                      //   assetImage: "$assets/gallery.png",
                      //   height: 20.5.h,
                      //   width: 20.5.w,
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 10,
            ),

            ///
            /// Send Message Button
            ///
            GestureDetector(
              onTap: () async {
                if (model.msgToBeSent!.message!.trim().length > 0) {
                  //customerid_providerid
                  final senderId =
                      locator<LocalStorageService>().accessTokenProvider;
                  print("CUSTOMER ID is ===> ${widget.customerId}");
                  // final recieverId = widget.customerId ?? "customer_id";
                  // final chatId =
                  //     "${recieverId}_$senderId"; //"${senderId}_$recieverId";
                  model.msgToBeSent!.customerName = widget.customerName;
                  model.sendMessage(
                    chatId: widget.chatId,
                    senderId: senderId,
                  );

                  messages.add(Message(
                    message: "${model.msgToBeSent!.message}",
                    senderId: senderId,
                  ));
                  model.controller.clear();
                  model.msgToBeSent =
                      model.msgToBeSent = Message(senderId: 'providerId');
                  model.setState(ViewState.idle);
                } else {
                  print("Please write something firstly");
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _topAppBar(ChatViewModel model) {
    return Container(
      height: 70.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //back button
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 18.w),
                    // IconButton(
                    //     onPressed: () {}, icon:
                    Icon(
                      Icons.arrow_back_ios_new,
                      size: 21.h,
                    ),
                    // )
                  ],
                ),
              ),
              Text(
                "${widget.customerName}",
                // "James",
                style: subHeadingTextstyle.copyWith(
                  fontSize: 17.sp,
                  fontFamily: robottoFontTextStyle,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(
                width: 20.w,
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
}
