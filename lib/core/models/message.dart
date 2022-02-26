import 'package:intl/intl.dart';

class Message {
  String? senderId;
  String? message;
  String? timeStamp;
  String? providerName;
  String? customerName;
  String? chatId;

  // MessageType type;
  // String fileUrl;

  Message({
    this.chatId,
    this.senderId,
    this.message,
    this.timeStamp,
    this.providerName,
    this.customerName,
    // this.type = MessageType.text,
    // this.fileUrl
  });

  Message.fromJson(json) {
    this.senderId = json['senderId'];
    this.message = json['message'];
    // this.type = _getMessageType(json['type']);
    if (json['timeStamp'] != null) {
      print('String time: ${json['timeStamp']}');

      var timeStamp;
      DateTime time =
          DateFormat('yyyy-mm-dd HH:mm:s').parse(json['timeStamp']).toLocal();
      if (time != null) {
        timeStamp = DateFormat('hh:mm a').format(time);
      }
      this.timeStamp = timeStamp.toString();
    }
    // fileUrl = json['fileUrl'];
    // print(message.toString());
  }

  Message.fromJson2(json, chatId) {
    this.chatId = chatId;
    this.senderId = json['senderId'];
    this.message = json['message'];
    this.providerName = json['providerName'];
    this.customerName = json['CustomerName'];
    // this.type = _getMessageType(json['type']);
    if (json['timeStamp'] != null) {
      print('String time: ${json['timeStamp']}');

      var timeStamp;
      DateTime time =
          DateFormat('yyyy-mm-dd HH:mm:s').parse(json['timeStamp']).toLocal();
      if (time != null) {
        timeStamp = DateFormat('hh:mm a').format(time);
      }
      this.timeStamp = timeStamp.toString();
    }
    // fileUrl = json['fileUrl'];
    // print(message.toString());
  }

  toJson() {
    return {
      'senderId': this.senderId,
      'message': this.message,
      'timeStamp': timeStamp,
      // 'fileUrl': this.fileUrl,
      // 'type': describeEnum(this.type ?? MessageType.text),
    };
  }

  toJson2() {
    return {
      'senderId': this.senderId,
      'message': this.message,
      'timeStamp': timeStamp,
      'providerName': providerName,
      'CustomerName': customerName
      // 'fileUrl': this.fileUrl,
      // 'type': describeEnum(this.type ?? MessageType.text),
    };
  }
}
