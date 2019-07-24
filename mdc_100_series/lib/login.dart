// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _isLoading;
  bool _autovalidate;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _autovalidate = false;
    _emailController = new TextEditingController()
      ..addListener(() => setState(() {
            if (_emailController.text != '') _autovalidate = true;
          }));
    _passwordController = new TextEditingController()
      ..addListener(() => setState(() {
            if (_passwordController.text != '') _autovalidate = true;
          }));
  }

  _signIn() async {
    setState(() {
      _isLoading = true;
    });
    FirebaseUser _user;

    if (_loginFormKey.currentState.validate()) {
      try {
        _user = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(e.message),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'OK',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ],
          ),
        );
      }

      Navigator.pushReplacementNamed(context, '/home', arguments: _user);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(
                  'Yes',
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              SizedBox(height: 80.0),
              Hero(
                tag: 'logo',
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/diamond.png'),
                    SizedBox(height: 16.0),
                    Text('SHRINE'),
                  ],
                ),
              ),
              SizedBox(height: 120.0),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    AccentColorOverride(
                      color: kShrineBrown900,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidate: _autovalidate,
                        validator: (String value) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Email format is invalid';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    AccentColorOverride(
                      color: kShrineBrown900,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        autovalidate: _autovalidate,
                        validator: (String value) {
                          if (value.length < 6) {
                            return 'Password must be longer than 6 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text('CANCEL'),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          onPressed: () {
                            _emailController.clear();
                            _passwordController.clear();
                          },
                        ),
                        RaisedButton(
                          child: _isLoading
                              ? Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : Text('LOGIN'),
                          elevation: 8,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          disabledColor: Theme.of(context).primaryColor,
                          onPressed: _isLoading ? null : _signIn,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      ),
    );
  }
}
