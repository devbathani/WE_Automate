class TimeSlotData {
  TimeSlotData({
    required this.time,
    required this.scheduleId,
    this.selected = false,
    this.customerId = "",
    this.status = "",
    required this.id
  });

  DateTime time;
  int scheduleId;
  int id;
  bool selected;
  String? customerId;
  String? status;

  factory TimeSlotData.fromJson(Map<String, dynamic> json) => TimeSlotData(
        time: DateTime.fromMillisecondsSinceEpoch(
            json["time"].millisecondsSinceEpoch),
        scheduleId: json["scheduleId"],
        id: json["id"],
        customerId: json["customerId"],
    status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "scheduleId": scheduleId,
        "time": time,
        "customerId": customerId,
        "status": status,
        "id": id,
      };
}
