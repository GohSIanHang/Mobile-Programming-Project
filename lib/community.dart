import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab2/chat.dart';
import 'package:lab2/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

int index = 0;
List musicdata;
User user1;
String phoneNo;
String title1;

class Community extends StatelessWidget {
  final User user;

  const Community({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: user.name, phone: user.phone),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final String phone;

  MyHomePage({Key key, this.title, this.phone}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int pageViewIndex;

class _MyHomePageState extends State<MyHomePage> {
  ActionMenu actionMenu;
  final PageController pageController = PageController();
  int currentPageIndex = 0;
  int pageCount = 1;
  String server = "https://gohaction.com/musicsy";

  @override
  void initState() {
    super.initState();
    phoneNo = widget.phone;
    title1 = widget.title;
    actionMenu = ActionMenu(this.addPageView, this.removePageView);
  }

  addPageView() {
    setState(() {
      pageCount++;
    });
  }

  removePageView(BuildContext context) {
    if (pageCount > 1)
      setState(() {
        pageCount--;
      });
    else
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Last page"),
      ));
  }

  navigateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  getCurrentPage(int page) {
    pageViewIndex = page;
  }

  createPage(int page) {
    index = 1;
    if (page == 1) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DetailPage(index);
            }));
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Colors.brown[900],
              Colors.yellow[900],
              Colors.blueGrey[900]
            ])),
            child: Card(
              color: Colors.black,
              elevation: 20,
              margin: EdgeInsets.fromLTRB(20, 100, 20, 200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      bottom: 100,
                      child: Image.asset(
                        'assets/images/1.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Text('Classical Music -' + "\nCommunity",
                          style: GoogleFonts.akronim(
                            textStyle: TextStyle(
                                color: Colors.white, letterSpacing: .5),
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    }
    if (page == 2) {
      index = 2;
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DetailPage(index);
            }));
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Colors.blueGrey[900],
              Colors.blue[600],
              Colors.purple[900],
            ])),
            child: Card(
              color: Colors.black,
              // color: Colors.blueGrey[800],
              elevation: 20,
              margin: EdgeInsets.fromLTRB(20, 100, 20, 200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      bottom: 100,
                      child: Image.asset(
                        'assets/images/2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Text('Modern Music -' + "\nCommunity",
                          style: GoogleFonts.akronim(
                            textStyle: TextStyle(
                                color: Colors.white, letterSpacing: .5),
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    }
    if (page == 3) {
      index = 3;
      if (title1 == "unregistered") {
        return GestureDetector(
            onTap: () {
              Toast.show("Please register to use this function", context,
                  backgroundColor: Colors.red,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER);
            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.purple[900],
                Colors.red[200],
                Colors.grey[800],
              ])),
              child: Card(
                // color: Colors.grey[500],
                color: Colors.black,
                elevation: 20,
                margin: EdgeInsets.fromLTRB(20, 100, 20, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 30,
                        top: 10,
                        bottom: 100,
                        child: Image.asset(
                          'assets/images/3.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Text(
                          'Come & Chat' + "\nCommunity (Restricted)",
                          style: GoogleFonts.akronim(
                            textStyle: TextStyle(
                                color: Colors.white, letterSpacing: .5),
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 60,
                        child: Icon(Icons.people_alt_rounded,
                            color: Colors.white, size: 30.0),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      } else {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChatPage(title: title1, phone: phoneNo)));
            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.purple[900],
                Colors.red[200],
                Colors.grey[900],
              ])),
              child: Card(
                // color: Colors.red[400],
                color: Colors.black,
                elevation: 20,
                margin: EdgeInsets.fromLTRB(20, 100, 20, 200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        right: 30,
                        top: 10,
                        bottom: 100,
                        child: Image.asset(
                          'assets/images/3.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Text(
                          'Come & Chat' + "\nCommunity",
                          style: GoogleFonts.akronim(
                            textStyle: TextStyle(
                                color: Colors.white, letterSpacing: .5),
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 60,
                        child: Icon(Icons.people_alt_rounded,
                            color: Colors.white, size: 30.0),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Welcome! " + widget.title),
        backgroundColor: Colors.grey[800],
        actions: <Widget>[
          actionMenu,
        ],
      ),
      body: Container(
        child: PageView.builder(
          controller: pageController,
          onPageChanged: getCurrentPage,
          // itemCount: pageCount,
          itemBuilder: (context, position) {
            if (position == 3) return null;
            return createPage(position + 1);
          },
        ),
      ),
    );
  }
}

enum MenuOptions { addPageAtEnd, deletePageCurrent }
List<Widget> listPageView = List();

class ActionMenu extends StatelessWidget {
  final Function addPageView, removePageView;
  ActionMenu(this.addPageView, this.removePageView);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.addPageAtEnd:
            this.addPageView();
            break;
          case MenuOptions.deletePageCurrent:
            this.removePageView(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        PopupMenuItem<MenuOptions>(
          value: MenuOptions.addPageAtEnd,
          child: const Text('Add Page at End'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.deletePageCurrent,
          child: Text('Delete Current Page'),
        ),
      ],
    );
  }
}

class DetailPage extends StatefulWidget {
  final index;

  DetailPage(this.index);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final double expandedHeight = 300;
  final double roundedContainerHeight = 50;

  @override
  Widget build(BuildContext context) {
    _loadData();
    if (musicdata == null) {
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
                CircularProgressIndicator(),
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
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                buildSliverHead(),
                SliverToBoxAdapter(child: buildDetail(index)),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 60,
                          color: Colors.cyan[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget buildSliverHead() {
    return SliverPersistentHeader(
      delegate: DetailSliverDelegate(
        expandedHeight,
        roundedContainerHeight,
        widget.index,
      ),
    );
  }

  Widget buildDetail(index) {
    if (index == 1) {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildUserInfo(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Text(
                'Classical music is art music produced or rooted in the traditions of Western culture, including both liturgical (religious) and secular music. While a more precise term is also used to refer to the period from 1750 to 1820 (the Classical period), this article is about the broad span of time from before the 6th century AD to the present day, which includes the Classical period and various other periods. The central norms of this tradition became codified between 1650 and 1900, which is known as the common-practice period,' +
                    "\n\n" +
                    musicdata[0]['intro'],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  fontSize: 20,
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SignInButton(
                Buttons.Facebook,
                mini: true,
                onPressed: () => _launchUrlDialog(),
              ),
              GestureDetector(
                onTap: () => _launchUrlDialog(),
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 0),
                    child: Text(
                      "View More Classical Music On Facebook",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    )),
              ),
            ]),
            SizedBox(height: 80),
          ],
        ),
      );
    }
    ;
    if (index == 2) {
      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildUserInfo(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Text(
                'Our history of modern music begins in the early twentieth century, around the first half of the ’10s when people begin to think for the first time to music (and movies), as a business. It’s thanks to the born of industry that began to spread first early Country records of white music and first Jazz and Blues records of black music.' +
                    "\n\n" +
                    musicdata[1]['intro'],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 80),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              SignInButton(
                Buttons.Facebook,
                mini: true,
                onPressed: () => _launchUrlDialog(),
              ),
              GestureDetector(
                onTap: () => _launchUrlDialog(),
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 0),
                    child: Text(
                      "View More Modern Music On Facebook",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    )),
              ),
            ]),
            SizedBox(height: 80),
          ],
        ),
      );
    }
    ;
    launchUrlDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          if (index == 1) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              title: new Text(
                "Open browser to explore more classical music ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text(
                    "Yes",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _lauchUrl('https://www.facebook.com/Musicians');
                  },
                ),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
          if (index == 2) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              title: new Text(
                "Open browser to explore more modern music ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text(
                    "Yesss",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _lauchUrl('https://www.facebook.com/Musicians');
                  },
                ),
                new FlatButton(
                  child: new Text(
                    "Nooooooooooooo",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }
          ;
        },
      );
    }
  }

  Future<void> _lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_details.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        titlecenter = "no found";
        setState(() {
          musicdata = null;
        });
      } else {
        if (this.mounted) {
          setState(() {
            var extractdata = json.decode(res.body);
            musicdata = extractdata["datas"];
          });
        }
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget buildUserInfo() {
    if (index == 1) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 24,
          backgroundImage: AssetImage('assets/images/Comm.PNG'),
        ),
        title: Text('Classical Music',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            )),
        subtitle: Text('Community'),
        trailing: Icon(Icons.share),
      );
    }
    if (index == 2) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 24,
          backgroundImage: AssetImage('assets/images/Comm.PNG'),
        ),
        title: Text('Modern Music',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            )),
        subtitle: Text('community'),
        trailing: Icon(Icons.share),
      );
    }
  }

  _launchUrlDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        if (index == 1) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: new Text(
              "Open browser to explore more classical music ?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Yessss!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  _lauchUrl('https://www.facebook.com/groups/125749377435975');
                },
              ),
              new FlatButton(
                child: new Text(
                  "No Thanks!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        }
        if (index == 2) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: new Text(
              "Open browser to explore more modern music ?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Yess, Bring it on!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  _lauchUrl('https://www.facebook.com/Musicians');
                },
              ),
              new FlatButton(
                child: new Text(
                  "No Thanks!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        }
      },
    );
  }
}

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double roundedContainerHeight;
  final index;

  DetailSliverDelegate(
      this.expandedHeight, this.roundedContainerHeight, this.index);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (index == 1) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: Hero(
          tag: index,
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/1.jpg',
                color: Color.fromRGBO(200, 100, 5, 0.9),
                colorBlendMode: BlendMode.modulate,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: expandedHeight - roundedContainerHeight - shrinkOffset,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: roundedContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: expandedHeight - 120 - shrinkOffset,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Join Our Classical Music Community',
                        style: GoogleFonts.abhayaLibre(
                          textStyle:
                              TextStyle(color: Colors.white, letterSpacing: .5),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        )),
                    Text(
                      'We will bring you to "Beethoven" era!!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    if (index == 2) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        child: Hero(
          tag: index,
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/2.jpg',
                color: Color.fromRGBO(200, 5, 150, 0.9),
                colorBlendMode: BlendMode.modulate,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: expandedHeight - roundedContainerHeight - shrinkOffset,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: roundedContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: expandedHeight - 120 - shrinkOffset,
                left: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Join Our Modern Music Community',
                        style: GoogleFonts.abhayaLibre(
                          textStyle:
                              TextStyle(color: Colors.white, letterSpacing: .5),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        )),
                    Text(
                      'You Will Be Meme One Day',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    ;
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
