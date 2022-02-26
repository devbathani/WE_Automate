import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/core/others/base_view_model.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/database_service.dart';
import 'package:flutter/material.dart';

import '../../../../../locator.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel() {
    init();
  }

  final _dbService = locator<DatabaseService>();
  Message? msgToBeSent;
  final controller = TextEditingController();

  init() {
    msgToBeSent = Message();
    notifyListeners();
  }

  sendMessage({required chatId, required senderId}) async {
    setState(ViewState.loading);
    //sender id assigning
    msgToBeSent!.senderId = senderId;
    msgToBeSent!.providerName =
        locator<AuthService>().providerProfile!.businessName;
    print("PROVIDER NAME ==> ${msgToBeSent!.providerName}");
    msgToBeSent!.timeStamp = DateTime.now().toString(); //timeStamp;
    //finally send message
    _dbService.sendMessage(message: msgToBeSent, chatId: chatId);
    // _dbService.updateConversation(conversation);
    // reversedMessagesList.add(msgToBeSent);
    controller.clear();
    msgToBeSent = msgToBeSent = Message(senderId: senderId);
    setState(ViewState.idle);
  }
}
