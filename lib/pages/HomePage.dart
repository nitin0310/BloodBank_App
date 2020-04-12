import 'dart:async';

import 'package:bloodroid/authentication/updateProfilePage.dart';
import 'package:bloodroid/pages/FindDonorPage.dart';
import 'package:bloodroid/pages/NotificationPage.dart';
import 'package:bloodroid/pages/ShowPostPage.dart';
import 'package:bloodroid/pages/profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  bool circularIndicator = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      DefaultTabController(
        length: 3,
        child: Scaffold(

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add,color: Colors.white,),
            tooltip: "Request blood",
            backgroundColor: Colors.red[800],
            splashColor: Colors.white,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> FindDonorPage()));
            },
          ),

          appBar: AppBar(
            title: Text("Home Page",style: TextStyle(
                color: Colors.white),),

            actions: <Widget>[

              IconButton(
                icon: Icon(Icons.border_color,color: Colors.white,size: 20.0,),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateProfilePage()));
                },
              ),

              IconButton(
                  icon: Icon(Icons.exit_to_app,color: Colors.white,),
                  onPressed: (){
                    signOutUser();
                  },
              ),

            ],


            backgroundColor: Colors.red[800],
            bottom:
            TabBar(
              tabs: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.map,color: Colors.white,),
                ),
                Icon(Icons.notifications_active),
                Icon(Icons.account_circle)

              ],
              indicatorColor: Colors.white,
              indicatorWeight: 2.5,
            ),
            elevation: 15.0,
          ),
          body:circularIndicator?Center(child: CircularProgressIndicator(),):
             TabBarView(
              children: <Widget>[

                ShowPostPage(),

                NotificationPage(),

                ProfilePage(),

              ],
            ),
        ),
      ),
    );
  }

  Future signOutUser() async{
    getCurrentUser();
    if(currentUser == null){
      print("Current user is null");
    }else{
      auth.signOut();
      Navigator.pop(context);
    }
  }

  Future getCurrentUser() async {
    FirebaseUser user = await auth.currentUser();
    this.currentUser = user;
  }

}
