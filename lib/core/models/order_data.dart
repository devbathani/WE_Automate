import 'package:antonx_flutter_template/core/models/schedule_info.dart';
import 'package:antonx_flutter_template/core/models/service.dart';

class OrderData {
  OrderData({
    required this.consumerId,
    required this.providerId,
    required this.scheduleId,
    required this.timeslotId,
    required this.serviceId,
    required this.status,
    required this.date,
  });

  String consumerId;
  String providerId;
  int scheduleId;
  int timeslotId;
  String status;
  String serviceId;
  String? orderId;
  DateTime date;
  ScheduleInfoData? schedule;
  SErvice? service;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        consumerId: json["consumerId"],
        providerId: json["providerId"],
        scheduleId: json["scheduleId"],
        timeslotId: json["timeslotId"],
        serviceId: json["serviceId"],
        status: json["status"],
        date:  DateTime.fromMillisecondsSinceEpoch(
  json["date"].millisecondsSinceEpoch),
      );

  Map<String, dynamic> toJson() => {
        "consumerId": consumerId,
        "providerId": providerId,
        "scheduleId": scheduleId,
        "timeslotId": timeslotId,
        "serviceId": serviceId,
        "status": status,        "date":  DateTime.fromMillisecondsSinceEpoch(
        date.millisecondsSinceEpoch),
      };
}
