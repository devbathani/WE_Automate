import 'package:antonx_flutter_template/ui/custom_widgets/slot_booking/export_slot_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlotSchedular extends StatefulWidget {
  const SlotSchedular({Key? key}) : super(key: key);

  @override
  State<SlotSchedular> createState() => _SlotSchedularState();
}

class _SlotSchedularState extends State<SlotSchedular> {
  List<Map<int, String>> days = [
    {1: 'Mon'},
    {2: 'Tue'},
    {3: 'Wed'},
    {4: 'Thur'},
    {5: 'Fri'},
    {6: 'Sat'},
    {7: 'Sun'},
  ];
  TimeOfDay? pickedTime = TimeOfDay.now();
  TimeOfDay? startTime = TimeOfDay.now();
  TimeOfDay? endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  int duration = 30;
  int gap = 0;
  List selectedRepeatDays = [];

  // TODO : varibales to be available for user
  List selectedDays = [];
  List finalSlots = [];
  List notAvaliableDate = [];
  List notAvailableSlots = ["2022-03-14 09:30:00.000", "2022-03-28 10:10:00.000"];

// format of finalSlots = [startTime, endTime, duration, gap, selectedRepeatDays];

  timePicker(BuildContext context) async {
    pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    pickedTime ??= TimeOfDay.now();
    return pickedTime;
  }

