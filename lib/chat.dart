import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lab2/chatdetail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

int picturetake = 0;
String title1;
String phoneNo;
String pathAsset = 'assets/images/Camera.png';
List arr = [];
List arr1 = [];
List result;
List result1;
List data;
int count;
File _image;
String server = "https://gohaction.com/musicsy";
String titlecenter = "Loading list...";
var selection;
bool _validate = false;
TextEditingController _messcontroller = new TextEditingController();

class ChatPage extends StatefulWidget {
  final String title;
  final String phone;

  static final String id = "ChatPage";

  const ChatPage({Key key, this.title, this.phone}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void initState() {
    print("Hello");
    super.initState();
    _loadData();
    title1 = widget.title;
    phoneNo = widget.phone;
    print(title1);
    picturetake = 0;
    print(picturetake);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    if (data == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Loading chat...'),
            backgroundColor: Colors.black,
          ),
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitHourGlass(color: Colors.red),
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
      return Scaffold(
        appBar: AppBar(
          title: Text("Community Chat"),
          backgroundColor: Colors.grey[700],
          actions: <Widget>[
            Container(
                child: IconButton(
                    icon: Icon(Icons.people_outline_rounded,
                        color: Colors.white, size: 30.0),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Chatdetail()));
                    })),
            // Text(
            //   result.length.toString(),
            //   style: new TextStyle(
            //     fontSize: 20.0,
            //     color: Colors.yellow,
            //   ),
            // ),
            IconButton(
              icon: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String stringValue = count.toString();
                    return StatefulBuilder(
                      builder: (context, newSetState) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          title: Text(
                            "This platform provide user to chat and discuss the musical topics.\n\nThere are " +
                                stringValue +
                                " comments " +
                                result.length.toString() +
                                " users messaging so far\n",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
        body: Container(
          color: Colors.indigo[50],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
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
                  : Flexible(
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _controller,
                          // crossAxisCount: 2,
                          // childAspectRatio: 2,
                          children: List.generate(data.length, (index) {
                            arr.add(data[index]['name']);
                            result = arr.toSet().toList();
                            arr1.add(data[index]['phone']);
                            // print(data[index]['name']);
                            // print(data[index]['phone']);
                            result1 = arr1.toSet().toList();
                            // print("check: ");
                            print(result);
                            print(result1);
                            count = data[index]['rank'];
                            // print(index);
                            // print("count ");
                            // print((data[index]['rank']));
                            // print("row");
                            // print((data[index]['row']));
                            // print(data[index]['name']);
                            // print(data[index]['comment']);
                            // print(data[index]['date']);

                            if (data[index]['name'] == title1) {
                              if (data[index]['imageid'] == null) {
                                return Container(
                                    alignment: Alignment.centerRight,
                                    // color: Colors.white,
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(5),
                                                bottomRight:
                                                    Radius.circular(30),
                                                bottomLeft:
                                                    Radius.circular(25))),
                                        color: Colors.teal[900],
                                        elevation: 30,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 120,
                                              ),
                                              Container(
                                                width: 200,
                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['name'] +
                                                      "  :  " +
                                                      data[index]['date']
                                                          .substring(11, 16),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.blue[100],
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                width: 200,
                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['comment'],
                                                  maxLines: 20,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                            ],
                                          ),
                                        )));
                              } else if (data[index]['imageid'] != null) {
                                return Container(
                                    alignment: Alignment.centerRight,
                                    // color: Colors.white,
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(5),
                                                bottomRight:
                                                    Radius.circular(30),
                                                bottomLeft:
                                                    Radius.circular(25))),
                                        color: Colors.teal[900],
                                        elevation: 30,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 120,
                                              ),
                                              Container(
                                                width: 200,
                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['name'] +
                                                      "  :  " +
                                                      data[index]['date']
                                                          .substring(11, 16),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.blue[100],
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              CachedNetworkImage(
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.scaleDown,
                                                imageUrl:
                                                    "http://gohaction.com/musicsy/chatimages/${data[index]['imageid']}.jpg",
                                                placeholder: (context, url) =>
                                                    new SpinKitHourGlass(
                                                        color: Colors.red),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['comment'],
                                                  maxLines: 20,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                            ],
                                          ),
                                        )));
                              }
                            } else {
                              if (data[index]['imageid'] == null) {
                                return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                                bottomLeft:
                                                    Radius.circular(30))),
                                        color: Colors.blueGrey[900],
                                        elevation: 30,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 120,
                                              ),
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  data[index]['name'] +
                                                      "  :  " +
                                                      data[index]['date']
                                                          .substring(11, 16),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.yellow[200],
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                width: 200,
                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['comment'],
                                                  maxLines: 20,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                            ],
                                          ),
                                        )));
                              } else {
                                return Container(
                                    alignment: Alignment.centerLeft,
                                    // color: Colors.white,
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(25),
                                                bottomRight:
                                                    Radius.circular(25),
                                                bottomLeft:
                                                    Radius.circular(30))),
                                        color: Colors.blueGrey[900],
                                        elevation: 30,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 120,
                                              ),
                                              Container(
                                                width: 200,

                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['name'] +
                                                      "  :  " +
                                                      data[index]['date']
                                                          .substring(11, 16),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.yellow[200],
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              CachedNetworkImage(
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.scaleDown,
                                                imageUrl:
                                                    "http://gohaction.com/musicsy/chatimages/${data[index]['imageid']}.jpg",
                                                placeholder: (context, url) =>
                                                    new SpinKitHourGlass(
                                                        color: Colors.red),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: 200,
                                                // color: Colors.orange,
                                                child: Text(
                                                  data[index]['comment'],
                                                  maxLines: 20,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  textAlign: TextAlign
                                                      .start, // has impact
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                            ],
                                          ),
                                        )));
                              }
                            }
                          }))),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blueGrey[700],
                    width: 15,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title1,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 45, bottom: 15),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Discuss...',
                          errorText: _validate ? 'Text Can\'t Be Empty' : null,
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          icon: Icon(Icons.message_sharp, color: Colors.black),
                        ),
                        controller: _messcontroller,
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(width: 35),
                      IconButton(
                        icon: new Icon(Icons.camera_enhance_sharp),
                        onPressed: () {
                          _choose();
                        },
                      ),
                      Container(
                        child: IconButton(
                          icon: new Icon(Icons.picture_in_picture_alt_sharp),
                          onPressed: () {
                            _chooseGallery();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 130,
                        height: 40,
                        child: Text('Send',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800)),
                        color: Colors.green[700],
                        textColor: Colors.black,
                        elevation: 15,
                        onPressed: () {
                          _userSend();
                          // insert();
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(title: title1)));
                          });
                          _messcontroller.clear();
                        },
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _choose() async {
    picturetake = 1;
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
    setState(() {});

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, newSetState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                "\n\t\t\tYou have taken picture!\n",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _chooseGallery() async {
    picturetake = 1;
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    setState(() {});
  }

  void _userSend() async {
    String username = title1;
    String phoneNumber = phoneNo;
    String comment = _messcontroller.text;

    String urlLoadJob = server + "/php/update_comments.php";

    if (picturetake == 0) {
      if (_messcontroller.text.isEmpty) {
        Toast.show("Empty Text! Please enter your text", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      } else {
        http.post(urlLoadJob, body: {
          "name": username,
          "phone": phoneNumber,
          "comment": comment,
          // "imageid": imageid,
        }).then((res) {
          print(res.body);

          if (res.body == "success") {
            Toast.show("Sent", context,
                backgroundColor: Colors.green,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.CENTER);
            setState(() {});
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatPage()));
          } else {
            Toast.show("sending...", context,
                backgroundColor: Colors.green,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.CENTER);
          }
        }).catchError((err) {
          print(err);
        });
      }
    }
    if (picturetake == 1) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Send picture...");
      String base64Image = base64Encode(_image.readAsBytesSync());
      pr.show();
      http.post(server + "/php/upload_picture.php", body: {
        "name": username,
        "comment": comment,
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
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_comments.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        titlecenter = "Welcome Let's talk";
        setState(() {
          data = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          data = extractdata["datas"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }
}
