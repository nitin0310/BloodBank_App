import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowPostPage extends StatefulWidget {
  @override
  _ShowPostPageState createState() => _ShowPostPageState();
}

class _ShowPostPageState extends State<ShowPostPage> {

  FirebaseUser currentUser;
  CollectionReference collectionReferenceRequests = Firestore.instance.collection('requests');
  CollectionReference collectionReferenceUsers = Firestore.instance.collection('users');
  bool myPost = false;
  String uid;
  String donorName,contact,city,state;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null?Center(child: CircularProgressIndicator(),):
        StreamBuilder<QuerySnapshot>(
          stream: collectionReferenceRequests.snapshots(),
          builder: (context,snapshot){

            if(snapshot.connectionState == ConnectionState.none){
              return const Center(child: Text("Internet lost"));
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(!snapshot.hasData) return const Center(child: Text("Loading"),);

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                if(uid == snapshot.data.documents[index].documentID.toString()){
                  myPost = true;
                }
                else{
                  myPost = false;
                }
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: (MediaQuery.of(context).size.width)/4,
                                    width: (MediaQuery.of(context).size.width)/4,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot.data.documents[index].data['userImage'].toString()),
                                      backgroundColor: Colors.grey[400],
                                      radius: 15.0,
                                    )
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(snapshot.data.documents[index].data['name'].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 20.0,),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Blood required: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(snapshot.data.documents[index].data['blood group'].toString()),
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

                              Row(
                                children: <Widget>[
                                  myPost?RaisedButton(
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    elevation: 5.0,
                                    color: Colors.red[800],
                                    child: Text("Can't donate",style: TextStyle(color: Colors.white),),
                                  ):RaisedButton(
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    elevation: 5.0,
                                    onPressed: (){
                                      donateBlood(snapshot.data.documents[index].documentID.toString());
                                    },
                                    color: Colors.red[800],
                                    child: Text("Donate",style: TextStyle(color: Colors.white),),
                                  ),

                                  SizedBox(width: 5.0,),

                                  RaisedButton(
                                    splashColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    elevation: 5.0,
                                    onPressed: (){
                                      showDialog(
                                          barrierDismissible: false,
                                          context: (context),
                                          builder: (BuildContext context){
                                            return SingleChildScrollView(
                                              child: AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25.0)
                                                ),
                                                title: Text("Description by ${snapshot.data.documents[index].data['name'].toString()}"),
                                                content: Text(snapshot.data.documents[index].data['description'].toString()),
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
                                    },
                                    color: Colors.green[800],
                                    child: Text("Description",style: TextStyle(color: Colors.white),),
                                  ),

                                ],
                              )

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
    });

    print("user received: ${currentUser.uid}");
  }

  Future donateBlood(String requestor) async{
    DocumentReference reference = collectionReferenceUsers.document(currentUser.uid);
    reference.get().then((snapshot){
      collectionReferenceRequests.document(requestor).collection('donors').document(currentUser.uid.toString()).setData({
        'name':snapshot.data['username'],
        'contact':snapshot.data['contact'],
        'city':snapshot.data['city'],
        'state':snapshot.data['state'],
      }).then((value){
        print("${currentUser.uid.toString()} donor added successfully");
      }).catchError((e){
        print(e.toString());
      });
    }).catchError((e){
      print(e.toString());
    });
  }

}
