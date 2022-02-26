import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewCustomerScreen extends StatelessWidget {
  const WebviewCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: ImageContainer(
          assets: "$assets/fab0.png",
          height: 60.h,
          width: 60.w,
          fit: BoxFit.cover,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            _topAppBar(),

            SizedBox(
              height: 40.h,
            ),
            Expanded(
              child: WebView(
                initialUrl:
                    'https://empowered4x.com/we-automate/ ', // 'https://flutter.dev',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _topAppBar() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          SizedBox(width: 20.w),
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
    );
  }
}
