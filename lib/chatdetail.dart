import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat.dart';

class Chatdetail extends StatefulWidget {
  @override
  _SearchListWidgetState createState() => _SearchListWidgetState();
}

class _SearchListWidgetState extends State<Chatdetail> {
  final initList = List<String>.generate(result.length, (i) => result[i]);
  TextEditingController editingController = TextEditingController();
  var showItemList = List<String>();

  @override
  void initState() {
    showItemList.addAll(initList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Participants Details'),
          backgroundColor: Colors.indigo,
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              controller: editingController,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              keyboardType: TextInputType.name,
              onChanged: (value) {
                filterSearch(value);
              },
            ),
            SizedBox(height: 30),
            Text(result.length.toString() + " participants",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: showItemList.length,
                  // children: List.generate(data.length, (index) {

                  // }
                  itemBuilder: (context, index) {
                    // CircleAvatar(
                    //     backgroundColor:
                    //         Theme.of(context).platform == TargetPlatform.android
                    //             ? Colors.black
                    //             : Colors.black,
                    //     child: Text(
                    //       result[index].toString().substring(0, 1).toUpperCase(),
                    //       style: TextStyle(fontSize: 30.0),
                    //     ),
                    //   );
                    return ListTile(
                      title: Text(
                          (index + 1).toString() + ' : ${showItemList[index]}',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, newSetState) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[900],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  actions: <Widget>[
                                    Container(
                                      height: 250,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(5),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          left: 65,
                                          top: 100,
                                          child: Text(
                                            "Username: " +
                                                result[index].toString() +
                                                "\t\t\t\n\n" +
                                                "Phone No: " +
                                                result1[index].toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            left: 130,
                                            top: 10,
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundColor:
                                                  Theme.of(context).platform ==
                                                          TargetPlatform.android
                                                      ? Colors.indigo
                                                      : Colors.red,
                                              child: Text(
                                                result[index]
                                                    .toString()
                                                    .substring(0, 1)
                                                    .toUpperCase(),
                                                style:
                                                    TextStyle(fontSize: 45.0),
                                              ),
                                            )),
                                        Positioned(
                                          left: 100,
                                          bottom: 3,
                                          child: IconButton(
                                            icon: Icon(Icons.phone_enabled,
                                                color: Colors.white,
                                                size: 30.0),
                                            onPressed: () => launch(
                                                "tel://${result1[index].toString()}"),
                                          ),
                                        ),
                                        Positioned(
                                          left: 180,
                                          bottom: 3,
                                          child: IconButton(
                                            icon: Icon(Icons.message_rounded,
                                                color: Colors.white,
                                                size: 30.0),
                                            onPressed: () => _textMe(
                                                result1[index].toString()),
                                          ),
                                        )
                                      ]),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        )));
  }

  _textMe(String mess) async {

    // Android
    String uri = 'sms:+60'+ mess;
    print(mess);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri = 'sms:0039-222-060-888?body=hello%20there';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  filterSearch(String query) {
    List<String> searchList = List<String>();
    searchList.addAll(initList);
    if (query.isNotEmpty) {
      List<String> resultListData = List<String>();
      searchList.forEach((item) {
        if (item.contains(query)) {
          resultListData.add(item);
        }
      });
      setState(() {
        showItemList.clear();
        showItemList.addAll(resultListData);
      });
      return;
    } else {
      setState(() {
        showItemList.clear();
        showItemList.addAll(initList);
      });
    }
  }
}
