import 'package:antonx_flutter_template/core/models/slot_data_model.dart';
import 'package:antonx_flutter_template/core/models/time_slot.dart';

class ScheduleInfoData {
  ScheduleInfoData({
    required this.schedule,
    required this.slots,
    required this.offdays,
  });

  List<SlotDataModel> schedule;
  List<TimeSlotData> slots;
  List<DateTime> offdays;

  factory ScheduleInfoData.fromJson(Map<String, dynamic> json) =>
      ScheduleInfoData(
        slots: List<TimeSlotData>.from(
            json["slots"].map((x) => TimeSlotData.fromJson(x))),
        schedule: List<SlotDataModel>.from(
            json["schedule"].map((x) => SlotDataModel.fromJson(x))),
        offdays: List<DateTime>.from(
            json["offdays"].map((x) => DateTime.parse(x))),
      );

  Map<String, dynamic> toJson() => {
        "schedule": List<dynamic>.from(schedule.map((x) => x.toJson())),
        "slots": slots,
      };

  List<int> get workingWeeks {
    List<int> workingList = [];
    schedule.map((e) {
      workingList.addAll(e.workingDays);
    }).toList();

    workingList.forEach((element) {
      print("Element: $element");
    });

    return workingList.toSet().toList();
  }

/*  List<DateTime> selectedTimeSlot2(int weekday) {
    List<DateTime> workingList = [];
    schedule.map((e) {
      if (e.workingDays.contains(weekday)) workingList.addAll(e.timeSlot);
    }).toList();
    return workingList.toList();
  }

  Map<int, List<DateTime>> selectedTimeSlot(int weekday) {
    Map<int, List<DateTime>> workingList = {};
    for (int count = 0; count < schedule.length; count++) {
      SlotDataModel e = schedule[count];
      if (e.workingDays.contains(weekday)) workingList[count] = e.timeSlot;
    }
    return workingList;
  }*/
}
