import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List _orderdetails;
  String titlecenter = "Loading order details...";
  double screenHeight, screenWidth;
  String server = "https://gohaction.com/musicsy";

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(
            "Order Details",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _orderdetails == null
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
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.yellow,
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "\t\t\t\t\t" +
                                                (index + 1).toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                            padding: EdgeInsets.all(3),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: server +
                                                  "/images/${_orderdetails[index]['id']}.jpg",
                                              placeholder: (context, url) =>
                                                  new SpinKitSpinningCircle(
                                                      color: Colors.red),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(Icons.error),
                                            )),
                                      ),
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "\t\t\tProduct: " +
                                                    _orderdetails[index]
                                                        ['name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.indigo[900]),
                                              ),
                                              Text(
                                                "\t\t\tRM " +
                                                    _orderdetails[index]
                                                        ['budget'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange[900]),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                        child: Text(
                                          "\t\t\t\t\t\t\t\tQuantity: " +
                                              _orderdetails[index]['cquantity'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        flex: 3,
                                      ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  _loadOrderDetails() async {
    String urlLoadJobs =
        "https://gohaction.com/musicsy/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