  cleaner() {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    notAvaliableDate.removeWhere((element) => yesterday.compareTo(DateTime.parse(element)) == 1);
    notAvailableSlots.removeWhere((element) => yesterday.compareTo(DateTime.parse(element)) == 1);
    print(notAvailableSlots);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  void initState() {
    super.initState();
    cleaner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "make slots",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, [finalSlots, selectedDays]);
              },
              icon: Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                availability(),
                SizedBox(
                  height: 10.h,
                ),
                Divider(color: Colors.black, height: 5.h),
                SizedBox(
                  height: 10.h,
                ),
                Card(
                  color: Colors.white54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        addTimings(),
                        SizedBox(
                          height: 20.h,
                        ),
                        const Text("Added Slots"),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(children: availableSlots()),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: () {
                                // TODO: send data to backend
                              },
                              child: const Center(
                                child: Text("Confirm slots"),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(color: Colors.black, height: 5.h),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white54,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Card(
                    child: nonAvailableDate(context),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(child: const Text("I am not available at this time slot:")),
                              TextButton(
                                  onPressed: () {
                                    DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now().add(const Duration(days: 180)), onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      setState(() {
                                        notAvailableSlots.add(date);
                                      });
                                    }, currentTime: DateTime.now());
                                  },
                                  child: Text(
                                    'Select a slot',
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            ],
                          ),
                          Wrap(
                            spacing: 10.w,
                            children: List.generate(notAvailableSlots.length, (index) {
                              DateTime dateTime = DateTime.parse(notAvailableSlots[index].toString());
                              String text = dateTime.toString().split('.')[0];
                              return InputChip(
                                label: Text(text),
                                onDeleted: () {
                                  setState(() {
                                    notAvailableSlots.remove(notAvailableSlots[index].toString());
                                  });
                                },
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                        style: ButtonStyle(),
                        onPressed: () {
                          // TODO: send data to backend
                        },
                        child: const Center(
                          child: Text("Confirm non availability"),
                        )),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Padding nonAvailableDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(child: Text("I am not available on this Date :")),
              TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime.now().add(Duration(days: 180)), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      setState(() {
                        notAvaliableDate.add(date);
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    'Select Date',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
          Wrap(
            spacing: 10.w,
            children: List.generate(notAvaliableDate.length, (index) {
              DateTime dateTime = DateTime.parse(notAvaliableDate[index].toString());
              String text = dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString();
              return InputChip(
                label: Text(text),
                onDeleted: () {
                  setState(() {
                    notAvaliableDate.remove(notAvaliableDate[index]);
                  });
                },
              );
            }),
          )
        ],
      ),
    );
  }

  availableSlots() {
    List<Widget> addedSlots = [];

    finalSlots.forEach((element) {
      TimeOfDay startTime1 = TimeOfDay(
          hour: int.parse(element[0].toString().split(':')[0]), minute: int.parse(element[0].toString().split(':')[1]));
      TimeOfDay endTime1 = TimeOfDay(
          hour: int.parse(element[1].toString().split(':')[0]), minute: int.parse(element[1].toString().split(':')[1]));

      addedSlots.add(Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  staticCard(
                    "Start time",
                    startTime1.format(context),
                  ),
                  staticCard(
                    "End time",
                    endTime1.format(context),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  staticCard(
                    "Duration",
                    '${element[2]} min',
                  ),
                  staticCard(
                    "Gap",
                    '${element[3]} min',
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Days to repeat"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Wrap(
                              spacing: 3.w,
                              runSpacing: -10.h,
                              children: List.generate(
                                days.length,
                                (index) {
                                  return ChoiceChip(
                                    label: Text(days[index].values.first),
                                    selected: element[4].contains(days[index].keys.first),
                                    onSelected: (val) {},
                                    selectedColor: Colors.green,
                                    disabledColor: Colors.grey.shade100,
                                  );
                                },
                              )),
                        ),
                        deletslot(element),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    });

    if (addedSlots.isEmpty) {
      return [
        const Center(
            child: Card(
                child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("No slots created"),
        )))
      ];
    }

    return addedSlots;
  }

  Widget addTimings() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Slots schedule"),
        ),
        SizedBox(
          height: 10.h,
        ),
        Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text("Start Time"),
                        InkWell(
                          onTap: () async {
                            startTime = await timePicker(context);
                            setState(() {});
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(startTime!.format(context).toString()),
                            ),
                            borderOnForeground: true,
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("End Time"),
                        InkWell(
                          onTap: () async {
                            endTime = await timePicker(context);
                            setState(() {});
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(endTime!.format(context).toString()),
                            ),
                            borderOnForeground: true,
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    durationGap(
                      duration,
                      "Duration",
                      onChanged: (value) {
                        duration = value!;
                        setState(() {});
                      },
                    ),
                    durationGap(
                      gap,
                      "Gap",
                      onChanged: (value) {
                        gap = value!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Days to repeat"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 3.w,
                              runSpacing: -10.h,
                              children: List.generate(
                                days.length,
                                (index) {
                                  int dayNo = days[index].keys.first;
                                  return multiSelectChip(
                                    selectedValues: selectedRepeatDays,
                                    label: days[index],
                                    onSelect: (value) {
                                      setState(() {
                                        selectedRepeatDays.contains(dayNo)
                                            ? selectedRepeatDays.remove(dayNo)
                                            : selectedRepeatDays.add(
                                                dayNo,
                                              );
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          addMoreButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget deletslot(dynamic element) {
    return InkWell(
      onTap: () {
        finalSlots.remove(element);
        setState(() {});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Delete slot"),
              SizedBox(
                width: 1.w,
              ),
              const Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addMoreButton() {
    return InkWell(
      onTap: () {
        if (toDouble(endTime!) > toDouble(startTime!)) {
          List repeatdays = List.unmodifiable(selectedRepeatDays);
          String slotStartTime = '${startTime!.hour}:${startTime!.minute}';
          String slotEndTime = '${endTime!.hour}:${endTime!.minute}';
          finalSlots.add([slotStartTime, slotEndTime, duration, gap, repeatdays]);
          setState(() {});
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid Time : End Time Should not be less than start timne ")));
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add slot"),
              SizedBox(
                width: 10.w,
              ),
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  Column availability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select days you work on"),
          ],
        ),
        Wrap(
          spacing: 3.w,
          children: List.generate(
            days.length,
            (index) {
              int dayNo = days[index].keys.first;
              return multiSelectChip(
                selectedValues: selectedDays,
                label: days[index],
                onSelect: (value) {
                  setState(() {
                    selectedDays.contains(dayNo)
                        ? selectedDays.remove(dayNo)
                        : selectedDays.add(
                            dayNo,
                          );
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
