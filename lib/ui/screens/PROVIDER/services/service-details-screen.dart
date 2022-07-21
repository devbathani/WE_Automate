import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final SErvice sErvice;
  const ServiceDetailsScreen({Key? key, required this.sErvice})
      : super(key: key);

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.sErvice.imgUrl!,
              child: Container(
                height: 450.h,
                width: double.infinity,
                child: Image.asset(
                  widget.sErvice.imgUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                widget.sErvice.title!,
                style: headingTextStyle,
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Category : ",
                    style: bodyTextStyle,
                  ),
                  Text(
                    widget.sErvice.category!,
                    style: bodyTextStyle,
                  ),
                  Spacer(),
                  Text(
                    "Price : ",
                    style: bodyTextStyle,
                  ),
                  Text(
                    widget.sErvice.price!,
                    style: bodyTextStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                "Description : ",
                style: bodyTextStyle,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                widget.sErvice.description!,
                style: bodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
