import 'package:Shrine/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _displayNameController = new TextEditingController();
  bool _isLoading;
  bool _autoValidate;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _autoValidate = false;
  }

  void _register() async {
    setState(() {
      _autoValidate = true;
      _isLoading = true;
    });

    if (_signUpFormKey.currentState.validate()) {
      FirebaseUser _user;

      try {
        _user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = _displayNameController.text;
        await _user.updateProfile(userUpdateInfo);
        await _user.reload();
        _user = await FirebaseAuth.instance.currentUser();

        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: _user,
        );
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
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 24),
            Form(
              key: _signUpFormKey,
              child: Column(
                children: <Widget>[
                  AccentColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      autovalidate: _autoValidate,
                      validator: (String value) {
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  AccentColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidate: _autoValidate,
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
                  SizedBox(height: 12),
                  AccentColorOverride(
                    color: kShrineBrown900,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      autovalidate: _autoValidate,
                      validator: (String value) {
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
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
                          _signUpFormKey.currentState.reset();
                          setState(() {
                            _autoValidate = false;
                          });
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
                            : Text('REGISTER'),
                        elevation: 8,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        disabledColor: Theme.of(context).primaryColor,
                        onPressed: _isLoading ? null : _register,
                      ),
                    ],
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
