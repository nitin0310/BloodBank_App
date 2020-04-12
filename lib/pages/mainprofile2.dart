import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainProfile2 extends StatefulWidget {
  @override
  _MainProfile2State createState() => _MainProfile2State();
}

class _MainProfile2State extends State<MainProfile2> {


  FirebaseUser currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return currentUser == null?Center(child: CircularProgressIndicator(),):
      StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document(currentUser.uid.toString()).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: Text("Don't have data"),);
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else {
          return Container (
            color: Colors.white,
            margin: EdgeInsets.only (
              top: 40.0,
              left: 20.0,
              right: 20.0,
            ),
            height: 230.0,
            width: MediaQuery
                .of ( context )
                .size
                .width,
            child: Card (
              elevation: 15.0,
              child: Padding (
                padding: const EdgeInsets.all( 8.0 ),
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row (
                      children: <Widget>[
                        Text ( "Name: ", style: TextStyle (
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800] ), ),
                        Text ( snapshot.data['username'] ),
                      ],
                    ),
                    Row (
                      children: <Widget>[
                        Text ( "Contact: ", style: TextStyle (
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800] ), ),
                        Text ( snapshot.data['contact'] ),
                      ],
                    ),
                    Row (
                      children: <Widget>[
                        Text ( "Blood Gp: ", style: TextStyle (
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800] ), ),
                        Text ( snapshot.data['blood group'] ),
                      ],
                    ),
                    Text ( "Location:" ),
                    Row (
                      children: <Widget>[
                        Text ( "City: ", style: TextStyle (
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800] ), ),
                        Text ( snapshot.data['city'] ),
                      ],
                    ),
                    Row (
                      children: <Widget>[
                        Text ( "State: ", style: TextStyle (
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800] ), ),
                        Text ( snapshot.data['state'] ),
                      ],
                    ),
                    Row (
                      children: <Widget>[
                        Text ( "Country: ", style: TextStyle (
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800] ), ),
                        Text ( "India" ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }
      }
    );
  }

  Future getCurrentUser() async{
    FirebaseUser user = await auth.currentUser();
    setState(() {
      this.currentUser = user;
    });
  }
}
