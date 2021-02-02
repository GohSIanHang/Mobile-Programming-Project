import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab2/orderdetailscreen.dart';
import 'package:http/http.dart' as http;
import 'order.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;

  String titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(height: 20),
          Text(
            "Payment History",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _paymentdata == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      //Step 6: Count the data
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: () => loadOrderDetails(index),
                                child: Card(
                                  color: Colors.yellow[50],
                                  elevation: 40,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "\t\t\t\t" + (index + 1).toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            "RM " +
                                                _paymentdata[index]['total'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _paymentdata[index]['orderid'],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                _paymentdata[index]['billid'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          f.format(DateTime.parse(
                                              _paymentdata[index]['date'])),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        flex: 3,
                                      ),
                                      SizedBox(height: 80),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://gohaction.com/musicsy/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                )));
  }
}
