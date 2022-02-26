import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/services/notification-service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/dailogs/request_failed_dailog.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/conversation/chat/customer-chat-screen.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class Category {
  String? label;
  bool? isSelected;
  Category({this.label, this.isSelected = false});
}

class CustomerBookingScreen extends StatefulWidget {
  final isBottom;
  SErvice model;

  CustomerBookingScreen({
    this.isBottom = false,
    required this.model,
  });
  @override
  _CustomerBookingScreenScreenState createState() =>
      _CustomerBookingScreenScreenState();
}

class _CustomerBookingScreenScreenState extends State<CustomerBookingScreen> {
  var sErvice;
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  DateTime currentDate = DateTime.now(); // DateTime(2019, 2, 3);
  DateTime currentDate2 = DateTime.now();
  NotificationsService notificationsService = NotificationsService();
  String currentMonth = DateFormat.yMMM().format(
      DateTime.now()); // DateFormat.yMMM().format(DateTime(2019, 2, 3));
  DateTime targetDateTime = DateTime.now(); //DateTime(2019, 2, 3);
  List<Category> categories = [];
  AppUser? appUser;
  DateTime bookingDates = DateTime.now();
  EventList<Event> markedDateMap = new EventList<Event>(events: {});
  Widget eventIcon = Container(
    height: 100.h,
    width: 100.w,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.blue, width: 1.4),
    ),
  );
  bool isLoading = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    categories.add(Category(label: "ONE TIME"));
    categories.add(Category(label: "WEEKLY"));
    categories.add(Category(label: "BI WEEKLY"));
    categories.add(Category(label: "MONTHLY"));

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('assets/static_assets/app_icon02.png');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: androidInitializationSettings, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(
      initSetttings,
    );
    Future.delayed(Duration(seconds: 4), () {
      isLoading = false;
      setState(() {});
    });

    super.initState();
  }

  showNotification(String title) async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin
        .show(0, 'Service Booked', title, platform,
            payload: 'Welcome to the Local Notification demo')
        .then((value) {
      print('Notification sent');
    });
  }

  bool isBooked = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CustomerBookingScreenViewModel(),
        child: Consumer<CustomerBookingScreenViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
                ////
                ///FAB
                ///
                backgroundColor: Colors.white,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Get.offAll(() => RootSCustomercreen(index: 2));
                  },
                  child: ImageContainer(
                    assets: "$assets/fab0.png",
                    height: 60.h,
                    width: 60.w,
                    fit: BoxFit.cover,
                  ),
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Column(
                      children: [
                        _topAppBar(),
                        searchTextField(),
                        calendar(widget.model, model),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  calendar(SErvice model, CustomerBookingScreenViewModel customermodel) {
    return //calendar body
        Padding(
      padding: const EdgeInsets.only(
        left: 36,
        right: 36,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Book your Service",
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
          Material(
            elevation: 1,
            child: Container(
              // margin: EdgeInsets.only(top: 30),
              child: Transform.scale(
                scale: 0.9,
                child: CalendarCarousel<Event>(
                  // markedDatesMap: markedDateMap,
                  customGridViewPhysics: BouncingScrollPhysics(),
                  onDayPressed: (date, events) {
                    setState(() {
                      bookingDates = date;
                      print(bookingDates);
                    });
                  },
                  headerTextStyle: headingTextStyle.copyWith(
                    fontFamily: robottoFontTextStyle,
                    fontSize: 13.sp,
                  ),

                  pageSnapping: true,
                  nextDaysTextStyle: TextStyle(color: Colors.white),
                  prevDaysTextStyle: TextStyle(color: Colors.white),
                  leftButtonIcon: Icon(Icons.arrow_back_ios, size: 16),
                  rightButtonIcon: Icon(Icons.arrow_forward_ios, size: 16),
                  showOnlyCurrentMonthDate: false,
                  todayButtonColor: Colors.yellow,
                  selectedDayButtonColor: Colors.orange,
                  markedDateMoreShowTotal: true,
                  showWeekDays: true,
                  firstDayOfWeek: 0,
                  weekFormat: false,

                  showHeader: true,
                  height: 340.h,
                  selectedDateTime: bookingDates,
                  targetDateTime: bookingDates, // targetDateTime,
                  showIconBehindDayText: true,
                  markedDateShowIcon: true,
                  markedDateIconMaxShown: 2,
                  weekdayTextStyle: bodyTextStyle.copyWith(
                      fontSize: 15.sp, color: Color(0xff191919)),
                  //            daysTextStyle: mediumRegularTextStyle,
                  weekendTextStyle: bodyTextStyle.copyWith(
                      fontSize: 15.sp, color: Color(0xff191919)),
                  selectedDayTextStyle: bodyTextStyle.copyWith(
                      color: Colors.white, fontSize: 15.sp),
                  markedDateIconBuilder: (event) {
                    return event.icon ?? Icon(Icons.help_outline);
                  },
                  minSelectedDate: bookingDates.subtract(Duration(days: 360)),
                  maxSelectedDate: bookingDates.add(Duration(days: 360)),
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
                  customDayBuilder: (
                    isSelectable,
                    index,
                    isSelectedDay,
                    isToday,
                    isPrevMonthDay,
                    textStyle,
                    isNextMonthDay,
                    isThisMonthDay,
                    day,
                  ) {
                    return isPrevMonthDay
                        ? Container()
                        : isNextMonthDay
                            ? Container()
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    "${day.day}",
                                    style: bodyTextStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontFamily: robottoFontTextStyle,
                                    ),
                                  ),
                                ),
                              );
                  },
                  onDayLongPressed: (DateTime date) {
                    //                Get.to(GiftScreen());
                  },
                ),
              ),
            ),
          ),
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
              )),
          SizedBox(height: 50.h),
          Row(
            children: [
              Text(
                "Service Detials",
                style: bodyTextStyle.copyWith(
                  fontSize: 18.sp,
                  fontFamily: robottoFontTextStyle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Stack(
            children: [
              Container(
                height: 230.h,
                width: 350.w,
                child: FadeInImage.assetNetwork(
                  placeholder: '$assets/placeholder.jpeg',
                  image: model.imgUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: model.availability == "Available"
                        ? Color(0XFF0ACF83)
                        : model.availability == "Available soon"
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
                        double.parse(model.location!.lat!),
                        double.parse(model.location!.long!),
                      );
                    } catch (e) {
                      print("Exception ====> MAP LAUNCHER==> $e");
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
                        shape: BoxShape.circle, color: Colors.white),
                    child: Icon(Icons.location_on, size: 18),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Flexible(
                            child: Text(
                              "Desc: ${model.description}",
                              softWrap: true,
                              style: headingTextStyle.copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Price: ${model.price} CAD",
                          // "Price: 50 CAD",
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
                                  providerId: model.providerId,
                                  providerName: model.providerName,
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
          SizedBox(height: 50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !isBooked
                  ? Container(
                      height: 26.h,
                      width: 172.w,
                      child: RoundedRaisedButton(
                        buttonText: "Book Service".toUpperCase(),
                        textColor: primaryColor,
                        color: Colors.white,
                        onPressed: () async {
                          model.isBooked = 'Yes';
                          model.serviceBookingDate =
                              Timestamp.fromDate(bookingDates);
                          model.isConfirmed = 'No';
                          print(model.serviceBookingDate);
                          print(":");
                          // Get.back();
                          isLoading = true;

                          setState(() {});
                          Future.delayed(
                            Duration(seconds: 3),
                            () async {
                              isLoading = false;
                              isBooked = true;
                              await customermodel.updatedBookingStatus(model);
                              showNotification(model.title!);
                              print("Notification Sent ======>");
                              setState(() {});

                              Get.back(result: model);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "The service has been booked successfully",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 26.h,
                      width: 172.w,
                      child: RoundedRaisedButton(
                        buttonText: "Continue Shopping".toUpperCase(),
                        textColor: primaryColor,
                        color: Colors.white,
                        onPressed: () {
                          print(":");
                          Get.back();
                        },
                      ),
                    ),
            ],
          ),
          SizedBox(height: 88.h),
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
          border: Border.all(
            color: Colors.grey.withOpacity(1),
            width: 0.6,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              Text(
                "${category.label}",
                style: bodyTextStyle.copyWith(
                  fontSize: 10.sp,
                  color: category.isSelected!
                      ? Colors.white
                      : Colors.grey.withOpacity(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 45.h, bottom: 26, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 52.h,
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2.w)),
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: bodyTextStyle.copyWith(
                    fontSize: 15.sp,
                    fontFamily: robottoFontTextStyle,
                    color: Colors.grey.withOpacity(1)),
                hintText: "Search all services",
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 29.h,
                  maxWidth: 36.w,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 11.w),
                  child: ImageContainer(
                    assets: "$assets/pin.png",
                    height: 29.h,
                    width: 36.w,
                    fit: BoxFit.contain,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 18,
                  top: 2.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _topAppBar() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 17.0),
            child: Text(
              "Search Services  and Products",
              style: subHeadingTextstyle.copyWith(
                  fontSize: 13.sp,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
