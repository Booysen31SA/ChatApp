import 'package:chatapp/helper/authenicate.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Signin extends StatefulWidget {
  final Function toggle;
  Signin(this.toggle);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  QuerySnapshot snapshotUserInfo;
  Database database = new Database();
  AuthMethods authMethods = new AuthMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String name = '';

  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  signMeIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveEmailSharedPreference(email.text);

      database.getUserByEmail(email.text).then((val) {
        setState(() {
          snapshotUserInfo = val;
          HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo.documents[0].data["name"]);
        });
      });

      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmailAndPassword(email.text, password.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedinSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRooms()));
        } else {
          HelperFunctions.saveUserLoggedinSharedPreference(false);
          HelperFunctions.saveUserNameSharedPreference('USERNAMEKEY');
          HelperFunctions.saveEmailSharedPreference('USEREMAILKEY');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Authenticate()));
        }
      });
    }
  }

  forgotPassword() {
    if (email.text.isNotEmpty) {
      authMethods.resetPassword(email.text);
      Toast.show('An Email has been sent to change your password', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Toast.show('Please enter your email address', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter correct email";
                              },
                              controller: email,
                              style: textStyle(),
                              decoration: textFieldInputDecoration('Email'),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Password is empty';
                          } else if (val.length < 6) {
                            return 'Password needs to be greater than 6 characters';
                          }
                          return null;
                        },
                        controller: password,
                        style: textStyle(),
                        decoration: textFieldInputDecoration('Password'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          forgotPassword();
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text('Forget Password?', style: textStyle()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dont have an account?',
                            style: mediumtextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                ' Register here',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
