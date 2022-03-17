import 'package:antonx_flutter_template/core/constants/text_styles.dart';
import 'package:antonx_flutter_template/ui/custom_widgets/slot_booking/export_slot_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SlotInfo extends StatefulWidget {
  const SlotInfo({Key? key}) : super(key: key);

  @override
  State<SlotInfo> createState() => _SlotInfoState();
}

class _SlotInfoState extends State<SlotInfo> {
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

  List notAvailableSlots = ["2022-03-22 09:30:00.000", "2022-03-28 10:10:00.000"];

  covertIntoDateTime(dynamic element) {
    TimeOfDay startTime1 = TimeOfDay(
        hour: int.parse(element[0].toString().split(':')[0]), minute: int.parse(element[0].toString().split(':')[1]));
    TimeOfDay endTime1 = TimeOfDay(
        hour: int.parse(element[1].toString().split(':')[0]), minute: int.parse(element[1].toString().split(':')[1]));

    final now = DateTime.now();
    startTime = DateTime(now.year, now.month, now.day, startTime1.hour, startTime1.minute);
    endTime = DateTime(now.year, now.month, now.day, endTime1.hour, endTime1.minute);
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
        availableSlots.add('${DateFormat('hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(to)}');
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
      bookingDateTime = value;
      availableSlots = [];
      slotsToShow(value.weekday);
    }
    setState(() {});
  }

  checkIfBooked(String slotTime) {
    String label = slotTime.toString().split('-')[0];
    int hour = int.parse(label.split(':')[0]);
    int min = int.parse(label.split(' ')[0].split(':')[1]);
    String amPm = label.split(' ')[1];
    if (amPm == 'PM') {
      hour += 12;
    }
    DateTime checkTime = DateTime(bookingDateTime.year, bookingDateTime.month, bookingDateTime.day, hour, min);
    if (bookedSlots.contains(checkTime.toString()) || notAvailableSlots.contains(checkTime.toString())) {
      isBooked = true;
    } else {
      isBooked = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    List daystoBlackout = [1, 2, 3, 4, 5, 6, 7];
    notAvailableDays = daystoBlackout.where((item) => !availableDays.contains(item)).toList();
    //TODO : fetch list of available days from provider model and store in availableDays variable
    // TODO : fetch list of final slots from provider model and store in finalSlots variable
    // TODO : fetch  list of booked slots
    // TODO : notAvailableSlots from provider
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book your slot"),
        backgroundColor: Colors.black,
      ),
      body: Column(
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
                  style: bodyTextStyle.copyWith(color: Colors.grey, fontSize: 15.sp, fontFamily: robottoFontTextStyle),
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
              if (notAvailableDays.contains(dateTime.weekday) || notAvaliableDate.contains(dateTime.toString())) {
                return false;
              }
              return true;
            },
          ),
          slots(),
          SizedBox(
            height: 20.h,
          ),
          confirmSlotBooking(),
        ],
      ),
    );
  }

  Padding confirmSlotBooking() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
          onPressed: () {
            if (isSelected != -1) {
              int hour = int.parse(bookedTime!.split(':')[0]);
              int min = int.parse(bookedTime!.split(' ')[0].split(':')[1]);
              String amPm = bookedTime!.split(' ')[1];
              if (amPm == 'PM') {
                hour += 12;
              }
              bookingDateTime = DateTime(bookingDateTime.year, bookingDateTime.month, bookingDateTime.day, hour, min);
              // TODO: send api req for booking slot and append this timing bookedSlots for user
              print(bookingDateTime);
            }
          },
          child: const Center(
            child: Text("Confirm Booking"),
          )),
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
                  style: bodyTextStyle.copyWith(color: Colors.grey, fontSize: 15.sp, fontFamily: robottoFontTextStyle),
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
                      checkIfBooked(availableSlots[index]);
                      return SlotChip(
                        text: availableSlots[index],
                        index: index,
                        isSelected: isSelected,
                        isBooked: isBooked,
                        onTap: (value) {
                          setState(() {
                            isSelected = index;
                          });
                          bookedTime = availableSlots[index].toString().split('-')[0].toString();
                        },
                      );
                    },
                  )),
        ],
      ),
    );
  }
}
