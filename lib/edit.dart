import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product.dart';
import 'user.dart';

class Edit extends StatefulWidget {
  final User user;
  final Product datas;

  const Edit({Key key, this.user, this.datas}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String server = "https://gohaction.com/musicsy";
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController budgetEditingController = new TextEditingController();
  TextEditingController roomsEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController descriptionEditingController =
      new TextEditingController();
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  File _image;
  bool _takepicture = true;
  bool _takepicturelocal = false;
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
  void initState() {
    super.initState();
    print("edit Product");
    nameEditingController.text = widget.datas.name;
    descriptionEditingController.text = widget.datas.description;
    typeEditingController.text = widget.datas.type;
    selectedType = widget.datas.type;
    budgetEditingController.text = widget.datas.budget;
    roomsEditingController.text = widget.datas.quantity;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update Your Product'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: server + "/images/${widget.datas.id}.jpg",
                          placeholder: (context, url) =>
                              new SpinKitSpinningCircle(color: Colors.red),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _takepicturelocal,
                        child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: _image == null
                                  ? AssetImage('assets/images/Camera.png')
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ],
                )),
            SizedBox(height: 20),
            Container(
                width: screenWidth / 1.2,
                //height: screenHeight / 2,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    elevation: 20,
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
                                          height: 30,
                                          child: Text(
                                            " " + widget.datas.id,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
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
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: nameEditingController,
                                            keyboardType: TextInputType.text,
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
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
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
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo[900]))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 80,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller:
                                                descriptionEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
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
                                          child: Text("Type",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo[900]))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 40,
                                        child: Container(
                                          height: 40,
                                          child: DropdownButton(
                                            //sorting dropdownoption
                                            hint: Text(
                                              'Type',
                                              style: TextStyle(
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
                                            items: listType.map((selectedType) {
                                              return DropdownMenuItem(
                                                child: new Text(selectedType,
                                                    style: TextStyle(
                                                        color: Colors.black)),
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
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo[900]))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: budgetEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus1,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus2);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
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
                                          child: Text("Available",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo[900]))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: roomsEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus2,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus3);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
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
                                  borderRadius: BorderRadius.circular(20.0)),
                              minWidth: screenWidth / 2.0,
                              height: 40,
                              child: Text('Update Product'),
                              color: Colors.indigo[800],
                              textColor: Colors.white,
                              elevation: 5,
                              onPressed: () => updateDialog(),
                            ),
                          ],
                        )))),
          ],
        )),
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
              ]
            : [
                CropAspectRatioPreset.square,
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
      setState(() {
        _takepicture = false;
        _takepicturelocal = true;
      });
    }
  }

  updateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Product Id " + widget.datas.id,
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
                update();
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

  update() {
    if (nameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
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
    if (budgetEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
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

    double budget = double.parse(budgetEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating Product...");
    pr.show();
    String base64Image;

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post(server + "/php/update_product.php", body: {
        "productid": widget.datas.id,
        "name": nameEditingController.text,
        "description": descriptionEditingController.text,
        "type": typeEditingController.text,
        "budget": budget.toStringAsFixed(2),
        "quantity": roomsEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          Toast.show("Update success", context,
              backgroundColor: Colors.green,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    } else {
      http.post(server + "/php/update_product.php", body: {
        "productid": widget.datas.id,
        "name": nameEditingController.text,
        "description": descriptionEditingController.text,
        "type": typeEditingController.text,
        "budget": budget.toStringAsFixed(2),
        "quantity": roomsEditingController.text,
      }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          Toast.show("Update success", context,
              backgroundColor: Colors.green,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              backgroundColor: Colors.red,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.CENTER);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    }
  }
}
