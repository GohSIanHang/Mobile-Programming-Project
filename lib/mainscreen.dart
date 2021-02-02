import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lab2/admin.dart';
import 'package:lab2/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'homescreen.dart';
import 'profilescreen.dart';
import 'cartscreen.dart';
import 'paymenthistoryscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';

User user1;

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Color active = Colors.white;
  List data;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "All Product";
  String cartquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading list...";
  String server = "https://gohaction.com/musicsy";

  @override
  void initState() {
    super.initState();
    user1 = widget.user;
    _loadData();
    _loadCartQuantity();
    if (widget.user.email == "admin@gmail.com") {
      _isadmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/m1.jpg'),
          AssetImage('assets/images/m2.jpg'),
          AssetImage('assets/images/m3.jpg'),
          AssetImage('assets/images/m4.jpg'),
          AssetImage('assets/images/m5.jpg'),
        ],
        autoplay: true,
        //animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(milliseconds: 1000),
        dotSize: 8.0,
        indicatorBgPadding: 9.0,
      ),
    );
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();

    if (data == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Musical Instrument'),
          ),
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitSpinningCircle(color: Colors.red),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )));
    } else {
      return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            drawer: mainDrawer(context),
            appBar: AppBar(
              title: Text('Musical Instrument'),
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.blueGrey[900],
                Colors.blueGrey[800],
                Colors.blueGrey[900],
              ])),
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
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        MainScreen(
                                                          user: user1,
                                                        )));
                                          },
                                          color: Colors.grey[800],
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.update,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "All Product",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
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
                                          color: Colors.blue[700],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.guitarAcoustic,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Electric Guitar",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
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
                                          color: Colors.blueGrey[900],
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.guitarElectric,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Guitar",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          color: Colors.blue[900],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.piano,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Electric Piano",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          color: Colors.green[700],
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                Icons.library_music_rounded,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Cello",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                              _sortItem("Saxophone"),
                                          color: Colors.blue[600],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.music,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Saxophone",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          color: Colors.blue[900],
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.musicAccidentalFlat,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Drum",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          color: Colors.blueGrey[600],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.violin,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Violin",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          color: Colors.blueGrey[900],
                                          padding: EdgeInsets.all(20.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                MdiIcons.piano,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Piano",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                          color: Colors.indigo[900],
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                Icons.music_off_rounded,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "Trumpet",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                          height: screenHeight / 12,
                          margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                  child: Container(
                                height: 30,
                                child: TextField(
                                    autofocus: false,
                                    controller: _prdController,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.search,
                                            color: Colors.blue[700]),
                                        border: OutlineInputBorder())),
                              )),
                              Flexible(
                                  child: MaterialButton(
                                      color: Colors.blue[900],
                                      onPressed: () => {
                                            _sortItembyName(_prdController.text)
                                          },
                                      elevation: 5,
                                      child: Text(
                                        "Search",
                                        style: TextStyle(color: Colors.white),
                                      )))
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(curtype,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
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
                              childAspectRatio:
                                  (screenWidth / screenHeight) / 0.9,
                              children: List.generate(data.length, (index) {
                                return Container(
                                    alignment: Alignment.centerRight,
                                    child: Card(
                                        color: Colors.transparent,
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () =>
                                                    _onImageDisplay(index),
                                                child: Container(
                                                  height: screenHeight / 5.9,
                                                  width: screenWidth / 3.5,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.scaleDown,
                                                      imageUrl:
                                                          "http://gohaction.com/musicsy/images/${data[index]['id']}.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          new SpinKitHourGlass(
                                                              color:
                                                                  Colors.red),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(data[index]['name'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.blue[200],
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                data[index]['description'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Type: " + data[index]['type'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "RM " + data[index]['budget'],
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.yellow,
                                                ),
                                              ),
                                              Text(
                                                "Available: " +
                                                    data[index]['quantity'],
                                                style: TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red[100],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 100,
                                                height: 40,
                                                child: Text('Add to cart'),
                                                color: Colors.indigo[600],
                                                textColor: Colors.white,
                                                elevation: 10,
                                                onPressed: () =>
                                                    _addtocartdialog(index),
                                              ),
                                            ],
                                          ),
                                        )));
                              })))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (widget.user.email == "unregistered@gmail.com") {
                  Toast.show("Please register to use this function", context,
                      backgroundColor: Colors.red,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER);
                  return;
                } else if (widget.user.email == "admin@gmail.com") {
                  Toast.show(
                    "Admin mode!!!",
                    context,
                    backgroundColor: Colors.red,
                    duration: Toast.LENGTH_LONG,
                    gravity: Toast.CENTER,
                  );
                  return;
                } else if (widget.user.quantity == "0") {
                  Toast.show("Cart empty", context,
                      backgroundColor: Colors.red,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.CENTER);
                  return;
                } else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CartScreen(
                                user: widget.user,
                              )));
                  _loadData();
                  _loadCartQuantity();
                }
              },
              icon: Icon(Icons.add_shopping_cart),
              label: Text(cartquantity),
              backgroundColor: Colors.red[600],
            ),
          ));
    }
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenHeight / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 2,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              server + "/images/${data[index]['id']}.jpg")))),
            ],
          ),
        ));
      },
    );
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_product.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "no found";
        setState(() {
          data = null;
        });
      } else {
        if (this.mounted) {
          setState(() {
            var extractdata = json.decode(res.body);
            data = extractdata["datas"];
            cartquantity = widget.user.quantity;
          });
        }
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
            color: Colors.blueGrey[900],
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName:
                      Text(widget.user.name, style: TextStyle(fontSize: 16.0)),
                  accountEmail:
                      Text(widget.user.email, style: TextStyle(fontSize: 16.0)),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.android
                            ? Colors.black
                            : Colors.black,
                    child: Text(
                      widget.user.name.toString().substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 40.0),
                    ),
                    backgroundImage: NetworkImage(
                        server + "/profileimages/${widget.user.email}.jpg"),
                  ),
                  onDetailsPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProfileScreen(
                                  user: widget.user,
                                )))
                  },
                ),
                Container(
                  width: 50,
                  color: Colors.blueGrey[900],
                  child: Text(
                    "   RM " + widget.user.credit,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
                _buildDivider(),
                ListTile(
                    leading: Icon(Icons.view_list, color: Colors.indigo),
                    title: Text(
                      "Market Place",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right, color: Colors.indigo),
                    onTap: () => {
                          Navigator.pop(context),
                          _loadData(),
                        }),
                _buildDivider(),
                ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.indigo),
                    title: Text(
                      "Shopping Cart",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right, color: Colors.indigo),
                    onTap: () => {
                          Navigator.pop(context),
                          gotoCart(),
                        }),
                _buildDivider(),
                ListTile(
                    leading: Icon(Icons.history, color: Colors.indigo),
                    title: Text(
                      "Payment History",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right, color: Colors.indigo),
                    onTap: _paymentScreen),
                _buildDivider(),
                ListTile(
                    leading: Icon(Icons.supervised_user_circle,
                        color: Colors.indigo),
                    title: Text(
                      "Edit User Profile",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right, color: Colors.indigo),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfileScreen(
                                        user: widget.user,
                                      )))
                        }),
                _buildDivider(),
                Visibility(
                  visible: _isadmin,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 20,
                        color: Colors.black,
                      ),
                      Center(
                        child: Text(
                          "Admin Menu",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      ListTile(
                          leading: Icon(Icons.music_note, color: Colors.green),
                          title: Text(
                            "Manage Product",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          trailing:
                              Icon(Icons.arrow_right, color: Colors.green),
                          onTap: () => {
                                Navigator.pop(context),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Admin(
                                              user: widget.user,
                                            )))
                              }),
                      ListTile(
                        leading: Icon(Icons.verified_user, color: Colors.green),
                        title: Text(
                          "Customer Orders",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_right, color: Colors.green),
                      ),
                      ListTile(
                        leading: Icon(Icons.receipt, color: Colors.green),
                        title: Text(
                          "Report",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_right, color: Colors.green),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: active,
    );
  }

  _addtocartdialog(int index) {
    if (widget.user.email == "unregistered@gmail.com") {
      Toast.show("Please register to use this function", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (widget.user.email == "admin@gmail.com") {
      Toast.show("Admin Mode!!!", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + data[index]['name'] + " to list?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select number of product of musical instrument",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(data[index]['quantity']) - 10)) {
                                  quantity++;
                                } else {
                                  Toast.show("Product not available", context,
                                      backgroundColor: Colors.red,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.CENTER);
                                }
                              })
                            },
                            child: Icon(MdiIcons.plus, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
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
            );
          });
        });
  }

  void _addtoCart(int index) {
    if (widget.user.email == "unregistered@gmail.com") {
      Toast.show("Please register first", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (widget.user.email == "admin@gmail.com") {
      Toast.show("Admin mode", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    try {
      int cquantity = int.parse(data[index]["quantity"]);
      print(cquantity);
      print(data[index]["id"]);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add Now...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "productid": data[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed to Add", context,
                backgroundColor: Colors.red,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.CENTER);
            pr.hide();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Successfully Added", context,
                backgroundColor: Colors.green,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.CENTER);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });
        pr.hide();
      } else {
        Toast.show("No product", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      }
    } catch (e) {
      Toast.show("Failed to Added", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
    }
  }

  void _sortItem(String type) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = server + "/php/load_product.php";
    http.post(urlLoadJobs, body: {
      "type": type,
    }).then((res) {
      setState(() {
        curtype = type;
        var extractdata = json.decode(res.body);
        data = extractdata["datas"];
        FocusScope.of(context).requestFocus(new FocusNode());
        pr.hide();
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItembyName(String prname) {
    print(prname);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = server + "/php/load_product.php";
    http.post(urlLoadJobs, body: {
      "name": prname.toString(),
    }).then((res) {
      if (res.body == "nodata") {
        Toast.show("not found", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        pr.hide();
        setState(() {
          titlecenter = "No Found";
          curtype = "search for " + "'" + prname + "'";
          data = null;
        });
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
    }).catchError((err) {
      pr.hide();
    });
    pr.hide();
  }

  gotoCart() async {
    if (widget.user.email == "unregistered@gmail.com") {
      Toast.show("Please register to use this function", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    } else if (widget.user.email == "admin@gmail.com") {
      Toast.show("Admin mode!!!", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: new Text(
              'Do you want to exit marketplace?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Homescreen(
                                  user: user1,
                                )));
                  },
                  child: Text(
                    "Exit",
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
        ) ??
        false;
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@gmail.com") {
      Toast.show("Please register to use this function", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    } else if (widget.user.email == "admin@gmail.com") {
      Toast.show("Admin mode!!!", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistoryScreen(
                  user: widget.user,
                )));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    _loadData();
    return null;
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
