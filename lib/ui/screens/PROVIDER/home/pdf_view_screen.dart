import 'dart:developer';

import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfViewers extends StatefulWidget {
  const PdfViewers({Key? key, required this.document}) : super(key: key);
  final String document;
  @override
  State<PdfViewers> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PdfViewers> {
  @override
  void initState() {
    super.initState();
    log(widget.document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.h),
        child: Column(
          children: [
            _topAppBar(),
            SizedBox(
              height: 40.h,
            ),
            Expanded(
              child: PdfViewer.openAsset(widget.document),
            ),
          ],
        ),
      ),
    );
  }
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
