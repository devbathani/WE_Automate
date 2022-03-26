class SlotDataModel {
  SlotDataModel({
    required this.start,
    required this.end,
    required this.breakDuration,
    required this.gapDuration,
    required this.workingDays,
    required this.uid,
  });

  DateTime start;
  DateTime end;
  int breakDuration;
  String uid;
  int gapDuration;
  List<int> workingDays;

  factory SlotDataModel.fromJson(Map<String, dynamic> json) => SlotDataModel(
        start: DateTime.parse(json["start"]),
        uid: json["uid"],
        end: DateTime.parse(json["end"]),
        breakDuration: json["breakDuration"],
        gapDuration: json["gapDuration"],
        workingDays: List<int>.from(json["workingDays"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "start": start.toString(),
        "end": end.toString(),
        "breakDuration": breakDuration,
        "gapDuration": gapDuration,
        "workingDays": List<dynamic>.from(workingDays.map((x) => x)),
      };
}
