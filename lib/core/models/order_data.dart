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
    required this.isPaid,
    required this.customerName,
  });

  String consumerId;
  String providerId;
  int scheduleId;
  int timeslotId;
  String status;
  String serviceId;
  String customerName;
  String? orderId;
  DateTime date;
  ScheduleInfoData? schedule;
  SErvice? service;
  bool isPaid;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        consumerId: json["consumerId"],
        providerId: json["providerId"],
        scheduleId: json["scheduleId"],
        timeslotId: json["timeslotId"],
        serviceId: json["serviceId"],
        status: json["status"],
    customerName: json["customerName"]??"",
    isPaid: json["isPaid"]??false,
        date:  DateTime.fromMillisecondsSinceEpoch(
  json["date"].millisecondsSinceEpoch),
      );

  Map<String, dynamic> toJson() => {
        "consumerId": consumerId,
        "providerId": providerId,
        "scheduleId": scheduleId,
        "timeslotId": timeslotId,
        "serviceId": serviceId,
        "isPaid": isPaid,
        "customerName": customerName,
        "status": status,        "date":  DateTime.fromMillisecondsSinceEpoch(
        date.millisecondsSinceEpoch),
      };
}
