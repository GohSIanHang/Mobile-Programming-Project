import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab2/community.dart';
import 'package:lab2/user.dart';
import 'about.dart';
import 'mainscreen.dart';

double pageOffset = 0;
User user1;

class Homescreen extends StatefulWidget {
  final User user;

  const Homescreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _Homescreen createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> {
  PageController pageController;

  @override
  void initState() {
    print("Hello");
    user1 = widget.user;
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash.jpg'),
                  fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height * 0.5,
          child: PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) {
              return CardPageWidget(pageOffset - index);
            },
            itemCount: 3,
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Yes'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class CardPageWidget extends StatelessWidget {
  final double offset;

  CardPageWidget(this.offset);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));

    if (pageOffset == 2.0) {
      return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
        child: Card(
          color: Colors.blueGrey[800],
          margin: EdgeInsets.fromLTRB(5, 150, 10, 200),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.asset(
                  'assets/images/info.png',
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Transform.translate(
                  offset: Offset(
                      -offset * MediaQuery.of(context).size.width / 2, 0),
                  child: Text(
                    'About Us',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                minWidth: 100,
                height: 100,
                child: Text('Click Us',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                color: Colors.green[500],
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => About()));
                },
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      );
    }
    if (pageOffset == 1.0) {
      return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
        child: Card(
          color: Colors.blueGrey[800],
          margin: EdgeInsets.fromLTRB(10, 150, 10, 200),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.asset(
                  'assets/images/Comm.PNG',
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Transform.translate(
                  offset: Offset(
                      -offset * MediaQuery.of(context).size.width / 2, 0),
                  child: Text(
                    'Community',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),           
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                minWidth: 100,
                height: 100,
                child: Text('Join Us',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                color: Colors.green[500],
                textColor: Colors.white,
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Community(
                                user: user1,
                              )));
                },
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      );
    }
    if (pageOffset == 0.0) {
      return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
        child: Card(
          color: Colors.blueGrey[800],
          margin: EdgeInsets.fromLTRB(5, 150, 10, 200),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.asset(
                  'assets/images/triangle.png',
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Transform.translate(
                  offset: Offset(
                      -offset * MediaQuery.of(context).size.width / 2, 0),
                  child: Text(
                    'Music Market',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                minWidth: 100,
                height: 100,
                child: Text('Explore',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                color: Colors.green[500],
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainScreen(
                                user: user1,
                              )));
                },
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      );
    }
    if (pageOffset < 2.0 || pageOffset < 1.0) {
      return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0),
        child: Card(
          color: Colors.blueGrey[800],
          margin: EdgeInsets.fromLTRB(10, 150, 10, 200),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.asset(
                  'assets/images/grey.png',
                  alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.none,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Transform.translate(
                  offset: Offset(
                      -offset * MediaQuery.of(context).size.width / 2, 0),
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
