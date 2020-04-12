import 'package:bloodroid/authentication/landingpage.dart';
import 'package:bloodroid/authentication/loginpage.dart';
import 'package:bloodroid/authentication/signuppage.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return LandingPage();
  }
}
