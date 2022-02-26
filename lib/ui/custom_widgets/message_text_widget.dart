import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/message.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MessengerTextRight extends StatelessWidget {
  final Message? message;

  MessengerTextRight({this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                flex: 5,
                child: Material(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: chatBorderRadiusRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          message!.message ?? '',
                          style: chatTextStyleRight,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Text(
                        //       message.timeStamp ?? "null",
                        //       style: subBodyTextStyle.copyWith(
                        //           fontSize: 11, color: Colors.white),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 20.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                "$assets/avatar03.png",
                              )))),
                    ),
                  ),
                ),
              ),
            ],
          ),
//           Padding(
//             padding: const EdgeInsets.only(left: 60, right: 7, top: 5),
//             child: Text(
// //              '9:00 PM',
//               message!.timeStamp ?? ' ',
//               style: chatTimeTS,
//             ),
//           ),
        ],
      ),
    );
  }
}

class MessengerTextLeft extends StatelessWidget {
  final Message? message;

  MessengerTextLeft({this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(500),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 20.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                    "$assets/avatar.png",
                                  )))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                flex: 5,
                child: Material(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: chatBorderRadiusLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      message!.message ?? '',
                      style: chatTextStyleLeft.copyWith(
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(flex: 1, child: Container()),
            ],
          ),

//           Padding(
//             padding: const EdgeInsets.only(right: 60, left: 8),
//             child: Text(
// //              '8:00 PM',
//               message.timeStamp ?? '',
//               style: chatTimeTS,
//             ),
//           ),
        ],
      ),
    );
  }
}

// class ImageMessageRight extends StatelessWidget {
//   final Message message;

//   ImageMessageRight(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: FadeInImage(
//                   height: 250,
//                   width: 180,
//                   image: NetworkImage(message.fileUrl ?? ''),
//                   placeholder: AssetImage('assets/static_assets/Image 1.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10, left: 8, top: 5),
//                 child: Text(
// //              '8:00 PM',
//                   message.timeStamp ?? '',
//                   style: chatTimeTS,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class ImageMessageLeft extends StatelessWidget {
//   final Message message;

//   ImageMessageLeft(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: FadeInImage(
//                   height: 250,
//                   width: 180,
//                   image: NetworkImage(message.fileUrl ?? ''),
//                   placeholder: AssetImage('assets/static_assets/Image 1.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10, left: 8, top: 5),
//                 child: Text(
// //              '8:00 PM',
//                   message.timeStamp ?? '',
//                   style: chatTimeTS,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class FileMessageRight extends StatelessWidget {
//   final Message message;

//   FileMessageRight(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Icon(Icons.insert_drive_file, color: mainThemeColor, size: 100),
//               Text('${basename(message.fileUrl)}'),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10, left: 8, top: 5),
//                 child: Text(
// //              '8:00 PM',
//                   message.timeStamp ?? '',
//                   style: chatTimeTS,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class FileMessageLeft extends StatelessWidget {
//   final Message message;

//   FileMessageLeft(this.message);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(Icons.insert_drive_file, color: mainThemeColor, size: 100),
//               Text('${basename(message.fileUrl)}'),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10, left: 8, top: 5),
//                 child: Text(
// //              '8:00 PM',
//                   message.timeStamp ?? '',
//                   style: chatTimeTS,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }