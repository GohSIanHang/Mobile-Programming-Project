import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lab2/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'mainscreen.dart';
import 'payment.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final User user;
  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<String, Marker> _markers = {};
  String server = "https://gohaction.com/musicsy";
  List cartData;
  double latitude1, longitude2;
  double screenHeight, screenWidth;
  bool _selfPickup = true;
  bool _homeDelivery = false;
  double _totalbudget = 0.0;
  double _totalbudget1 = 0.0;
  Position _currentPosition;
  String curaddress;
  bool _storeCredit = false;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  CameraPosition _userpos;
  double charge;
  double amountpayable;
  String titlecenter = "Loading";
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _timeController.text = 'Select Time --:--';
    super.initState();
    latitude1 = 6.4676929;
    longitude2 = 100.5067673;
    _getLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: Text('My Cart'), actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.deleteEmpty, color: Colors.red),
            onPressed: () {
              deleteAll();
            },
          ),
        ]),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Colors.grey[900],
              Colors.blueGrey[900],
              Colors.blueGrey[900],
              Colors.blueGrey[800],
              Colors.blueGrey[700]
            ])),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 3,
                ),
                SizedBox(
                  height: 15,
                ),
                cartData == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        titlecenter,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
                    : Expanded(
                        child: ListView.builder(
                            itemCount:
                                cartData == null ? 1 : cartData.length + 2,
                            itemBuilder: (context, index) {
                              if (index == cartData.length) {
                                return Container(
                                    height: screenHeight / 1.5,
                                    width: screenWidth / 1.5,
                                    child: InkWell(
                                      onLongPress: () => {print("Delete")},
                                      child: Card(
                                        //color: Colors.yellow,
                                        elevation: 5,

                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: <Color>[
                                                      Colors.grey[900],
                                                      Colors.blueGrey[900],
                                                      Colors.blueGrey[900],
                                                      Colors.blueGrey[800],
                                                      Colors.blueGrey[700]
                                                    ])),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: double.infinity,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: <Color>[
                                                      Colors.blue[600],
                                                      Colors.blue[900],
                                                      Colors.indigo[400],
                                                    ])),
                                                child: Text(
                                                  "Select Your Delivery Options",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .wavy,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: <Color>[
                                                        Colors.white,
                                                        Colors.blue[100],
                                                        Colors.white
                                                      ])),
                                                  width: screenWidth / 1.4,
                                                  height: screenHeight / 4.5,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Checkbox(
                                                            value: _selfPickup,
                                                            onChanged:
                                                                (bool value) {
                                                              _onSelfPickUp(
                                                                  value);
                                                            },
                                                          ),
                                                          Text(
                                                            "Self Pickup",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      MaterialButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0)),
                                                        minWidth: 60,
                                                        height: 60,
                                                        color:
                                                            Colors.indigo[600],
                                                        onPressed: () => {
                                                          _selectTime(context)
                                                        },
                                                        child: Icon(
                                                          MdiIcons.watch,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(height: 15),
                                                      Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(
                                                                height: 20),
                                                            Text(
                                                              _timeController
                                                                  .text,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                                height: 20),

                                                            // Container(

                                                            //     width: 20,
                                                            //     child: IconButton(
                                                            //         iconSize:
                                                            //             32,
                                                            //         icon: Icon(Icons
                                                            //             .watch),
                                                            //         onPressed:
                                                            //             () => {
                                                            //                   _selectTime(context)
                                                            //                 })),
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: <Color>[
                                                        Colors.white,
                                                        Colors.blue[100],
                                                        Colors.white
                                                      ])),
                                                  //color: Colors.blue,
                                                  width: screenWidth / 1.4,
                                                  //height: screenHeight / 3,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Checkbox(
                                                            value:
                                                                _homeDelivery,
                                                            onChanged:
                                                                (bool value) {
                                                              _onHomeDelivery(
                                                                  value);
                                                            },
                                                          ),
                                                          Text(
                                                            "Standard Delivery",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      MaterialButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0)),
                                                        minWidth: 60,
                                                        height: 60,
                                                        color: Colors.green[700],
                                                        onPressed: () =>
                                                            {_loadMapDialog()},
                                                        child: Icon(
                                                          MdiIcons
                                                              .locationEnter,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text("Current Address:",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                      Row(
                                                        children: <Widget>[
                                                          Text("  "),
                                                          Flexible(
                                                            child: Text(
                                                              curaddress ??
                                                                  "Address not set",
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ));
                              }

                              if (index == cartData.length + 1) {
                                return Container(
                                    // height: screenHeight / 3,
                                    child: Card(
                                  elevation: 5,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 25,
                                        width: double.infinity,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: <Color>[
                                                Colors.red[200],
                                                Colors.red[900],
                                                Colors.pink[400],
                                              ])),
                                          child: Text(
                                            "Payment Details",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              decorationStyle:
                                                  TextDecorationStyle.wavy,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(50, 0, 50, 0),
                                          //color: Colors.red,
                                          child: Table(
                                              defaultColumnWidth:
                                                  FlexColumnWidth(1.0),
                                              columnWidths: {
                                                0: FlexColumnWidth(7),
                                                1: FlexColumnWidth(3),
                                              },

                                              //border: TableBorder.all(color: Colors.white),
                                              children: [
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 20,
                                                        child: Text("Subtotal ",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text(
                                                          "RM" +
                                                                  _totalbudget
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 20,
                                                        child: Text(
                                                            "Shipping Fee (3%)",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text(
                                                          "RM" +
                                                                  charge
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 20,
                                                        child: Text(
                                                            "Deduct Store Credit RM" +
                                                                widget.user
                                                                    .credit,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Switch(
                                                        value: _storeCredit,
                                                        onChanged:
                                                            (bool value) {
                                                          _onStoreCredit(value);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 20,
                                                        child: Text(
                                                            "Total Amount ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text(
                                                          "RM" +
                                                                  amountpayable
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ),
                                                ]),
                                              ])),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minWidth: 130,
                                        height: 40,
                                        child: Text('PAY'),
                                        color: Colors.red[700],
                                        textColor: Colors.white,
                                        elevation: 10,
                                        onPressed: makePayment,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ));
                              }
                              index -= 0;
                              SizedBox(height: 60);
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  elevation: 10,
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 9,
                                              width: screenWidth / 4.0,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: server +
                                                    "/images/${cartData[index]['id']}.jpg",
                                                placeholder: (context, url) =>
                                                    new SpinKitHourGlass(
                                                        color: Colors.blue),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                                width: 80.0,
                                                height: 80.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 1, 2, 1),
                                            child: SizedBox(
                                                width: 2,
                                                child: Container(
                                                  height: screenWidth / 3.5,
                                                  color: Colors.grey,
                                                ))),
                                        Container(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: <Color>[
                                                  Colors.white,
                                                  Colors.indigo[100],
                                                  Colors.white
                                                ])),
                                            width: screenWidth / 1.65,
                                            //color: Colors.blue,
                                            child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Container(
                                                          child: Text(
                                                            cartData[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Container(
                                                          child: Text(
                                                            "Left " +
                                                                cartData[index][
                                                                    'quantity'],
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Container(
                                                          child: Text(
                                                            "Quantity Taken : " +
                                                                cartData[index][
                                                                    'cquantity'],
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                          height: 20,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _updateCart(
                                                                      index,
                                                                      "add")
                                                                },
                                                                child: Icon(
                                                                    MdiIcons
                                                                        .plus,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              Text(
                                                                cartData[index][
                                                                    'cquantity'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _updateCart(
                                                                      index,
                                                                      "remove")
                                                                },
                                                                child: Icon(
                                                                  MdiIcons
                                                                      .minus,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Text(
                                                              "Total RM " +
                                                                  cartData[index]
                                                                      [
                                                                      'yourbudget'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _deleteCart(index)
                                                            },
                                                            child: Icon(
                                                                MdiIcons.delete,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ])));
                            })),
              ],
            )));
  }

  void _loadCart() {
    _totalbudget = 0;
    amountpayable = 0;
    charge = 0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating...");
    pr.show();
    String urlLoadJobs = server + "/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _totalbudget = int.parse(cartData[i]['yourbudget']) + _totalbudget;
        }

        amountpayable = _totalbudget;
        print(_totalbudget);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    String _hour, _minute, _time;
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Item not available", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = server + "/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "productid": cartData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Updated", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete list?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                  "productid": cartData[index]['id'],
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        backgroundColor: Colors.red,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.CENTER);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.green),
              )),
        ],
      ),
    );
  }

  void _onSelfPickUp(bool newValue) => setState(() {
        _selfPickup = newValue;
        if (_selfPickup) {
          _homeDelivery = false;
          _updatePayment();
        } else {
          //_homeDelivery = true;
          _updatePayment();
        }
      });

  void _onStoreCredit(bool newValue) => setState(() {
        _storeCredit = newValue;
        if (_storeCredit) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _onHomeDelivery(bool newValue) {
    //_getCurrentLocation();
    _getLocation();
    setState(() {
      _homeDelivery = newValue;
      if (_homeDelivery) {
        _updatePayment();
        _selfPickup = false;
      } else {
        _updatePayment();
      }
    });
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(latitude1, longitude2);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    final CameraPosition _currPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        bearing: 0,
        tilt: 0,
        zoom: 17);

    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currPosition));
    print("${first.featureName} : ${first.addressLine}");
  }


  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(10),
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                title: Text(
                  "Select Your Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titlePadding: EdgeInsets.all(0),
                actions: <Widget>[
                  Text(
                    "Current Address: " +
                        curaddress +
                        "\n\nLatitude: " +
                        latitude1.toString() +
                        "\nLongitude: " +
                        longitude2.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: screenHeight / 1.8,
                    width: screenWidth / 1,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 80,
                        height: 30,
                        child: Text('Find Me'),
                        color: Colors.green,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () {
                          _getLocation();
                        },
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 80,
                        height: 30,
                        child: Text('Close'),
                        color: Colors.red,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {markers.clear(), Navigator.of(context).pop(false)},
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude1 = loc.latitude;
      longitude2 = loc.longitude;
      _getLocationfromlatlng(latitude1, longitude2, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 17,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude1, longitude2),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }

  void _updatePayment() {
    _totalbudget = 0.0;
    _totalbudget1 = 0.0;
    amountpayable = 0.0;
    charge = 0.0;

    setState(() {
      for (int i = 0; i < cartData.length; i++) {
        _totalbudget = int.parse(cartData[i]['yourbudget']) + _totalbudget;
      }
      print(_selfPickup);
      if (_selfPickup == true) {
        _totalbudget = _totalbudget;
        _totalbudget1 = _totalbudget;
      }

      if (_homeDelivery == true) {
        charge = _totalbudget * 0.03;
        _totalbudget = _totalbudget + charge;
      }
      if (_storeCredit) {
        amountpayable = _totalbudget - double.parse(widget.user.credit);
      } else {
        amountpayable = _totalbudget;
      }
      print("charge:" + charge.toStringAsFixed(3));
      print(_totalbudget);
    });
  }

  Future<void> makePayment() async {
    if (amountpayable < 0) {
      double newamount = amountpayable * -1;
      await _payusingstorecredit(newamount);
      _loadCart();
      return;
    }
    if (_selfPickup) {
      print("PICKUP");
      Toast.show("Self Pickup", context,
          backgroundColor: Colors.green,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    } else if (_homeDelivery) {
      print("HOME DELIVERY");
      Toast.show("Home Delivery", context,
          backgroundColor: Colors.green,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    } else {
      Toast.show("Please select delivery option", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(orderid);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: _totalbudget.toStringAsFixed(2),
                  orderid: orderid,
                )));

    _loadCart();
  }

  Future<void> _payusingstorecredit(double newamount) async {
    //insert carthistory
    //remove cart content
    //update product quantity
    //update credit in user
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(message: "Updating...");
    pr.show();
    String urlPayment = server + "/php/paymentsc.php";
    await http.post(urlPayment, body: {
      "userid": widget.user.email,
      "amount": _totalbudget.toStringAsFixed(2),
      "orderid": generateOrderid(),
      "newcr": newamount.toStringAsFixed(2)
    }).then((res) {
      print(res.body);
      pr.hide();
    }).catchError((err) {
      print(err);
    });
  }

  String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    return orderid;
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all product?',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        backgroundColor: Colors.red,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.CENTER);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.green,
                ),
              )),
        ],
      ),
    );
  }
}
