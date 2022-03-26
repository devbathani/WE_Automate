
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
      body: Column(
        children: [
          FutureBuilder<List<OrderData>>(
              future: _dbService.getOrders(
                _localStorageService.accessTokenCustomer,
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
                      return  ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length??0,
                        itemBuilder: (context,index){
                          OrderData data = snapshot.data![index];
                          print("Order Data: ${data.orderId} ${data.status}");

                          String time = DateFormat("hh:mm a").format(data.schedule!.slots[data.timeslotId].time);
                          String date = DateFormat("EEE dd, MMM yy").format(data.date);

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.white10)
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("${data.service!.title}"),
                                    Spacer(),
                                    Text("${data.status.toUpperCase()}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text("$date $time")
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
                                  )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );

                }
              }),
        ],
      ),
    );
  }
}
