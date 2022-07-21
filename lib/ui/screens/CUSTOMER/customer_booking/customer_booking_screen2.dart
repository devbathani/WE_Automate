import 'dart:convert';

import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/services/notification-service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/slot_booking/export_slot_components.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  int isSelected = -1;
  List availableSlots = [];
  List notAvailableDays = [];
  int selectedWeekDay = 1;
  bool isDateSelected = false;
  String? bookedTime;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  DateTime today = DateTime.now();
  DateTime bookingDateTime = DateTime.now();
  bool isBooked = false;

  //TODO: add these for user
  // after confirm
  List bookedSlots = [
    "2022-03-23 16:00:00.000",
    "2022-03-26 10:50:00.000",
    "2022-03-29 09:30:00.000"
  ];

  //
  List availableDays = [1, 2, 3, 4, 5, 6];
  List finalSlots = [
    [
      '16:0',
      '18:30',
      50,
      10,
      [1, 3, 5]
    ],
    [
      '9:30',
      '11:30',
      40,
      0,
      [1, 3, 5, 6, 2]
    ]
  ];

  List notAvaliableDate = ['2022-03-25 00:00:00.000'];

  List notAvailableSlots = [
    "2022-03-22 09:30:00.000",
    "2022-03-30 16:00:00.000",
  ];

  ///********************** */

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

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late var _razorpay;
  var amountController = TextEditingController();
  final firestoreRef = FirebaseFirestore.instance;
  String fcmToken = '';
  void getToken() async {
    final tokens = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = tokens!;
    });
    print('Your FCM TOKEN IS ::::::::::::>' + tokens!);
  }

  @override
  void initState() {
    getToken();

    categories.add(Category(label: "ONE TIME"));
    categories.add(Category(label: "WEEKLY"));
    categories.add(Category(label: "BI WEEKLY"));
    categories.add(Category(label: "MONTHLY"));

    listenFCM();
    loadFCM();
    requestPermission();

    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(event);
    // });

    final AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true);
    print(channel);
    FirebaseMessaging.instance.getInitialMessage();
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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

    List daystoBlackout = [1, 2, 3, 4, 5, 6, 7];
    notAvailableDays =
        daystoBlackout.where((item) => !availableDays.contains(item)).toList();
    //TODO : fetch list of available days from provider model and store in availableDays variable
    // TODO : fetch list of final slots from provider model and store in finalSlots variable
    // TODO : fetch  list of booked slots
    // TODO : notAvailableSlots from provider

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment Done");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
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
        .then((value) {});
  }

  sendPushNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
    };

    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAEBlwyYw:APA91bF_EAZodCwGiYANWguNUTIDdM30zkIsJTru0PG5hB4Sk3NynXrVJirhzpiOLCveklQEChRzmXW8WEpP82B8bL_tJyt94btQteQFuqkrVrpVQw45_DuiYIt4OkyGxKpx0r3lr6-v'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': 'Accept or decline the service !!'
            },
            'priority': 'high',
            'data': data,
            'to': '$token'
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              "mychanel",
              "my chanel",
              "my description",
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      final channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications',
        'This channel is used for important notifications.',

        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  covertIntoDateTime(dynamic element) {
    TimeOfDay startTime1 = TimeOfDay(
        hour: int.parse(element[0].toString().split(':')[0]),
        minute: int.parse(element[0].toString().split(':')[1]));
    TimeOfDay endTime1 = TimeOfDay(
        hour: int.parse(element[1].toString().split(':')[0]),
        minute: int.parse(element[1].toString().split(':')[1]));

    final now = DateTime.now();
    startTime = DateTime(
        now.year, now.month, now.day, startTime1.hour, startTime1.minute);
    endTime =
        DateTime(now.year, now.month, now.day, endTime1.hour, endTime1.minute);
    setState(() {});
  }

  slotmaker(List slotForTheDay) {
    slotForTheDay.forEach((element) {
      int gap = element[3];
      int duration = element[2];
      covertIntoDateTime(element);
      DateTime to = startTime;

      while (endTime.compareTo(startTime) == 1) {
        to = startTime.add(Duration(minutes: duration));
        availableSlots.add(
            '${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(to)}');
        startTime = to.add(Duration(minutes: gap));
        if (endTime.compareTo(startTime) == 0) {
          break;
        }
      }
    });
  }

  slotsToShow(int selectedWeekDay) {
    availableSlots = [];
    List slotsforTheDay = finalSlots.where((element) {
      List days = element[4];
      if (days.contains(selectedWeekDay)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    slotmaker(slotsforTheDay);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      isSelected = -1;
      DateTime value = args.value as DateTime;
      print(value);
      bookingDateTime = value;
      availableSlots = [];
      slotsToShow(value.weekday);
    }
    setState(() {});
  }

  bool checkIfBooked(String slotTime) {
    String label = slotTime.toString().split('-')[0];
    int hour = int.parse(label.split(':')[0]);
    int min = int.parse(label.split(' ')[0].split(':')[1]);
    String amPm = label.split(' ')[1];
    if (amPm == 'PM') {
      hour += 12;
    }
    DateTime checkTime = DateTime(bookingDateTime.year, bookingDateTime.month,
        bookingDateTime.day, hour, min);
    if (bookedSlots.contains(checkTime.toString()) ||
        notAvailableSlots.contains(checkTime.toString())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CustomerBookingScreenViewModel(),
        child: Consumer<CustomerBookingScreenViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
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
                        //TODO : review the functionalities of this calender widget and why it was in this screen
                        // calendar(widget.model, model),
                        serviceDetails(widget.model, model)
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  serviceDetails(SErvice model, CustomerBookingScreenViewModel customermodel) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Book your Service",
                style: bodyTextStyle.copyWith(
                    fontSize: 18.sp, fontFamily: robottoFontTextStyle),
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Text(
                  "Choose your appointment date",
                  style: bodyTextStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 15.sp,
                      fontFamily: robottoFontTextStyle),
                ),
              ),
            ],
          ),
          SfDateRangePicker(
            enablePastDates: false,
            minDate: today.subtract(const Duration(days: 60)),
            maxDate: today.add(const Duration(days: 240)),
            monthViewSettings: const DateRangePickerMonthViewSettings(
              firstDayOfWeek: 1,
            ),
            onSelectionChanged: _onSelectionChanged,
            selectableDayPredicate: (DateTime dateTime) {
              if (notAvailableDays.contains(dateTime.weekday) ||
                  notAvaliableDate.contains(dateTime.toString())) {
                return false;
              }
              return true;
            },
          ),
          slots(),
          SizedBox(
            height: 20.h,
          ),
          // Row(
          //   children: [
          //     Text(
          //       "Service Details",
          //       style: bodyTextStyle.copyWith(
          //         fontSize: 18.sp,
          //         fontFamily: robottoFontTextStyle,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 15.h,
          // ),
          // Stack(
          //   children: [
          //     Container(
          //       height: 230.h,
          //       width: 350.w,
          //       child: FadeInImage.assetNetwork(
          //         placeholder: '$assets/placeholder.jpeg',
          //         image: model.imgUrl!,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //     Positioned(
          //       top: 10.h,
          //       left: 10.w,
          //       child: Container(
          //         height: 24.h,
          //         width: 24.w,
          //         decoration: BoxDecoration(
          //           color: model.availability == "Available"
          //               ? Color(0XFF0ACF83)
          //               : model.availability == "Available soon"
          //                   ? Color(0XFFFBF90A)
          //                   : Colors.red,
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       top: 10.h,
          //       right: 10.w,
          //       child: GestureDetector(
          //         onTap: () {
          //           print("Launchig maps");
          //           try {
          //             MapsLauncher.launchCoordinates(
          //               double.parse(model.location!.lat!),
          //               double.parse(model.location!.long!),
          //             );
          //           } catch (e) {
          //             print("Exception ====> MAP LAUNCHER==> $e");
          //             Get.dialog(
          //               RequestFailedDialog(
          //                 errorMessage: e.toString(),
          //               ),
          //             );
          //           }
          //         },
          //         child: Container(
          //           height: 36.h,
          //           width: 36.w,
          //           decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          //           child: Icon(Icons.location_on, size: 18),
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       bottom: 0,
          //       child: Container(
          //         height: 90.h,
          //         width: 350.w,
          //         color: Colors.black26,
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: 10.w,
          //             vertical: 9.h,
          //           ),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               SingleChildScrollView(
          //                 scrollDirection: Axis.horizontal,
          //                 child: Flexible(
          //                   child: Text(
          //                     "Desc: ${model.description}",
          //                     softWrap: true,
          //                     style: headingTextStyle.copyWith(
          //                       fontSize: 12.sp,
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(height: 4.h),
          //               Text(
          //                 "Price: ${model.price} CAD",
          //                 // "Price: 50 CAD",
          //                 overflow: TextOverflow.ellipsis,
          //                 style: headingTextStyle.copyWith(
          //                   fontSize: 12.sp,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //               SizedBox(height: 10.h),
          //               Container(
          //                 height: 30.h,
          //                 child: ElevatedButton(
          //                   onPressed: () {
          //                     Get.to(
          //                       () => CustomerChatScreen(
          //                         providerId: model.providerId,
          //                         providerName: model.providerName,
          //                       ),
          //                     );
          //                   },
          //                   child: Text("Message"),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

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
                          if (isSelected != -1) {
                            int hour = int.parse(bookedTime!.split(':')[0]);
                            int min = int.parse(
                                bookedTime!.split(' ')[0].split(':')[1]);
                            String amPm = bookedTime!.split(' ')[1];
                            if (amPm == 'PM') {
                              hour += 12;
                            }
                            bookingDates = DateTime(
                                bookingDateTime.year,
                                bookingDateTime.month,
                                bookingDateTime.day,
                                hour,
                                min);
                            // TODO: send api req for booking slot and append this timing bookedSlots for user
                            model.isBooked = 'Yes';
                            // TODO : add slot here
                            model.serviceBookingDate =
                                Timestamp.fromDate(bookingDates);
                            model.isConfirmed = 'No';

                            print(model.serviceBookingDate);
                            print(":");
                            // Get.back();
                            isLoading = true;
                            var price = double.parse(model.price!);
                            setState(() {});
                            Future.delayed(
                              Duration(seconds: 3),
                              () async {
                                isLoading = false;
                                isBooked = true;
                                var options = {
                                  'key': "rzp_test_4qGWB3dkcHmRZT",
                                  'amount': price * 100,
                                  'name': 'Dev Bathani',
                                  'description': 'service payment',
                                  'timeout': 300,
                                  'prefill': {
                                    'contact': '7202897611',
                                    'email': 'bathanid888@gmail.com'
                                  }
                                };
                                await _razorpay.open(options);

                                print(model.fcmToken);
                                sendPushNotification(
                                  'Confirm ' + model.title! + '?',
                                  model.fcmToken!,
                                );
                                model.fcmToken = fcmToken;
                                showNotification(model.title!);

                                print("Notification Sent ======>");
                                await customermodel.updatedBookingStatus(model);
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
                          }
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

  // calendar(SErvice model, CustomerBookingScreenViewModel customermodel) {
  //   return //calendar body
  //       Padding(
  //     padding: const EdgeInsets.only(
  //       left: 36,
  //       right: 36,
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Text(
  //               "Book your Service",
  //               style: bodyTextStyle.copyWith(fontSize: 18.sp, fontFamily: robottoFontTextStyle),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12.h),
  //         Row(
  //           children: [
  //             Text(
  //               "Choose your appointment slot",
  //               style: bodyTextStyle.copyWith(color: Colors.grey, fontSize: 11.sp, fontFamily: robottoFontTextStyle),
  //             ),
  //           ],
  //         ),
  //         Material(
  //           elevation: 1,
  //           child: Container(
  //             // margin: EdgeInsets.only(top: 30),
  //             child: Transform.scale(
  //               scale: 0.9,
  //               child: CalendarCarousel<Event>(
  //                 // markedDatesMap: markedDateMap,
  //                 customGridViewPhysics: BouncingScrollPhysics(),
  //                 onDayPressed: (date, events) {
  //                   setState(() {
  //                     bookingDates = date;
  //                     print(bookingDates);
  //                   });
  //                 },
  //                 headerTextStyle: headingTextStyle.copyWith(
  //                   fontFamily: robottoFontTextStyle,
  //                   fontSize: 13.sp,
  //                 ),
  //                 pageSnapping: true,
  //                 nextDaysTextStyle: TextStyle(color: Colors.white),
  //                 prevDaysTextStyle: TextStyle(color: Colors.white),
  //                 leftButtonIcon: Icon(Icons.arrow_back_ios, size: 16),
  //                 rightButtonIcon: Icon(Icons.arrow_forward_ios, size: 16),
  //                 showOnlyCurrentMonthDate: false,
  //                 todayButtonColor: Colors.yellow,
  //                 selectedDayButtonColor: Colors.orange,
  //                 markedDateMoreShowTotal: true,
  //                 showWeekDays: true,
  //                 firstDayOfWeek: 0,
  //                 weekFormat: false,
  //                 showHeader: true,
  //                 height: 340.h,
  //                 selectedDateTime: bookingDates,
  //                 targetDateTime: bookingDates, // targetDateTime,
  //                 showIconBehindDayText: true,
  //                 markedDateShowIcon: true,
  //                 markedDateIconMaxShown: 2,
  //                 weekdayTextStyle: bodyTextStyle.copyWith(fontSize: 15.sp, color: Color(0xff191919)),
  //                 //            daysTextStyle: mediumRegularTextStyle,
  //                 weekendTextStyle: bodyTextStyle.copyWith(fontSize: 15.sp, color: Color(0xff191919)),
  //                 selectedDayTextStyle: bodyTextStyle.copyWith(color: Colors.white, fontSize: 15.sp),
  //                 markedDateIconBuilder: (event) {
  //                   return event.icon ?? Icon(Icons.help_outline);
  //                 },
  //                 minSelectedDate: bookingDates.subtract(Duration(days: 360)),
  //                 maxSelectedDate: bookingDates.add(Duration(days: 360)),
  //                 onCalendarChanged: (DateTime date) {
  //                   // this.setState(() {
  //                   //   print('hello');
  //                   //   model.targetDateTime = date;
  //                   //   model.currentMonth =
  //                   //       DateFormat.yMMM().format(model.targetDateTime);
  //                   // });
  //                 },
  //                 customWeekDayBuilder: (weekday, weekdayName) {
  //                   return Text(
  //                     "$weekdayName",
  //                   );
  //                 },
  //                 customDayBuilder: (
  //                   isSelectable,
  //                   index,
  //                   isSelectedDay,
  //                   isToday,
  //                   isPrevMonthDay,
  //                   textStyle,
  //                   isNextMonthDay,
  //                   isThisMonthDay,
  //                   day,
  //                 ) {
  //                   return isPrevMonthDay
  //                       ? Container()
  //                       : isNextMonthDay
  //                           ? Container()
  //                           : Container(
  //                               decoration: BoxDecoration(
  //                                 shape: BoxShape.circle,
  //                                 color: Colors.grey.withOpacity(0.5),
  //                               ),
  //                               child: Center(
  //                                 child: Text(
  //                                   "${day.day}",
  //                                   style: bodyTextStyle.copyWith(
  //                                     fontSize: 12.sp,
  //                                     fontFamily: robottoFontTextStyle,
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                 },
  //                 onDayLongPressed: (DateTime date) {
  //                   //                Get.to(GiftScreen());
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 12.h),
  //         Row(
  //           children: [
  //             Text(
  //               "How often would you like the service?",
  //               style: bodyTextStyle.copyWith(color: Colors.black45, fontSize: 13.sp, fontFamily: robottoFontTextStyle),
  //             )
  //           ],
  //         ),
  //         SizedBox(height: 12.h),
  //         Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: List.generate(
  //               categories.length,
  //               (index) => tile(categories[index], () {
  //                 for (int i = 0; i < categories.length; i++) {
  //                   if (i == index) {
  //                     categories[i].isSelected = true;
  //                   } else {
  //                     categories[i].isSelected = false;
  //                   }
  //                 }
  //                 setState(() {});
  //               }),
  //             )),
  //         SizedBox(height: 50.h),
  //       ],
  //     ),
  //   );
  // }

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

  Widget slots() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Text(
                  "Available Slots",
                  style: bodyTextStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 15.sp,
                      fontFamily: robottoFontTextStyle),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 10.h,
                          width: 10.w,
                          color: Colors.orange,
                        ),
                        Text(" : Already Booked")
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10.h,
                          width: 10.w,
                          color: Colors.green,
                        ),
                        Text(" : Selected slot")
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10.h,
                          width: 10.w,
                          color: Colors.grey.shade400,
                        ),
                        Text(" : Available for booking")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          availableSlots.isEmpty
              ? const Center(
                  child: Card(
                      child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("No slots available for selected day"),
                )))
              : Wrap(
                  spacing: 8.w,
                  children: List.generate(
                    availableSlots.length,
                    (index) {
                      bool isNotAvailable =
                          checkIfBooked(availableSlots[index]);

                      return SlotChip(
                        text: availableSlots[index],
                        index: index,
                        isSelected: isSelected,
                        isBooked: isNotAvailable,
                        onTap: (value) {
                          setState(() {
                            isSelected = index;
                          });
                          bookedTime = availableSlots[index]
                              .toString()
                              .split('-')[0]
                              .toString();
                        },
                      );
                    },
                  )),
        ],
      ),
    );
  }
}
