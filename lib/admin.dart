import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab2/edit.dart';
import 'package:lab2/newproduct.dart';
import 'package:lab2/product.dart';
import 'package:lab2/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Admin extends StatefulWidget {
  final User user;

  const Admin({Key key, this.user}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List data;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading List...";
  var _tapPosition;
  String server = "https://gohaction.com/musicsy";
  String scanPrId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/m4.jpg'),
          AssetImage('assets/images/m2.jpg'),
          AssetImage('assets/images/m3.jpg'),
          AssetImage('assets/images/m1.jpg'),
        ],
        autoplay: true,
        //animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
      ),
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Your List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: _visible
                ? new Icon(Icons.expand_more)
                : new Icon(Icons.expand_less),
            onPressed: () {
              setState(() {
                if (_visible) {
                  _visible = false;
                } else {
                  _visible = true;
                }
              });
            },
          ),

          //
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            image_carousel,
            Visibility(
              visible: _visible,
              child: Card(
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("recent"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.update,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "All Product",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        _sortItem("Electric Guitar"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.free_breakfast,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Electric Guitar",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Guitar"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.collections,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Guitar",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        _sortItem("Electric Piano"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.payment,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Electric Piano",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Cello"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.book,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Cello",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Saxophone"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.event_busy,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Saxophone",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Drum"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.event_busy,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Drum",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Violin"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.event_busy,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Violin",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Piano"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.event_busy,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Piano",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortItem("Trumpet"),
                                    color: Colors.green[300],
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(
                                          Icons.event_busy,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Trumpet",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ))),
            ),
            Visibility(
                visible: _visible,
                child: Card(
                  elevation: 5,
                  child: Container(
                    height: screenHeight / 12.5,
                    margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                            child: Container(
                          height: 30,
                          child: TextField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              autofocus: false,
                              controller: _prdController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  border: OutlineInputBorder())),
                        )),
                        Flexible(
                            child: MaterialButton(
                                color: Colors.green[300],
                                onPressed: () =>
                                    {_sortItembyName(_prdController.text)},
                                elevation: 5,
                                child: Text(
                                  "Search Product",
                                  style: TextStyle(color: Colors.white),
                                )))
                      ],
                    ),
                  ),
                )),
            Text(curtype,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            data == null
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
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.65,
                        children: List.generate(data.length, (index) {
                          return Container(
                              child: InkWell(
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
                                  child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 5.9,
                                              width: screenWidth / 3.5,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: server +
                                                      "/images/${data[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new SpinKitSpinningCircle(
                                                          color: Colors.red),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(data[index]['name'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            Text(
                                              "Description: " +
                                                  data[index]['description'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              "Type: " + data[index]['type'],
                                              maxLines: 1,
                                            ),
                                            Text(
                                              "RM:" + data[index]['budget'],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Available:" +
                                                  data[index]['quantity'] +
                                                  "/" +
                                                  data[index]['sold'],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))));
                        })))
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.new_releases),
              label: "New Product",
              labelBackgroundColor: Colors.white,
              onTap: createNewProduct),
          SpeedDialChild(
              child: Icon(Icons.report),
              label: "Product Report",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => null),
        ],
      ),
    );
  }

  void scanProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Select scan options:",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text(
                    "Bar Code",
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanQR,
                  elevation: 5,
                  child: Text(
                    "QR Code",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadSingleProduct(String id) {
    String urlLoadJobs = server + "/php/load_product.php";
    http.post(urlLoadJobs, body: {
      "id": id,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        Toast.show(
          "Not found",
          context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          data = extractdata["datas"];
          print(data);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanPrId = "";
      } else {
        scanPrId = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanPrId);
      }
    });
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/load_product.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["datas"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_product.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            curtype = type;
            titlecenter = "No found";
            data = null;
          });
          pr.hide();
          return;
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            data = extractdata["datas"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.hide();
          });
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_product.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  backgroundColor: Colors.red,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER);
              pr.hide();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              data = extractdata["datas"];
              FocusScope.of(context).requestFocus(new FocusNode());
              curtype = prname;
              pr.hide();
            });
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    } catch (e) {
      Toast.show("Error", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    }
  }

  gotoCart() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
    }
  }

  _onDetail(int index) async {
    print(data[index]['name']);
    Product datas = new Product(
        id: data[index]['id'],
        name: data[index]['name'],
        description: data[index]['description'],
        type: data[index]['type'],
        budget: data[index]['budget'],
        quantity: data[index]['quantity'],
        date: data[index]['date']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Edit(
                  user: widget.user,
                  datas: datas,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _onDetail(index)},
              child: Text(
                "Update Product?",
                style: TextStyle(
                  color: Colors.green,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _deleteDialog(index)},
              child: Text(
                "Delete ?",
                style: TextStyle(color: Colors.green),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Id " + data[index]['id'],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting...");
    pr.show();
    String productid = data[index]['id'];
    print("productid:" + productid);
    http.post(server + "/php/delete_product.php", body: {
      "productid": productid,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct()));
    _loadData();
  }
}
