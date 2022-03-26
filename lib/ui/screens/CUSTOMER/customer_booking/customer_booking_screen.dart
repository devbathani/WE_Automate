import 'package:antonx_flutter_template/core/constants/colors.dart';
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/constants/strings.dart';
import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/core/models/app-user.dart';
import 'package:antonx_flutter_template/core/models/schedule_info.dart';
import 'package:antonx_flutter_template/core/models/service.dart';
import 'package:antonx_flutter_template/core/models/slot_data_model.dart';
import 'package:antonx_flutter_template/core/models/time_slot.dart';
import 'package:antonx_flutter_template/core/services/notification-service.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/image_container.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/rectangular_button.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/slot_booking/export_slot_components.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/customer_booking_screen_view_model.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/customer_booking/order_list.dart';
import 'package:antonx_flutter_template/ui/screens/CUSTOMER/root/root_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/services/database_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../locator.dart';

class Category {
  String? label;
  bool? isSelected;
  Category({this.label, this.isSelected = false});
}

class CustomerBookingScreen extends StatefulWidget {
  final isBottom;
  SErvice model;
  String providerId;
  String serviceId;
  String price;

  CustomerBookingScreen({
    this.isBottom = false,
    required this.model,
    this.providerId = '',
    this.serviceId = '',
    this.price = '0.0',
  });
  @override
  _CustomerBookingScreenScreenState createState() => _CustomerBookingScreenScreenState();
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
  String currentMonth = DateFormat.yMMM().format(DateTime.now()); // DateFormat.yMMM().format(DateTime(2019, 2, 3));
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

  ValueNotifier<bool> updateTimeSlot = ValueNotifier<bool>(false);
  List<TimeSlotData> timeSlot = [];
  int selectedSchedule = -1;
  int selectedTimeslot = -1;
  DateTime? bookDate;

