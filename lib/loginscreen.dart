import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lab2/registerscreen.dart';
import 'package:lab2/user.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';

import 'homescreen.dart';

void main() => runApp(Loginscreen());
bool rememberMe = false;

class Loginscreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Loginscreen> {
  bool _validate = false;
  bool _isHidePassword = true;
  double screenHeight;
  TextEditingController _emcontroller = new TextEditingController();
  TextEditingController _pscontroller = new TextEditingController();
  String urlLogin = "http://gohaction.com/musicsy/php/login_user.php";

  @override
  void initState() {
    this.loadPref();
    print('Init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
        child: Center(
            child: SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10),
      //padding: EdgeInsets.only(left: 10, right: 10, top: 80, bottom: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 8,
            color: Colors.grey[850],
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.grey[900],
                Colors.blueGrey[900],
                Colors.blueGrey[900],
                Colors.blueGrey[800],
                Colors.blueGrey[700]
              ])),
              padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 10, bottom: 15),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        errorText: _validate ? 'Email Can\'t Be Empty' : null,
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        icon: Icon(Icons.email, color: Colors.white),
                      ),
                      controller: _emcontroller,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 10, bottom: 15),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility();
                              },
                              child: Icon(
                                _isHidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _isHidePassword
                                    ? Colors.grey
                                    : Colors.white,
                              )),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          errorText:
                              _validate ? 'Password Can\'t Be Empty' : null,
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          icon: Icon(Icons.lock, color: Colors.white)),
                      controller: _pscontroller,
                      obscureText: _isHidePassword,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: rememberMe,
                          onChanged: (bool value) {
                            _onRememberMeChanged(value);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Remember Me',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 180,
                      height: 40,
                      child: Text('Login',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      color: Colors.green[700],
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: this._userLogin,
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account yet? ",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => RegisterScreen()));
                },
                child: Text(
                  "Sign up",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot your password? ",
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Reset password",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    )));
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.music_note_sharp,
            size: 40,
            color: Colors.red,
          ),
          Text(
            " MUSICSY",
            style: TextStyle(
                fontSize: 35, color: Colors.black, fontWeight: FontWeight.w900),
          ),
          Icon(
            Icons.music_note_sharp,
            size: 40,
            color: Colors.pink[900],
          ),
        ],
      ),
    );
  }

  void _userLogin() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    pr.show();
    String email = _emcontroller.text;
    String password = _pscontroller.text;

    setState(() {
      _emcontroller.text.isEmpty ? _validate = true : _validate = false;
      _pscontroller.text.isEmpty ? _validate = true : _validate = false;
    });
    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      var string = res.body;
      print(res.body);
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
          name: userdata[1],
          email: email,
          password: password,
          phone: userdata[3],
          credit: userdata[4],
          datereg: userdata[5],
          quantity: userdata[6],
        );
        pr.hide();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Homescreen(
                      user: _user,
                    )));
      } else {
        pr.hide();
        Toast.show("Login failed", context,
            backgroundColor: Colors.red,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.CENTER);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text("Enter your recovery email",
                    style: TextStyle(fontSize: 16.0, color: Colors.white)),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text("No"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text("Exit"),
                textColor: Colors.blue,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancel"),
                textColor: Colors.blue,
              ),
            ],
          ),
        ) ??
        false;
  }

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emcontroller.text = email;
        _pscontroller.text = password;
        rememberMe = true;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void savepref(bool value) async {
    String email = _emcontroller.text;
    String password = _pscontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          backgroundColor: Colors.green,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emcontroller.text = '';
        _pscontroller.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          backgroundColor: Colors.green,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
}
