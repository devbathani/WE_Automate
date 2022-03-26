
import 'package:antonx_flutter_template/core/constants/screen-utils.dart';
import 'package:antonx_flutter_template/core/models/order_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/database_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../locator.dart';

class OrderList extends StatefulWidget {
  bool isProvider;
  OrderList({this.isProvider=false});
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderList> {
  final _localStorageService = locator<LocalStorageService>();
  final _dbService = locator<DatabaseService>();
  ValueNotifier<bool> updateList = ValueNotifier<bool>(false);

  @override
  void initState() {
    print("initState ${widget.isProvider}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation:0.1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Order List",style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderData>>(
          future: _dbService.getOrders(
            widget.isProvider?_localStorageService.accessTokenProvider:
            _localStorageService.accessTokenCustomer,
            isProvider: widget.isProvider
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
              return ValueListenableBuilder(
                valueListenable: updateList,
                builder: (BuildContext context, bool value, Widget? child) {
                  return snapshot.data?.isEmpty==true?
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text("No order found",style: TextStyle(fontWeight: FontWeight.bold),)),
                      )
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length??0,
                    itemBuilder: (context,index){
                      OrderData data = snapshot.data![index];
                      print("Order Data: ${data.orderId} ${data.status}");

                      int duration = data.schedule!.schedule[data.scheduleId].breakDuration;


                      String time = DateFormat("hh:mm a").format(data.schedule!.slots[data.timeslotId].time);
                      String endTime = DateFormat("hh:mm a").format(data.schedule!.slots[data.timeslotId].time.add(Duration(minutes: duration)));
                      String date = DateFormat("EEE dd, MMM yy").format(data.date);

                      var customerName =data.customerName??"";
                      var providerName =data.service?.providerName??"";

                      String name = widget.isProvider?customerName:providerName;


                      print("name: $name ${widget.isProvider} $customerName $providerName ${name} ${data.service?.providerName}");
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.white10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text("${data.service!.title}"),
                                    Text("$name",style: TextStyle(color: Colors.grey),)
                                  ],
                                ),
                                Spacer(),
                                if(widget.isProvider)
                                Column(children:[
                                  Text("${data.status.toUpperCase()}"),
                                  Text("${data.isPaid?"Paid":"Un-Paid"}",style: TextStyle(color: data.isPaid?Colors.green:Colors.orange),),
                                  ]),
                                if(data.status!="reject" && !widget.isProvider)
                                  Column(children:[
                                    Text("${data.status.toUpperCase()}"),
                                    Text("${data.isPaid?"Paid":"Un-Paid"}",style: TextStyle(color: data.isPaid?Colors.green:Colors.orange),),
                                  ])
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text("$date \n"
                                    "$time - $endTime")
                              ],
                            ),
                            if(data.status=="pending" && widget.isProvider)
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        data.status="accept";
                                        _dbService.bookingAction(data.providerId, data.consumerId, data.scheduleId, data.timeslotId,data).then(
                                                (value) {
                                                  if(value)
                                                    updateList.value=!updateList.value;
                                                }
                                        );

                                      }, child: Text( data.status=="accept"?"Accepted":"Accept",style: TextStyle(color: Colors.green),))
                                  ,
                                  SizedBox(width: 10),
                                  TextButton(onPressed: () {
                                    data.status="reject";
                                    _dbService.bookingAction(data.providerId, data.consumerId, data.scheduleId, data.timeslotId,data).then(
                                            (value) {
                                          if(value)
                                            updateList.value=!updateList.value;
                                        }
                                    );

                                  }, child: Text("Reject",style: TextStyle(color: Colors.red),))
                                  ,
                                ],
                              ),
                            if(data.status=="accept" && widget.isProvider)
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        //_dbService.bookingAction(data.providerId, data.consumerId, data.scheduleId, data.timeslotId,"accept");

                                      }, child: Text("Accepted",style: TextStyle(color: Colors.green),))
                                  ,
                                  SizedBox(width: 10),

                                ],
                              ),
                            if(data.status=="reject" && !widget.isProvider)
                      SizedBox(height: 10,),
                            if(data.status=="reject" && !widget.isProvider)
                              Text("Please Re-schedule your order"),
                          ],
                        ),
                      );
                    },
                  );
                },
              );

            }
          }),
    );
  }
}
