import 'package:antonx_flutter_template/ui/screens/CUSTOMER/mybookings/myBookings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../custom_widgets/dailogs/request_failed_dailog.dart';
import '../conversation/chat/customer-chat-screen.dart';
import '../customer_booking/customer_booking_screen.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => MyBookingViewModel(),
        child: Consumer<MyBookingViewModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    "My Bookings",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  height: 650,
                  width: Get.width,
                  child: ListView.builder(
                    itemCount: model.services.length,
                    itemBuilder: (context, index) {
                      return model.services[index].isBooked == 'Yes'
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.h,
                              ),
                              child: Container(
                                height: 265.h,
                                width: 400.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.services[index].title!,
                                      style: subBodyTextStyle.copyWith(
                                          fontSize: 17.5.sp),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => CustomerBookingScreen(
                                                model: model.services[index],
                                                providerId: model
                                                        .services[index]
                                                        .providerId ??
                                                    "",
                                                serviceId:
                                                    model.services[index].id ??
                                                        "",
                                                price: model.services[index]
                                                        .price ??
                                                    "",
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 230.h,
                                            width: 350.w,
                                            child: Image.asset(
                                              model.services[index].imgUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10.h,
                                          left: 10.w,
                                          child: Container(
                                            height: 24.h,
                                            width: 24.w,
                                            decoration: BoxDecoration(
                                              color: model.services[index]
                                                          .availability ==
                                                      "Available"
                                                  ? Color(0XFF0ACF83)
                                                  : model.services[index]
                                                              .availability ==
                                                          "Available soon"
                                                      ? Color(0XFFFBF90A)
                                                      : Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10.h,
                                          right: 10.w,
                                          child: GestureDetector(
                                            onTap: () {
                                              print("Launchig maps");
                                              try {
                                                MapsLauncher.launchCoordinates(
                                                  double.parse(model
                                                      .services[index]
                                                      .location!
                                                      .lat!),
                                                  double.parse(model
                                                      .services[index]
                                                      .location!
                                                      .long!),
                                                );
                                              } catch (e) {
                                                print(
                                                    "Exception ====> MAP LAUNCHER==> $e");
                                                Get.dialog(
                                                  RequestFailedDialog(
                                                    errorMessage: e.toString(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 36.h,
                                              width: 36.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white),
                                              child: Icon(Icons.location_on,
                                                  size: 18),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            height: 90.h,
                                            width: 350.w,
                                            color: Colors.black26,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 9.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Flexible(
                                                      child: Text(
                                                        "Desc: ${model.services[index].description}",
                                                        softWrap: true,
                                                        style: headingTextStyle
                                                            .copyWith(
                                                          fontSize: 12.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    "Price: ${model.services[index].price} usd",
                                                    // "Price: 50 usd",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: headingTextStyle
                                                        .copyWith(
                                                      fontSize: 12.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Container(
                                                    height: 30.h,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.to(
                                                          () =>
                                                              CustomerChatScreen(
                                                            providerId: model
                                                                .services[index]
                                                                .providerId,
                                                            providerName: model
                                                                .services[index]
                                                                .providerName,
                                                          ),
                                                        );
                                                      },
                                                      child: Text("Message"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
