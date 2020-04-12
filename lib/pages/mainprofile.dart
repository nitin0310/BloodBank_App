import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {

  int contributions,rewards;
  FirebaseUser currentUser;
  File userImage;
  String userImageUrl = null;
  FirebaseAuth auth = FirebaseAuth.instance;
  StorageReference storageReference;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  CollectionReference collectionReference = Firestore.instance.collection('users');

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

         if(snapshot.connectionState == ConnectionState.none){
           return const Center(child: Text("Internet lost"));
         }else if(snapshot.connectionState == ConnectionState.waiting){
           return Center(child: CircularProgressIndicator(),);
         }else if(!snapshot.hasData) return const Center(child: Text("Loading"),);

         return Column(
          children: <Widget>[
            Container(
              height: 100,
              margin: EdgeInsets.only(
                  top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Card(
                elevation: 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            getImage();
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0)
                                  ),
                                  title: Text("Upload done."),
                                  content: Text("Your profile pic updated successfully.Changes will reflect within few minuts."),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        RaisedButton(
                                          child:Text("Ok",style: TextStyle(color: Colors.white),),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          color: Colors.red[800],
                                        )
                                      ],
                                    )
                                  ],
                                );
                              }
                            );
                          },
                          child: snapshot.data['userImage'].toString() == "null"?
                          CircleAvatar(
                                radius: 34.0,
                                backgroundColor: Colors.red[800],
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage:NetworkImage("https://img.favpng.com/2/17/23/computer-icons-user-login-oxygen-project-png-favpng-aaagjHu7prjeaJspq30q2g3RY.jpg"),
                                  radius: 30.0,
                                ),
                              )
                              :
                          CircleAvatar(
                            radius: 34.0,
                            backgroundColor: Colors.red[800],
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:NetworkImage(snapshot.data['userImage'].toString()),
                              radius: 30.0,
                            ),
                        ),
                        ),

                    GestureDetector(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Contributions",style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800]
                                  ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(snapshot.data['contributions'],style: TextStyle(
                                    fontSize: 18.0,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Rewards",style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800]
                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(snapshot.data['rewards'],style: TextStyle(
                                    fontSize: 18.0,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Future getCurrentUser() async {
    FirebaseUser user = await auth.currentUser();
    setState(() {
      this.currentUser = user;
    });
  }

  Future getImage() async {
    print("get image called");
    File tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      userImage = tempImage;
    });

    uploadImage();
  }

  Future uploadImage() async {
    storageReference = firebaseStorage.ref().child(currentUser.uid.toString());
    StorageUploadTask storageUploadTask = storageReference.putFile(userImage);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    print("Upload image done");
    String url = await snapshot.ref.getDownloadURL();

    Map<String, String> data = {
      'userImage':url.toString()
    };
    collectionReference.document(currentUser.uid.toString()).updateData(data).then((value){
      setState(() {
        userImageUrl = url.toString();
      });
      print("Uploaded successfully");
    }).catchError((e){
      print(e.toString());
    });
  }
}
