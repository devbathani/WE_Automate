import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/enums/view_state.dart';
import 'package:antonx_flutter_template/core/services/auth_service.dart';
import 'package:antonx_flutter_template/core/services/location_service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/conversation/chat/customer-chat-screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/booking/booking-view-model.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/conversation/conversation-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/root/root-provider-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/services/service-details-screen.dart';
import 'package:antonx_flutter_template/ui/screens/PROVIDER/webview/webview-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../../../../locator.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Category> categories = [];
  DateTime currentDate = DateTime.now(); // DateTime(2019, 2, 3);
  DateTime currentDate2 = DateTime.now(); // DateTime(2019, 2, 3);
  String currentMonth = DateFormat.yMMM().format(
      DateTime.now()); // DateFormat.yMMM().format(DateTime(2019, 2, 3));
  DateTime targetDateTime = DateTime.now(); //DateTime(2019, 2, 3);

  EventList<Event> markedDateMap = new EventList<Event>(events: {});
  Widget eventIcon = Container(
      height: 100.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 1.4)));
  @override
  void initState() {
    categories.add(Category(label: "ONE TIME"));
    categories.add(Category(label: "WEEKLY"));
    categories.add(Category(label: "BI WEEKLY"));
    categories.add(Category(label: "MONTHLY"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => BookingViewModel(),
        child: Consumer<BookingViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: model.state == ViewState.loading,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 28.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
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

                    ///avatar user one area
                    ///
                    avatarArea(),

                    buttonsArea(),

                    // ratings(),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),

                    calendarAndReviews(model),

                    // recent()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  avatarArea() {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        ImageContainer(
          assets: "$assets/avatar.png",
          height: 128.h,
          width: 128.w,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 17.h,
        ),
        Text(
          "Hair products".toUpperCase(),
          style: headingTextStyle.copyWith(
              fontSize: 13.sp, fontFamily: robottoFontTextStyle),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "Provider",
          style: bodyTextStyle.copyWith(
            fontSize: 36.sp,
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "${locator<LocationService>().address}".toUpperCase(),
          // "Toronto, CA".toUpperCase(),
          style: headingTextStyle.copyWith(
              fontSize: 13.sp, fontFamily: robottoFontTextStyle),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "${locator<AuthService>().providerProfile!.businessName!}"
              .toUpperCase(),
          style: headingTextStyle.copyWith(
              fontSize: 13.sp, fontFamily: robottoFontTextStyle),
        )
      ],
    );
  }

  buttonsArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24.h),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 24.h,
            width: 170.w,
            child: RoundedRaisedButton(
                buttonText: "WEBSITE",
                textColor: primaryColor,
                color: Colors.white,
                onPressed: () {
                  print(":");

                  Get.to(() => WebviewScreen());
                }),
          ),
        ]),
        SizedBox(height: 19.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "MESSAGE",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");

                    Get.to(() => ConversationScreen(isBottom: false));
                  }),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 26.h,
              width: 172.w,
              child: RoundedRaisedButton(
                  buttonText: "PRODUCTS",
                  color: Colors.white,
                  textColor: primaryColor,
                  onPressed: () {
                    print(":");
                    Get.offAll(() => RootProviderScreen(index: 1));
                  }),
            ),
          ],
        )
      ],
    );
  }

  ratings() {
    return Padding(
      padding: const EdgeInsets.only(top: 33, bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "RATING",
            style: headingTextStyle.copyWith(
                fontSize: 13, fontFamily: robottoFontTextStyle),
          ),
          SizedBox(width: 5.0.w),
          RatingBarIndicator(
            rating: 5, //2.75,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemPadding: EdgeInsets.only(right: 3.w),
            itemSize: 26.0,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }

  calendarAndReviews(BookingViewModel model) {
    final h = Get.height;
    final w = Get.width;
    return Padding(
      padding: EdgeInsets.only(
        left: 40.w,
        right: 40.w,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Provider All bookings",
                style: bodyTextStyle.copyWith(
                    fontSize: 18.sp, fontFamily: robottoFontTextStyle),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                "Choose your appointment slot",
                style: bodyTextStyle.copyWith(
                    color: Colors.grey,
                    fontSize: 11.sp,
                    fontFamily: robottoFontTextStyle),
              ),
            ],
          ),
          calendar(model),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                "How often would you like the service?",
                style: bodyTextStyle.copyWith(
                    color: Colors.black45,
                    fontSize: 13.sp,
                    fontFamily: robottoFontTextStyle),
              )
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              categories.length,
              (index) => tile(categories[index], () {
                for (int i = 0; i < categories.length; i++) {
                  if (i == index) {
                    categories[i].isSelected = true;
                  } else {
                    categories[i].isSelected = false;
                  }
                }

                setState(() {});
              }),
            ),
          ),
          SizedBox(height: 30.h),
          Column(
            children: List.generate(
              model.services.length,
              (index) {
                final list = model.services[index];
                return list.isBooked == 'Yes'
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        child: Container(
                          height: 320.h,
                          width: 400.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.title!,
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
                                        ServiceDetailsScreen(
                                          sErvice: list,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 230.h,
                                      width: 350.w,
                                      child: Hero(
                                        tag: list.imgUrl!,
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              '$assets/placeholder.jpeg',
                                          image: list.imgUrl!,
                                          fit: BoxFit.cover,
                                        ),
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
                                        color: list.availability == "Available"
                                            ? Color(0XFF0ACF83)
                                            : list.availability ==
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
                                            double.parse(model.services[index]
                                                .location!.lat!),
                                            double.parse(model.services[index]
                                                .location!.long!),
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
                                        child:
                                            Icon(Icons.location_on, size: 18),
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
                                              scrollDirection: Axis.horizontal,
                                              child: Flexible(
                                                child: Text(
                                                  "Desc: ${list.description}",
                                                  softWrap: true,
                                                  style:
                                                      headingTextStyle.copyWith(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "Price: ${list.price} usd",
                                              // "Price: 50 usd",
                                              overflow: TextOverflow.ellipsis,
                                              style: headingTextStyle.copyWith(
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
                                                    () => CustomerChatScreen(
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
                              SizedBox(
                                height: 20.h,
                              ),
                              list.isConfirmed == 'No'
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 30.h,
                                          width: 100.w,
                                          child: RoundedRaisedButton(
                                              buttonText: "Yes",
                                              textColor: primaryColor,
                                              color: Colors.white,
                                              onPressed: () async {
                                                list.isConfirmed = 'Yes';

                                                list.isBooked = 'Yes';

                                                await model
                                                    .updatedBookingStatus(list);
                                                print("Booking Confirmed");
                                                //Get.back();
                                                print(":");
                                              }),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                          height: 30.h,
                                          width: 100.w,
                                          child: RoundedRaisedButton(
                                            buttonText: "No",
                                            textColor: primaryColor,
                                            color: Colors.white,
                                            onPressed: () async {
                                              list.isConfirmed = 'No';
                                              list.isBooked = 'No';
                                              await model
                                                  .updatedBookingStatus(list);
                                              print("Booking Not Confirmed");
                                              //Get.back();
                                              print(":");
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  recent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Column(
              children: List.generate(
                  2,
                  (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Row(
                          children: [
                            ImageContainer(
                              fit: BoxFit.contain,
                              height: 64.w,
                              width: 64.h,
                              assets: "$assets/avatar01.png",
                            ),
                            SizedBox(width: 18.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Beth Williams",
                                  style: headingTextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 13.sp,
                                      fontFamily: robottoFontTextStyle),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "Booked Service (1)",
                                  style: bodyTextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 13.sp,
                                      fontFamily: robottoFontTextStyle),
                                )
                              ],
                            )
                          ],
                        ),
                      ))),
          SizedBox(
            height: 150.h,
          )
        ],
      ),
    );
  }

  tile(Category category, ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: category.isSelected! ? primaryColor : Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(1), width: 0.6),
          ),
          child: Center(
            child: Row(
              children: [
                Text("${category.label}",
                    style: bodyTextStyle.copyWith(
                        fontSize: 10.sp,
                        color: category.isSelected!
                            ? Colors.white
                            : Colors.grey.withOpacity(1))),
              ],
            ),
          )),
    );
  }

  calendar(BookingViewModel model) {
    return //calendar body
        Material(
      elevation: 1,
      child: Container(
        // margin: EdgeInsets.only(top: 30),
        child: Transform.scale(
          scale: 0.9,
          child: CalendarCarousel<Event>(
            markedDatesMap: markedDateMap,
            customGridViewPhysics: BouncingScrollPhysics(),
            onDayPressed: (date, events) async {
              this.setState(() => currentDate2 = date);
              await model.fetchDates(currentDate2);
            },
            headerTextStyle: headingTextStyle.copyWith(
              fontFamily: robottoFontTextStyle,
              fontSize: 13.sp,
            ),
            nextDaysTextStyle: TextStyle(color: Colors.white),
            prevDaysTextStyle: TextStyle(color: Colors.white),
            leftButtonIcon: Icon(Icons.arrow_back_ios, size: 16),
            rightButtonIcon: Icon(Icons.arrow_forward_ios, size: 16),
            showOnlyCurrentMonthDate: false,
            todayButtonColor: Colors.green,
            selectedDayButtonColor: Colors.yellow,
            markedDateMoreShowTotal: true,
            showWeekDays: true,
            firstDayOfWeek: 0,
            weekFormat: false,

            showHeader: true,
            height: 340.h,
            selectedDateTime: currentDate2,
            targetDateTime: targetDateTime,
            showIconBehindDayText: true,
            markedDateShowIcon: true,
            markedDateIconMaxShown: 2,
            weekdayTextStyle: bodyTextStyle.copyWith(
                fontSize: 15.sp, color: Color(0xff191919)),
            //            daysTextStyle: mediumRegularTextStyle,
            weekendTextStyle: bodyTextStyle.copyWith(
                fontSize: 15.sp, color: Color(0xff191919)),
            selectedDayTextStyle:
                bodyTextStyle.copyWith(color: Colors.white, fontSize: 15.sp),
            markedDateIconBuilder: (event) {
              return event.icon ?? Icon(Icons.help_outline);
            },
            minSelectedDate: currentDate.subtract(Duration(days: 360)),
            maxSelectedDate: currentDate.add(Duration(days: 360)),
            onCalendarChanged: (DateTime date) {
              // this.setState(() {
              //   print('hello');
              //   model.targetDateTime = date;
              //   model.currentMonth =
              //       DateFormat.yMMM().format(model.targetDateTime);
              // });
            },
            customWeekDayBuilder: (weekday, weekdayName) {
              return Text(
                "$weekdayName",
              );
            },
            customDayBuilder: (isSelectable,
                index,
                isSelectedDay,
                isToday,
                isPrevMonthDay,
                textStyle,
                isNextMonthDay,
                isThisMonthDay,
                day) {
              return isPrevMonthDay
                  ? Container()
                  : isNextMonthDay
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.5)),
                          child: Center(
                              child: Text(
                            "${day.day}",
                            style: bodyTextStyle.copyWith(
                                fontSize: 12.sp,
                                fontFamily: robottoFontTextStyle),
                          )),
                        );
            },
            onDayLongPressed: (DateTime date) {
              //                Get.to(GiftScreen());
            },
          ),
        ),
      ),
    );
  }
}
