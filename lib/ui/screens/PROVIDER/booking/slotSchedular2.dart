import 'dart:core';

import 'package:antonx_flutter_template/ui/custom_widgets/slot_booking/export_slot_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/schedule_info.dart';
import '../../../../core/models/slot_data_model.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../locator.dart';
import '../booking/slotSchedular.dart' as old;

class SlotSchedular extends StatefulWidget {
  const SlotSchedular({Key? key}) : super(key: key);

  @override
  State<SlotSchedular> createState() => _SlotSchedularState();
}

class _SlotSchedularState extends State<SlotSchedular> {
  ValueNotifier<bool> updateList = ValueNotifier<bool>(false);
  ValueNotifier<bool> updateOffList = ValueNotifier<bool>(false);

  late List<SlotDataModel> slotList;

  List<int> breakDuration = [0, 10, 20, 30, 40, 50, 60];
  List<int> weekdays = [];
  List<DateTime> offDates = [];

  TimeOfDay intiTime = TimeOfDay.now();
  DateTime current = DateTime.now();

  SlotDataModel get newSlot => SlotDataModel(
        uid: _localStorageService.accessTokenProvider,
        start: current,
        end: current.add(Duration(hours: 1)),
        breakDuration: breakDuration[1],
        gapDuration: breakDuration[1],
        workingDays: [],
      );

  final _localStorageService = locator<LocalStorageService>();
  final _dbService = locator<DatabaseService>();

  @override
  void initState() {
    slotList = [newSlot];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return old.SlotSchedular();
              }));
            },
            child: const Text(
              "My Slots",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(onPressed: () {
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back))),
      body:

      FutureBuilder<ScheduleInfoData?>(
          future: _dbService.getScheduleInfo(
            _localStorageService.accessTokenProvider,
          ),
          builder: (context, snapshot) {
            print("OrderList ${snapshot.connectionState}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height/2,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 4,
                  ),
                ),
              );
            }
            else {
              print(snapshot.data);
              if(snapshot.data?.schedule !=null) {
                slotList = snapshot.data!.schedule;
                offDates = snapshot.data!.offdays;
              }
              print("Slot List: ${slotList.length}");

              String buttonTitle = snapshot.data?.schedule !=null?"Update":"Create";
              return SingleChildScrollView(
                child: Container(
                  color: Colors.grey.shade100,
                  padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(snapshot.data?.schedule !=null?"Update Schedule":"Create Schedule"),
                          SizedBox(height: 10),
                          slotListView,
                        ],
                      ),
                      if(snapshot.data?.schedule !=null)
                      offListView,
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () async {
                              await _dbService.createProviderSlots(
                                  _localStorageService.accessTokenProvider,
                                  slotList,
                                  offDates).then((value) {
                                    if(value){
                                      Navigator.pop(context,true);
                                    }
                              });
                            },
                            child: Center(
                              child: Text("$buttonTitle"),
                            )),
                      ),
                      if (false)
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
                    ],
                  ),
                ),
              );

            }
          }),



    );
  }

  Widget get slotListView => ValueListenableBuilder(
        builder: (BuildContext context, value, Widget? child) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: slotList.length,
            itemBuilder: (BuildContext context, int index) {
              SlotDataModel data = slotList[index];
              return createSlot(index, data);
            },
          );
        },
        valueListenable: updateList,
      );

  Widget get offListView => ValueListenableBuilder(
        valueListenable: updateOffList,
        builder: (BuildContext context, bool value, Widget? child) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: const Text(
                              "I am not available at this date:")),
                      TextButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now()
                                    .add(const Duration(days: 180)),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('onConfirm $date');
                              offDates.add(date);
                              updateOffList.value = !updateOffList.value;
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Select Date',
                            style: TextStyle(color: Colors.blue),
                          )),
                    ],
                  ),
                  Wrap(
                    spacing: 5.w,
                    children: List.generate(offDates.length, (index) {
                      DateTime dateTime =
                          DateTime.parse(offDates[index].toString());
                      List text = dateTime.toString().split('.')[0].split(' ');
                      String timeText = text[1]
                          .toString()
                          .substring(0, text[1].toString().length - 3);
                      return InputChip(
                        label: Text(text[0]),
                        onDeleted: () {
                          offDates.removeAt(index);
                          updateOffList.value = !updateOffList.value;
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        },
      );

  int selectedIndex = -1;

  Widget createSlot(int itemIndex, SlotDataModel data) {
    return GestureDetector(
      onTap: () {
        selectedIndex = itemIndex;
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(data.start))
                          .then((value) {
                        if (value == null) return;

                        slotList[itemIndex].start =
                            DateFormat("hh:mm a").parse(value.format(context));
                        slotList[itemIndex].end =
                            slotList[itemIndex].start.add(Duration(hours: 1));
                        updateList.value = !updateList.value;
                      });
                    },
                    child: staticCard(
                        "Start time", DateFormat("hh:mm a").format(data.start)),
                  ),
                  InkWell(
                      onTap: () async {
                        await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(data.end))
                            .then((value) {
                          if (value == null) return;

                          slotList[itemIndex].end = DateFormat("hh:mm a")
                              .parse(value.format(context));
                          updateList.value = !updateList.value;
                        });
                      },
                      child: staticCard(
                          "End time", DateFormat("hh:mm a").format(data.end))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    Text("Duration"),
                    DropdownButton<int>(
                      value: data.breakDuration,
                      iconSize: 0,
                      items: breakDuration.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            '$value min',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        slotList[itemIndex].breakDuration = value!;
                        updateList.value = !updateList.value;
                      },
                    ),
                  ]),
                  Column(children: [
                    Text("Gap"),
                    DropdownButton<int>(
                      value: data.gapDuration,
                      iconSize: 0,
                      items: breakDuration.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            '$value min',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        slotList[itemIndex].gapDuration = value!;
                        updateList.value = !updateList.value;
                      },
                    ),
                  ]),
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
                              children: getWeeksView(itemIndex)),
                        ),
                        Column(
                          children: [
                            addMoreButton(),
                            if (itemIndex != 0) deletslot(itemIndex),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWeeksView(itemIndex) {
    List<Widget> weeks=[];
    for (int chipIndex = 1; chipIndex<8;chipIndex++){
      weeks.add(
          ChoiceChip(
            label: Text(getDay(chipIndex)),
            selected: slotList[itemIndex].workingDays.contains(chipIndex),
            onSelected: (val) {
              print("itemIndex $itemIndex chipIndex $chipIndex $val");
              bool isAdded =
              !slotList[itemIndex].workingDays.contains(chipIndex);
              if (val && isAdded)
                slotList[itemIndex].workingDays.add(chipIndex);
              else
                slotList[itemIndex].workingDays.remove(chipIndex);

              updateList.value = !updateList.value;
            },
            selectedColor: Colors.green,
            disabledColor: Colors.grey.shade100,
          ));

    }
    return weeks;

  }

  Widget deletslot(index) {
    return InkWell(
      onTap: () {
        if (slotList.length > 1) {
          slotList.removeAt(index);
          updateList.value = !updateList.value;
        }
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
        slotList.add(newSlot);
        updateList.value = !updateList.value;
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

  String getDay(int value) {
    switch (value) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "--";
    }
  }
}

