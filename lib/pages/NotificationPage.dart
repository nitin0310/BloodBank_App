import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  FirebaseUser currentUser;
  CollectionReference collectionReferenceRequests = Firestore.instance.collection('requests');
  CollectionReference collectionReferenceDonorReference;
  String uid;


  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return currentUser == null?Center(child: CircularProgressIndicator(),):
    StreamBuilder<QuerySnapshot>(
      stream: collectionReferenceDonorReference.snapshots(),
      builder: (BuildContext context,snapshot){

        if(snapshot.connectionState == ConnectionState.none){
          return const Center(child: Text("Internet lost"));
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }else if(!snapshot.hasData) return const Center(child: Text("Loading"),);

        return
            snapshot.data.documents.length == 0?
                Center(child: Text("You have 0 notification",style: TextStyle(fontSize: 18.0),),):
            ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                return
                  Container(
                      margin: EdgeInsets.all(10.0),
                      height: 160.0,
                      width: (MediaQuery.of(context).size.width),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.white,
                              Colors.grey[300]
                            ]
                        ),
                      ),

                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.invert_colors,color: Colors.red[800],size: 40.0,),
                            ),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                Row(
                                  children: <Widget>[
                                    Text("Name: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(snapshot.data.documents[index].data['name'].toString()),
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    Text("Contact: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(snapshot.data.documents[index].data['contact'].toString()),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("City: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(snapshot.data.documents[index].data['city'].toString()),
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    Text("State: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(snapshot.data.documents[index].data['state'].toString()),
                                  ],
                                ),


                              ],
                            ),


                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0)
                                    ),
                                    color: Colors.red[800],
                                    child: Text("Delete",style: TextStyle(color: Colors.white),),
                                    onPressed: (){
                                      deleteNotification(snapshot.data.documents[index].documentID);
                                    }),
                              ],
                            ),
                          ],
                        ),
                      )
                  );
              },
            );
      },
    );
  }

  Future getCurrentUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUser = user;
      this.uid = currentUser.uid;
      collectionReferenceDonorReference = Firestore.instance.collection('requests').document(currentUser.uid.toString()).collection('donors');
    });

    print("user received: ${currentUser.uid}");
  }

  Future deleteNotification(String uid){
    collectionReferenceDonorReference.document(uid.toString()).delete().then((value){
      showDialog(
          barrierDismissible: false,
          context: (context),
          builder: (BuildContext context){
            return SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)
                ),
                title: Text("Notification status"),
                content: Text("Delete done."),
                actions: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                    ),
                    color: Colors.red[800],
                    child: Text("Ok",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          }
      );
    }).catchError((e){
      print(e.toString());
    });
  }

}