  //TODO: add these for user
  // after confirm
  List bookedSlots = ["2022-03-23 16:00:00.000", "2022-03-26 10:50:00.000", "2022-03-29 09:30:00.000"];

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

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  Widget eventIcon = Container(
    height: 100.h,
    width: 100.w,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.blue, width: 1.4),
    ),
  );
  bool isLoading = false;

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

  final _localStorageService = locator<LocalStorageService>();
  final _dbService = locator<DatabaseService>();

  bool paySucess = false;

  @override
  void initState() {
    getToken();

    setupPay();

    categories.add(Category(label: "ONE TIME"));
    categories.add(Category(label: "WEEKLY"));
    categories.add(Category(label: "BI WEEKLY"));
    categories.add(Category(label: "MONTHLY"));

    super.initState();
  }

  void setupPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
      // Do something when payment succeeds
      print("Payment Done");
      paySucess = true;
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      // Do something when payment fails
      print("Payment Fail");
      paySucess = false;
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
      // Do something when an external wallet is selected
      paySucess = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
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
                      children: [serviceDetails(widget.model, model)],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  serviceDetails(SErvice model, CustomerBookingScreenViewModel customermodel) {
    return FutureBuilder<ScheduleInfoData?>(
      future: _dbService.getProviderSlots(widget.providerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 4,
              ),
            ),
          );
        } else {
          if (snapshot.hasData) {
            ScheduleInfoData schData = snapshot.data!;
            onSelectDay(DateTime.now(), null, schData);

            final List<DateTime>? offdates = schData.offdays;
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
                        style: bodyTextStyle.copyWith(fontSize: 18.sp, fontFamily: robottoFontTextStyle),
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
                              color: Colors.grey, fontSize: 15.sp, fontFamily: robottoFontTextStyle),
                        ),
                      ),
                    ],
                  ),
                  SfDateRangePicker(
                    enablePastDates: false,
                    minDate: today.subtract(const Duration(days: 0)),
                    maxDate: today.add(const Duration(days: 60)),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      blackoutDates: offdates,
                    ),
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      //timeSlot = schData.selectedTimeSlot();

                      onSelectDay(null, args, schData);
                    },
                    selectableDayPredicate: (DateTime dateTime) {
                      print("selectableDayPredicate: ${dateTime}");
                      return schData.workingWeeks.contains(dateTime.weekday);
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ValueListenableBuilder(
                    valueListenable: updateTimeSlot,
                    builder: (BuildContext context, value, Widget? child) {
                      return Wrap(
                        spacing: 5.0,
                        runSpacing: 3.0,
                        children: List<Widget>.generate(timeSlot.length, (index) {
                          //int key = timeSlot.keys.toList()[index];
                          DateTime data = timeSlot[index].time;
                          int schID = timeSlot[index].scheduleId;
                          int end = schData.schedule[schID].breakDuration + schData.schedule[schID].gapDuration;
                          String label =
                              "${DateFormat("HH:mm a").format(data)} - ${DateFormat("HH:mm a").format(data.add(Duration(minutes: end)))}";

                          bool canSelect = timeSlot[index].status == null ||
                              timeSlot[index].status == "" ||
                              timeSlot[index].status == "reject";

                          return ChoiceChip(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade500, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelPadding: EdgeInsets.all(2.0),
                            onSelected: (val) {
                              if (!canSelect) return;

                              timeSlot[index].selected = val;
                              selectedSchedule = schID;
                              selectedTimeslot = timeSlot[index].id;

                              print("selectedTimeslot $selectedTimeslot");

                              updateTimeSlot.value = !updateTimeSlot.value;
                            },
                            disabledColor: Colors.white,
                            backgroundColor: Colors.white,
                            selectedColor: Colors.green,
                            label: Text(
                              label,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(!canSelect ? 0.5 : 1),
                                  decoration: !canSelect ? TextDecoration.lineThrough : TextDecoration.none),
                            ),
                            selected: index == selectedTimeslot && selectedSchedule == schID,
                          );
                        }),
                      );
                    },
                  ),
                  SizedBox(height: 50.h),
                  RoundedRaisedButton(
                    buttonText: "Book Service".toUpperCase(),
                    textColor: primaryColor,
                    color: Colors.white,
                    onPressed: () async {
                      var options = {
                        'key': "rzp_test_4qGWB3dkcHmRZT",
                        'amount': double.parse(widget.price) * 100,
                        'name': 'Dev Bathani',
                        'description': 'service payment',
                        'timeout': 300,
                        'prefill': {'contact': '7202897611', 'email': 'bathanid888@gmail.com'}
                      };
                      await _razorpay.open(options);

                      if (paySucess) if (selectedSchedule != -1 && selectedTimeslot != -1) {
                        _dbService
                            .bookOrder(widget.providerId, _localStorageService.accessTokenCustomer, selectedSchedule,
                                selectedTimeslot, widget.serviceId, bookDate!)
                            .then((value) {
                          if (value) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (BuildContext context) => OrderList()));
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 40.h),
                  RoundedRaisedButton(
                    buttonText: "Pay In person".toUpperCase(),
                    textColor: primaryColor,
                    color: Colors.white,
                    onPressed: () async {
                      var options = {
                        'key': "rzp_test_4qGWB3dkcHmRZT",
                        'amount': double.parse(widget.price) * 100,
                        'name': 'Dev Bathani',
                        'description': 'service payment',
                        'timeout': 300,
                        'prefill': {'contact': '7202897611', 'email': 'bathanid888@gmail.com'}
                      };
                      // await _razorpay.open(options);

                      if (paySucess) if (selectedSchedule != -1 && selectedTimeslot != -1) {
                        _dbService
                            .bookOrder(widget.providerId, _localStorageService.accessTokenCustomer, selectedSchedule,
                                selectedTimeslot, widget.serviceId, bookDate!)
                            .then((value) {
                          if (value) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (BuildContext context) => OrderList()));
                          }
                        });
                      }
                    },
                  ),
                  SizedBox(height: 88.h),
                ],
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Text("No Data Found"),
              ),
            );
          }
        }
      },
    );
  }

  void onSelectDay(DateTime? initDate, DateRangePickerSelectionChangedArgs? args, ScheduleInfoData schData) {
    if (initDate == null)
      bookDate = args!.value as DateTime;
    else
      bookDate = initDate;

    int weekday = bookDate!.weekday;
    timeSlot.clear();
    selectedSchedule = -1;
    selectedTimeslot = -1;

    for (int i = 0; i < schData.schedule.length; i++) {
      SlotDataModel data = schData.schedule[i];
      if (data.workingDays.contains(weekday)) {
        timeSlot.addAll(schData.slots.where((element) => element.scheduleId == i));
      }
    }

    //timeSlot.where((element) => element.scheduleId)

    updateTimeSlot.value = !updateTimeSlot.value;
    print(timeSlot);
  }
}
