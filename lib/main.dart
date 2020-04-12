import 'package:bloodroid/authentication/loginpage.dart';
import 'package:bloodroid/authentication/signuppage.dart';
import 'package:bloodroid/authentication/wrapper.dart';
import 'package:bloodroid/pages/FindDonorPage.dart';
import 'package:bloodroid/pages/profilepage.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
  }
}
