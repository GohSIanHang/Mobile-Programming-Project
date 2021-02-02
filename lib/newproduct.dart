import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  String server = "https://gohaction.com/musicsy";
  double screenHeight, screenWidth;
  File _image;
  var _tapPosition;
  String _scanBarcode = 'click here to scan';
  String pathAsset = 'assets/images/Camera.png';
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController budgetEditingController = new TextEditingController();
  TextEditingController roomsEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController descriptionEditingController =
      new TextEditingController();
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  String selectedType;
  List<String> listType = [
    "Electric Guitar",
    "Guitar",
    "Electric Piano",
    "Cello",
    "Saxophone",
    "Drum",
    "Violin",
    "Piano",
    "Trumpet",
  ];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () => {_choose()},
                    child: Container(
                      height: screenHeight / 4,
                      width: screenWidth / 1.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                      ),
                    )),
                SizedBox(height: 10),
                Text("Click the above image to take picture of your Product",
                    style: TextStyle(fontSize: 15.0, color: Colors.black)),
                SizedBox(height: 20),
                Container(
                    width: screenWidth / 1.2,
                    //height: screenHeight / 2,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        elevation: 30,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Table(
                                    defaultColumnWidth: FlexColumnWidth(1.0),
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 60,
                                              child: Text("Product ID",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.indigo[900],
                                                  ))),
                                        ),
                                        TableCell(
                                            child: Container(
                                          height: 60,
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 60,
                                              child: GestureDetector(
                                                onTap: _showPopupMenu,
                                                onTapDown: _storePosition,
                                                child:
                                                    Text("\t\t" + _scanBarcode,
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.black,
                                                        )),
                                              )),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Product Name",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.indigo[900],
                                                  ))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    nameEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus0);
                                                },
                                                decoration: new InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(5),
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),

                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Description",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.indigo[900]))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 80,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    descriptionEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus0,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus1);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Instruments Type",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.indigo[900]))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 40,
                                            child: Container(
                                              height: 40,
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                hint: Text(
                                                  'Type',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                ), // Not necessary for Option 1
                                                value: selectedType,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedType = newValue;
                                                    print(selectedType);
                                                  });
                                                },
                                                items: listType
                                                    .map((selectedType) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        selectedType,
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            color:
                                                                Colors.black)),
                                                    value: selectedType,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Price",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.indigo[900]))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    budgetEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus1,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus2);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Number Product",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.indigo[900]))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    roomsEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus2,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus3);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                    ]),
                                SizedBox(height: 30),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minWidth: screenWidth / 2.0,
                                  height: 40,
                                  child: Text('Insert New Product'),
                                  color: Colors.indigo[800],
                                  textColor: Colors.white,
                                  elevation: 5,
                                  onPressed: _insertNew,
                                ),
                                SizedBox(height: 10),
                              ],
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _onGetId() {
    scanBarcodeNormal();
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

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        _scanBarcode = "click here to scan";
      } else {
        _scanBarcode = barcodeScanRes;
      }
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
      _scanBarcode = barcodeScanRes;
    });
  }

  void _insertNew() {
    if (_scanBarcode == "click here to scan") {
      Toast.show("Please scan product id", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (_image == null) {
      Toast.show("Please take product photo", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (nameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (roomsEditingController.text.length < 1) {
      Toast.show("Please enter product number", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (budgetEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    if (descriptionEditingController.text.length < 4) {
      Toast.show("Please enter product type", context,
          backgroundColor: Colors.red,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Product Id " + nameEditingController.text,
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
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insert();
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

  insert() {
    double budget = double.parse(budgetEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new product...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(server + "/php/insert_product.php", body: {
      "productid": _scanBarcode,
      "name": nameEditingController.text,
      "description": descriptionEditingController.text,
      "type": selectedType,
      "budget": budget.toStringAsFixed(2),
      "quantity": roomsEditingController.text,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "found") {
        Toast.show("Product id already in database", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            backgroundColor: Colors.green,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  _showPopupMenu() async {
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
              onTap: () => {Navigator.of(context).pop(), _onGetId()},
              child: Text(
                "Scan Barcode",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), scanQR()},
              child: Text(
                "Scan QR Code",
                style: TextStyle(color: Colors.black),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _manCode()},
              child: Text(
                "Manual",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _manCode() {
    TextEditingController pridedtctrl = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Enter Product ID ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Container(
            margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
            height: 30,
            child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                ),
                controller: pridedtctrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  fillColor: Colors.black,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                )),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _scanBarcode = pridedtctrl.text;
                });
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
}
