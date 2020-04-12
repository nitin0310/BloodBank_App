import 'dart:async';

import 'package:bloodroid/pages/mainprofile.dart';
import 'package:bloodroid/pages/mainprofile2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var dateday = DateTime.now().day;
  var datemonth = DateTime.now().month;
  var dateyear = DateTime.now().year;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                MainProfile(),
                MainProfile2(),

                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Date: ",style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    Text("${dateday}/ ${datemonth}/ ${dateyear}",style: TextStyle(
                      fontSize: 17.0,
                    ),)
                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: (MediaQuery.of(context).size.width)/1.2,
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.red[800],
                  ),
                )
              ],
            )
          ],

        ),
      ),
    );
  }

}

