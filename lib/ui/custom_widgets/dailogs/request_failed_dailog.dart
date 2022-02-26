import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestFailedDialog extends StatelessWidget {
  final errorMessage;

  RequestFailedDialog({@required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Response'),
      content: Text("$errorMessage"),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.black)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ok'.tr,
                style: bodyTextStyle.copyWith(color: Colors.white))),
      ],
    );
  }
}
